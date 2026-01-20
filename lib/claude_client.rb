require 'httparty'
require 'json'

module ClaudeDialogue
  class ClaudeClient
    API_URL = 'https://api.anthropic.com/v1/messages'
    
    def initialize(api_key, instance_name, system_prompt = nil)
      @api_key = api_key
      @instance_name = instance_name
      @system_prompt = system_prompt
    end
    
    def send_message(content, max_tokens: 4096)
      headers = {
        'Content-Type' => 'application/json',
        'x-api-key' => @api_key,
        'anthropic-version' => '2023-06-01'
      }
      
      body = {
        model: 'claude-sonnet-4-20250514',
        max_tokens: max_tokens,
        messages: [
          {
            role: 'user',
            content: content
          }
        ]
      }
      
      body[:system] = @system_prompt if @system_prompt
      
      response = HTTParty.post(
        API_URL,
        headers: headers,
        body: body.to_json,
        timeout: 120
      )
      
      if response.success?
        parse_response(response.parsed_response)
      else
        raise "API Error: #{response.code} - #{response.body}"
      end
    rescue => e
      { error: e.message, instance: @instance_name }
    end
    
    private
    
    def parse_response(data)
      {
        content: data['content']&.first&.dig('text') || '',
        tokens: data['usage']&.dig('output_tokens') || 0,
        instance: @instance_name
      }
    end
  end
end
