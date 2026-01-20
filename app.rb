require 'sinatra/base'
require 'sinatra/json'
require 'sequel'
require 'json'
require_relative 'lib/database'
require_relative 'lib/orchestrator'

module ClaudeDialogue
  class App < Sinatra::Base
    set :port, 4567
    set :bind, '0.0.0.0'
    set :public_folder, File.dirname(__FILE__) + '/public'
    set :views, File.dirname(__FILE__) + '/views'
    
    # Initialize database
    configure do
      DB = Database.setup
      set :db, DB
    end
    
    # Helper to get API key
    helpers do
      def api_key
        ENV['ANTHROPIC_API_KEY'] || settings.api_key
      end
      
      def validate_api_key!
        halt 500, json(error: 'ANTHROPIC_API_KEY not set') unless api_key
      end
    end
    
    # Homepage
    get '/' do
      erb :index
    end
    
    # API: Start new conversation
    post '/api/conversations' do
      validate_api_key!
      
      request.body.rewind
      data = JSON.parse(request.body.read)
      
      prompt = data['prompt']
      stopping_condition = data['stopping_condition'] || 'max_turns:10'
      claude_a_prompt = data['claude_a_system_prompt']
      claude_2_prompt = data['claude_2_system_prompt']
      
      halt 400, json(error: 'Prompt required') if prompt.nil? || prompt.empty?
      
      orchestrator = Orchestrator.new(settings.db, api_key)
      conversation_id = orchestrator.start_conversation(
        prompt, 
        stopping_condition,
        claude_a_prompt: claude_a_prompt,
        claude_2_prompt: claude_2_prompt
      )
      
      json(
        conversation_id: conversation_id,
        status: 'started',
        message: 'Conversation initiated'
      )
    end
    
    # API: Get conversation status
    get '/api/conversations/:id' do
      conversation_id = params[:id].to_i
      orchestrator = Orchestrator.new(settings.db, api_key, conversation_id)
      status = orchestrator.get_conversation_status
      
      halt 404, json(error: 'Conversation not found') unless status
      
      json(status)
    end
    
    # API: List all conversations
    get '/api/conversations' do
      conversations = settings.db[:conversations]
        .order(Sequel.desc(:created_at))
        .limit(50)
        .all
      
      json(conversations: conversations)
    end
    
    # Status page for a conversation
    get '/conversation/:id' do
      @conversation_id = params[:id].to_i
      erb :conversation
    end
    
    # Server-Sent Events endpoint for real-time updates
    get '/api/conversations/:id/stream', provides: 'text/event-stream' do
      stream :keep_open do |out|
        conversation_id = params[:id].to_i
        orchestrator = Orchestrator.new(settings.db, api_key, conversation_id)
        
        # Send updates every 2 seconds
        EventMachine::PeriodicTimer.new(2) do
          status = orchestrator.get_conversation_status
          
          if status
            out << "data: #{status.to_json}\n\n"
            
            # Close stream if conversation is complete
            if status[:conversation][:status] != 'active'
              out.close
            end
          end
        end
      end
    end
    
    # CLI endpoint
    post '/cli/start' do
      validate_api_key!
      
      prompt = params[:prompt]
      stopping_condition = params[:stopping_condition] || 'max_turns:10'
      
      halt 400, 'Prompt required' if prompt.nil? || prompt.empty?
      
      orchestrator = Orchestrator.new(settings.db, api_key)
      conversation_id = orchestrator.start_conversation(prompt, stopping_condition)
      
      "Conversation started with ID: #{conversation_id}\n" \
      "View status at: http://localhost:4567/conversation/#{conversation_id}\n"
    end
  end
end
