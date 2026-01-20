# Claude Dialogue - Installation Summary

## What You've Got

A complete, production-ready Ruby/Sinatra application that orchestrates conversations between two Claude AI instances with:

✅ Beautiful Apple-inspired web UI
✅ Real-time conversation updates
✅ RESTful JSON API
✅ Command-line interface
✅ SQLite database persistence
✅ Comprehensive test suite
✅ Complete documentation
✅ GitHub ready with CI/CD workflow

## Quick Start (3 Steps)

### 1. Prerequisites
- Ruby >= 3.0 (check: `ruby -v`)
- Anthropic API key (get one at https://console.anthropic.com)

### 2. Setup
```bash
cd claude-dialogue
./setup.sh
export ANTHROPIC_API_KEY='your-api-key-here'
```

### 3. Run
```bash
./start.sh
# Or: ruby app.rb
```

Then open http://localhost:4567 in your browser!

## Project Structure

```
claude-dialogue/
├── 📱 Web Application
│   ├── app.rb                    # Main Sinatra app
│   ├── config.ru                 # Rack configuration
│   ├── views/                    # HTML templates
│   │   ├── index.erb            # Homepage
│   │   └── conversation.erb     # Conversation viewer
│   └── public/                   # Static assets
│       ├── css/style.css        # Apple-inspired styles
│       └── js/                   # JavaScript
│           ├── app.js           # Main app
│           └── conversation.js  # Real-time updates
│
├── 🧠 Core Library
│   └── lib/
│       ├── database.rb          # SQLite schema
│       ├── claude_client.rb     # API wrapper
│       └── orchestrator.rb      # Conversation logic
│
├── 🔧 Tools & Scripts
│   ├── bin/claude-dialogue      # CLI executable
│   ├── setup.sh                 # Installation script
│   ├── start.sh                 # Startup script
│   └── Rakefile                 # Development tasks
│
├── 🧪 Testing
│   └── spec/
│       ├── spec_helper.rb       # Test configuration
│       ├── app_spec.rb          # App tests
│       └── database_spec.rb     # Database tests
│
├── 📚 Documentation
│   ├── README.md                # Full documentation
│   ├── QUICK_REFERENCE.md       # Command reference
│   ├── EXAMPLES.md              # Example prompts
│   ├── CONTRIBUTING.md          # Contribution guide
│   └── LICENSE                  # MIT License
│
└── ⚙️ Configuration
    ├── Gemfile                  # Dependencies
    ├── .env.example             # Environment template
    ├── .gitignore               # Git ignore rules
    ├── .rspec                   # RSpec config
    └── .github/workflows/       # CI/CD
        └── ci.yml
```

## Key Features

### Web UI
- Apple-inspired design (rounded corners, gradients, shadows)
- Three-panel layout: Claude A | Summary | Claude 2
- Real-time updates (polls every 2 seconds)
- Mobile responsive
- Full conversation transcript
- Status badges and turn counters

### CLI
```bash
# Basic usage
./bin/claude-dialogue -p "Discuss consciousness"

# Advanced
./bin/claude-dialogue \
  -p "Debate free will" \
  -s max_turns:20 \
  -a "You believe in free will" \
  -2 "You are a determinist"
```

### API
```bash
# Start conversation
curl -X POST http://localhost:4567/api/conversations \
  -H "Content-Type: application/json" \
  -d '{"prompt": "What is reality?", "stopping_condition": "max_turns:10"}'

# Get status
curl http://localhost:4567/api/conversations/1
```

## Database Schema

**conversations**: Metadata about each dialogue
- id, title, initial_prompt, stopping_condition
- status, turn_count, timestamps

**messages**: All messages from both Claudes
- conversation_id, claude_instance, role, content
- turn_number, tokens_used, timestamp

**summaries**: Periodic conversation summaries
- conversation_id, summary_text, up_to_turn

## Testing

```bash
bundle exec rspec              # Run all tests
bundle exec rspec spec/app_spec.rb  # Run specific file
```

Test coverage includes:
- API endpoints
- Database operations
- Message storage
- Conversation flow

## Development

```bash
# Common tasks
rake spec          # Run tests
rake start         # Start server
rake db_reset      # Reset database
rake db_console    # Open SQLite console
rake stats         # Show statistics
rake clean         # Clean temp files

# Development server with auto-reload
gem install rerun
rake dev
```

## Configuration

### Environment Variables
- `ANTHROPIC_API_KEY` (required) - Your API key
- `PORT` (optional) - Server port (default: 4567)
- `RACK_ENV` (optional) - Environment (development/production)

### Stopping Conditions
- `max_turns:N` - Limit conversation to N turns
- Include `[END CONVERSATION]` in a response to stop early

## Deployment

### Local Production
```bash
RACK_ENV=production ruby app.rb
```

### With Passenger/Nginx
The `config.ru` file is ready for Rack-based deployment.

### Heroku
```bash
git push heroku main
heroku config:set ANTHROPIC_API_KEY='your-key'
```

## Customization Ideas

- **UI Themes**: Modify `public/css/style.css` for different color schemes
- **Models**: Change model in `lib/claude_client.rb`
- **Stopping Conditions**: Add custom logic in `lib/orchestrator.rb`
- **Export Formats**: Add PDF/DOCX export functionality
- **Authentication**: Add user accounts with Devise or similar
- **WebSockets**: Replace polling with Socket.IO for real-time updates

## Example Conversations

See `EXAMPLES.md` for conversation starters including:
- Philosophy (consciousness, free will, morality)
- Science (quantum mechanics, AI safety)
- Creative (story writing, poetry)
- Problem solving (math, programming)
- Debates (opposing viewpoints)

## Troubleshooting

**"ANTHROPIC_API_KEY not set"**
```bash
export ANTHROPIC_API_KEY='sk-ant-...'
```

**"Port already in use"**
```bash
PORT=4568 ruby app.rb
```

**"Database is locked"**
```bash
rake db_reset
```

**Tests failing**
```bash
bundle install
bundle exec rspec
```

## Next Steps

1. ✅ Run `./setup.sh` to install dependencies
2. ✅ Set your `ANTHROPIC_API_KEY`
3. ✅ Start the server with `./start.sh`
4. ✅ Open http://localhost:4567
5. ✅ Try example prompts from `EXAMPLES.md`
6. ✅ Explore the API with curl
7. ✅ Read full docs in `README.md`

## Contributing

Contributions welcome! See `CONTRIBUTING.md` for guidelines.

## License

MIT License - See `LICENSE` file

## Support

- 📖 Full docs: README.md
- 🔧 Quick ref: QUICK_REFERENCE.md
- 💡 Examples: EXAMPLES.md
- 🤝 Contributing: CONTRIBUTING.md
- 🐛 Issues: Open a GitHub issue

---

**Enjoy watching Claude converse with itself!** 🤖💬🤖

Built with ❤️ and lots of Ruby
