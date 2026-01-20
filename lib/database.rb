require 'sequel'

module ClaudeDialogue
  class Database
    def self.setup(db_path = 'db/claude_dialogue.db')
      db = Sequel.sqlite(db_path)
      
      # Create conversations table
      db.create_table? :conversations do
        primary_key :id
        String :title, text: true
        String :initial_prompt, text: true
        String :stopping_condition, default: 'max_turns:10'
        String :status, default: 'active' # active, completed, error
        Integer :turn_count, default: 0
        DateTime :created_at
        DateTime :completed_at
      end
      
      # Create messages table
      db.create_table? :messages do
        primary_key :id
        foreign_key :conversation_id, :conversations, on_delete: :cascade
        String :claude_instance # 'claude_a' or 'claude_2'
        String :role # 'user', 'assistant'
        String :content, text: true
        Integer :turn_number
        Float :tokens_used
        DateTime :created_at
        
        index [:conversation_id, :turn_number]
      end
      
      # Create summaries table
      db.create_table? :summaries do
        primary_key :id
        foreign_key :conversation_id, :conversations, on_delete: :cascade
        String :summary_text, text: true
        Integer :up_to_turn
        DateTime :created_at
      end
      
      db
    end
  end
end
