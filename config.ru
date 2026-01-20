require './app'

# Set API key from environment
ClaudeDialogue::App.set :api_key, ENV['ANTHROPIC_API_KEY']

run ClaudeDialogue::App
