require_relative 'spec_helper'
require_relative '../lib/database'

RSpec.describe ClaudeDialogue::Database do
  let(:db) { ClaudeDialogue::Database.setup(':memory:') }
  
  describe '.setup' do
    it 'creates conversations table' do
      expect(db.table_exists?(:conversations)).to be true
    end
    
    it 'creates messages table' do
      expect(db.table_exists?(:messages)).to be true
    end
    
    it 'creates summaries table' do
      expect(db.table_exists?(:summaries)).to be true
    end
  end
  
  describe 'conversations table' do
    it 'can insert and retrieve conversations' do
      conv_id = db[:conversations].insert(
        title: 'Test',
        initial_prompt: 'Test prompt',
        status: 'active',
        turn_count: 0,
        created_at: Time.now
      )
      
      conv = db[:conversations].where(id: conv_id).first
      expect(conv[:title]).to eq('Test')
      expect(conv[:status]).to eq('active')
    end
    
    it 'has default values' do
      conv_id = db[:conversations].insert(
        title: 'Test',
        initial_prompt: 'Test prompt',
        created_at: Time.now
      )
      
      conv = db[:conversations].where(id: conv_id).first
      expect(conv[:status]).to eq('active')
      expect(conv[:turn_count]).to eq(0)
      expect(conv[:stopping_condition]).to eq('max_turns:10')
    end
  end
  
  describe 'messages table' do
    it 'can insert and retrieve messages' do
      conv_id = db[:conversations].insert(
        title: 'Test',
        initial_prompt: 'Test',
        created_at: Time.now
      )
      
      msg_id = db[:messages].insert(
        conversation_id: conv_id,
        claude_instance: 'claude_a',
        role: 'user',
        content: 'Hello',
        turn_number: 1,
        created_at: Time.now
      )
      
      msg = db[:messages].where(id: msg_id).first
      expect(msg[:content]).to eq('Hello')
      expect(msg[:claude_instance]).to eq('claude_a')
    end
    
    it 'cascades on conversation delete' do
      conv_id = db[:conversations].insert(
        title: 'Test',
        initial_prompt: 'Test',
        created_at: Time.now
      )
      
      db[:messages].insert(
        conversation_id: conv_id,
        claude_instance: 'claude_a',
        role: 'user',
        content: 'Hello',
        turn_number: 1,
        created_at: Time.now
      )
      
      db[:conversations].where(id: conv_id).delete
      
      expect(db[:messages].where(conversation_id: conv_id).count).to eq(0)
    end
  end
end
