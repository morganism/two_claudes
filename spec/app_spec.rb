require_relative 'spec_helper'

RSpec.describe ClaudeDialogue::App do
  describe 'GET /' do
    it 'returns the homepage' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Claude Dialogue')
    end
  end
  
  describe 'GET /api/conversations' do
    it 'returns empty list when no conversations' do
      get '/api/conversations'
      expect(last_response).to be_ok
      
      data = JSON.parse(last_response.body)
      expect(data['conversations']).to eq([])
    end
    
    it 'returns conversations when they exist' do
      # Create a test conversation
      db = app.settings.db
      conv_id = db[:conversations].insert(
        title: 'Test Conversation',
        initial_prompt: 'Test prompt',
        status: 'active',
        turn_count: 0,
        created_at: Time.now
      )
      
      get '/api/conversations'
      expect(last_response).to be_ok
      
      data = JSON.parse(last_response.body)
      expect(data['conversations'].length).to eq(1)
      expect(data['conversations'][0]['title']).to eq('Test Conversation')
    end
  end
  
  describe 'POST /api/conversations' do
    before do
      app.set :api_key, 'test-api-key'
    end
    
    it 'requires a prompt' do
      post '/api/conversations', {}.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq(400)
      
      data = JSON.parse(last_response.body)
      expect(data['error']).to include('Prompt required')
    end
    
    it 'creates a conversation with valid prompt' do
      # Mock the orchestrator to avoid actual API calls
      allow_any_instance_of(ClaudeDialogue::Orchestrator).to receive(:start_conversation).and_return(1)
      
      payload = {
        prompt: 'Test prompt',
        stopping_condition: 'max_turns:5'
      }
      
      post '/api/conversations', payload.to_json, { 'CONTENT_TYPE' => 'application/json' }
      expect(last_response.status).to eq(200)
      
      data = JSON.parse(last_response.body)
      expect(data['status']).to eq('started')
      expect(data['conversation_id']).to be_a(Integer)
    end
  end
  
  describe 'GET /api/conversations/:id' do
    it 'returns 404 for non-existent conversation' do
      get '/api/conversations/999'
      expect(last_response.status).to eq(404)
    end
    
    it 'returns conversation data when it exists' do
      # Create test data
      db = app.settings.db
      conv_id = db[:conversations].insert(
        title: 'Test Conversation',
        initial_prompt: 'Test prompt',
        status: 'active',
        turn_count: 1,
        created_at: Time.now
      )
      
      db[:messages].insert(
        conversation_id: conv_id,
        claude_instance: 'claude_a',
        role: 'user',
        content: 'Test message',
        turn_number: 0,
        created_at: Time.now
      )
      
      get "/api/conversations/#{conv_id}"
      expect(last_response).to be_ok
      
      data = JSON.parse(last_response.body)
      expect(data['conversation']['id']).to eq(conv_id)
      expect(data['messages'].length).to eq(1)
    end
  end
  
  describe 'GET /conversation/:id' do
    it 'returns the conversation page' do
      get '/conversation/1'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Conversation #1')
    end
  end
end
