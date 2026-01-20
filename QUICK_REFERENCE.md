# Quick Reference

## Installation & Setup

```bash
# One-time setup
./setup.sh
export ANTHROPIC_API_KEY='your-key'

# Start server
ruby app.rb

# Visit
http://localhost:4567
```

## CLI Commands

```bash
# Basic
./bin/claude-dialogue -p "Your prompt here"

# With options
./bin/claude-dialogue \
  -p "Discuss AI safety" \
  -s max_turns:20 \
  -a "You are cautious about AI" \
  -2 "You are optimistic about AI"

# All options
-p, --prompt PROMPT          Initial prompt (required)
-a, --claude-a PROMPT        System prompt for Claude A
-2, --claude-2 PROMPT        System prompt for Claude 2
-s, --stop CONDITION         Stopping condition (default: max_turns:10)
-H, --host HOST              Server host (default: localhost)
-P, --port PORT              Server port (default: 4567)
-j, --json                   Output as JSON
-h, --help                   Show help
```

## API Endpoints

### Start Conversation
```bash
POST /api/conversations
Content-Type: application/json

{
  "prompt": "Your initial prompt",
  "stopping_condition": "max_turns:10",
  "claude_a_system_prompt": "Optional system prompt",
  "claude_2_system_prompt": "Optional system prompt"
}
```

### Get Conversation
```bash
GET /api/conversations/:id
```

### List Conversations
```bash
GET /api/conversations
```

## Rake Tasks

```bash
rake spec              # Run tests
rake start             # Start server
rake dev               # Start with auto-reload
rake db_reset          # Reset database
rake db_console        # Open database console
rake stats             # Show statistics
rake clean             # Clean temporary files
```

## File Locations

```
app.rb                 # Main application
config.ru              # Rack config
lib/                   # Core library code
├── database.rb        # Database setup
├── claude_client.rb   # API client
└── orchestrator.rb    # Conversation logic
views/                 # HTML templates
public/                # Static assets
├── css/style.css      # Styles
└── js/                # JavaScript
bin/claude-dialogue    # CLI executable
db/                    # SQLite database
spec/                  # Tests
```

## Environment Variables

```bash
ANTHROPIC_API_KEY      # Required: Your API key
PORT                   # Optional: Server port (default: 4567)
RACK_ENV               # Optional: development/production/test
```

## Stopping Conditions

- `max_turns:N` - Stop after N conversation turns
- Include `[END CONVERSATION]` in response to stop early

## Database Schema

### conversations
- id, title, initial_prompt, stopping_condition
- status (active/completed/error), turn_count
- created_at, completed_at

### messages
- id, conversation_id, claude_instance (claude_a/claude_2)
- role (user/assistant), content, turn_number
- tokens_used, created_at

### summaries
- id, conversation_id, summary_text
- up_to_turn, created_at

## Tips

1. **System Prompts**: Give each Claude a distinct role or perspective
2. **Turn Limits**: 10 turns for quick chats, 20-50 for deep discussions
3. **Monitoring**: Watch conversations in real-time via web UI
4. **Export**: Use API to fetch conversations as JSON
5. **Debugging**: Check `db/claude_dialogue.db` directly with SQLite

## Common Issues

**API Key Not Set**
```bash
export ANTHROPIC_API_KEY='sk-ant-...'
# Or create .env file
```

**Port Already in Use**
```bash
PORT=4568 ruby app.rb
```

**Database Locked**
```bash
rake db_reset
```

**Tests Failing**
```bash
bundle install
bundle exec rspec
```

## URLs

- Homepage: http://localhost:4567
- API: http://localhost:4567/api/conversations
- Conversation: http://localhost:4567/conversation/:id

## Getting Help

- Check README.md for full documentation
- See EXAMPLES.md for conversation prompts
- Read CONTRIBUTING.md for development guide
- Open an issue on GitHub
