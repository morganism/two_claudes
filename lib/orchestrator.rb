require_relative 'claude_client'
require_relative 'database'

module ClaudeDialogue
  class Orchestrator
    attr_reader :conversation_id, :db
    
    def initialize(db, api_key, conversation_id = nil)
      @db = db
      @api_key = api_key
      @conversation_id = conversation_id
      @conversations = @db[:conversations]
      @messages = @db[:messages]
      @summaries = @db[:summaries]
    end
    
    def start_conversation(initial_prompt, stopping_condition = 'max_turns:10', 
                          claude_a_prompt: nil, claude_2_prompt: nil)
      
      # Create conversation record
      @conversation_id = @conversations.insert(
        title: initial_prompt[0..100],
        initial_prompt: initial_prompt,
        stopping_condition: stopping_condition,
        status: 'active',
        turn_count: 0,
        created_at: Time.now
      )
      
      # Initialize Claude instances
      @claude_a = ClaudeClient.new(
        @api_key, 
        'claude_a',
        claude_a_prompt || "You are Claude A, engaged in a dialogue with Claude 2."
      )
      
      @claude_2 = ClaudeClient.new(
        @api_key,
        'claude_2', 
        claude_2_prompt || "You are Claude 2, engaged in a dialogue with Claude A."
      )
      
      # Store initial user prompt
      store_message('claude_a', 'user', initial_prompt, 0)
      
      # Start the dialogue loop
      run_dialogue(initial_prompt, stopping_condition)
      
      @conversation_id
    end
    
    def run_dialogue(initial_prompt, stopping_condition)
      current_prompt = initial_prompt
      turn = 0
      max_turns = parse_stopping_condition(stopping_condition)
      
      Thread.new do
        begin
          while !should_stop?(turn, max_turns, current_prompt)
            turn += 1
            
            # Claude A responds
            response_a = @claude_a.send_message(current_prompt)
            
            if response_a[:error]
              mark_conversation_error(response_a[:error])
              break
            end
            
            store_message('claude_a', 'assistant', response_a[:content], turn, response_a[:tokens])
            update_turn_count(turn)
            
            # Generate summary every 3 turns
            generate_summary(turn) if turn % 3 == 0
            
            break if should_stop?(turn, max_turns, response_a[:content])
            
            # Claude 2 responds to Claude A
            response_2 = @claude_2.send_message(response_a[:content])
            
            if response_2[:error]
              mark_conversation_error(response_2[:error])
              break
            end
            
            store_message('claude_2', 'assistant', response_2[:content], turn, response_2[:tokens])
            update_turn_count(turn)
            
            # Claude 2's response becomes the next prompt for Claude A
            current_prompt = response_2[:content]
            
            # Small delay to avoid rate limiting
            sleep(1)
          end
          
          mark_conversation_complete
        rescue => e
          mark_conversation_error(e.message)
        end
      end
    end
    
    def get_conversation_status
      conv = @conversations.where(id: @conversation_id).first
      return nil unless conv
      
      {
        conversation: conv,
        messages: @messages.where(conversation_id: @conversation_id).order(:turn_number, :id).all,
        latest_summary: @summaries.where(conversation_id: @conversation_id).order(:up_to_turn).last
      }
    end
    
    private
    
    def store_message(instance, role, content, turn, tokens = 0)
      @messages.insert(
        conversation_id: @conversation_id,
        claude_instance: instance,
        role: role,
        content: content,
        turn_number: turn,
        tokens_used: tokens,
        created_at: Time.now
      )
    end
    
    def update_turn_count(turn)
      @conversations.where(id: @conversation_id).update(turn_count: turn)
    end
    
    def generate_summary(turn)
      messages = @messages
        .where(conversation_id: @conversation_id)
        .where { turn_number <= turn }
        .order(:turn_number, :id)
        .all
      
      summary_text = messages.map { |m| 
        "#{m[:claude_instance].upcase} (Turn #{m[:turn_number]}): #{m[:content][0..100]}..." 
      }.join("\n")
      
      @summaries.insert(
        conversation_id: @conversation_id,
        summary_text: summary_text,
        up_to_turn: turn,
        created_at: Time.now
      )
    end
    
    def parse_stopping_condition(condition)
      if condition.start_with?('max_turns:')
        condition.split(':').last.to_i
      else
        10 # default
      end
    end
    
    def should_stop?(turn, max_turns, content)
      return true if turn >= max_turns
      return true if content.to_s.downcase.include?('[end conversation]')
      false
    end
    
    def mark_conversation_complete
      @conversations.where(id: @conversation_id).update(
        status: 'completed',
        completed_at: Time.now
      )
    end
    
    def mark_conversation_error(error_msg)
      @conversations.where(id: @conversation_id).update(
        status: 'error',
        completed_at: Time.now
      )
      
      store_message('system', 'error', "Error: #{error_msg}", 
                   @conversations.where(id: @conversation_id).get(:turn_count))
    end
  end
end
