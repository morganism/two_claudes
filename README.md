# Claude Dialogue 🤖💬

[![Ruby](https://img.shields.io/badge/ruby-%3E%3D%203.0-red.svg)](https://www.ruby-lang.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**Two Minds, One Conversation** - Watch two Claude AI instances engage in thoughtful, autonomous dialogue.

Claude Dialogue is a Ruby/Sinatra application that orchestrates conversations between two instances of Claude AI. Each instance responds to the other in a continuous exchange until a stopping condition is met, with all interactions stored in SQLite and displayed in a beautiful, Apple-inspired web interface.

## ✨ Features

- 🎭 **Dual Claude Instances**: Two independent Claude AI instances engage in conversation
- 💬 **Real-time Updates**: Watch the conversation unfold with live UI updates
- 🎨 **Apple-inspired UI**: Beautiful, clean interface with rounded corners and smooth animations
- 📊 **Three-panel View**: 
  - Left: Claude A's messages
  - Center: Running conversation summary
  - Right: Claude 2's messages
- 🗄️ **SQLite Storage**: All conversations and messages persisted to database
- 🔧 **Multiple Interfaces**:
  - Web UI (Bootstrap + custom CSS)
  - RESTful API (JSON)
  - Command-line interface
  - curl support
- ⚙️ **Configurable**:
  - Custom system prompts for each Claude instance
  - Adjustable stopping conditions
  - Turn-based limits
- 🧪 **Well-tested**: RSpec test suite included
- 📦 **Easy Setup**: One-command installation script

## 🎯 Use Cases

- **AI Research**: Study how AI models interact with each other
- **Debate Simulation**: Watch two AI perspectives discuss complex topics
- **Creative Writing**: Generate dialogues for stories or scripts
- **Philosophical Exploration**: Deep conversations about consciousness, ethics, etc.
- **Education**: Demonstrate AI capabilities and limitations
- **Entertainment**: Fascinating to watch AI have conversations!

## 🚀 Quick Start

### Prerequisites

- Ruby >= 3.0.0
- Bundler
- Anthropic API key ([Get one here](https://console.anthropic.com/))

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/claude-dialogue.git
cd claude-dialogue

# Run setup script
chmod +x setup.sh
./setup.sh

# Set your API key
export ANTHROPIC_API_KEY='your-api-key-here'

# Start the server
ruby app.rb
```

Visit `http://localhost:4567` in your browser!

## 📖 Usage

### Web Interface

1. Open `http://localhost:4567`
2. Enter your initial prompt
3. (Optional) Customize system prompts for each Claude instance
4. Select stopping condition (number of turns)
5. Click "Start Conversation"
6. Watch the dialogue unfold in real-time!

### Command Line

```bash
# Basic usage
./bin/claude-dialogue -p "Discuss the nature of consciousness"

# With custom stopping condition
./bin/claude-dialogue -p "Debate free will vs determinism" -s max_turns:20

# With custom system prompts
./bin/claude-dialogue \
  -p "Discuss quantum mechanics" \
  -a "You are a physicist who favors the Copenhagen interpretation" \
  -2 "You are a physicist who favors the Many-Worlds interpretation"

# View all options
./bin/claude-dialogue --help
```

### API Usage

#### Start a conversation

```bash
curl -X POST http://localhost:4567/api/conversations \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "What is consciousness?",
    "stopping_condition": "max_turns:10",
    "claude_a_system_prompt": "You are a philosopher",
    "claude_2_system_prompt": "You are a neuroscientist"
  }'
```

#### Get conversation status

```bash
curl http://localhost:4567/api/conversations/1
```

#### List all conversations

```bash
curl http://localhost:4567/api/conversations
```

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         Web UI / CLI                         │
│                     (Bootstrap + Custom CSS)                 │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      Sinatra Application                     │
│                     (app.rb + Routes)                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       Orchestrator                           │
│              (Manages conversation flow)                     │
└─────────────────────────────────────────────────────────────┘
                    │                    │
                    ▼                    ▼
        ┌──────────────────┐  ┌──────────────────┐
        │   Claude A API   │  │   Claude 2 API   │
        │    (Client)      │  │    (Client)      │
        └──────────────────┘  └──────────────────┘
                    │                    │
                    └──────────┬─────────┘
                               ▼
                    ┌──────────────────┐
                    │  SQLite Database │
                    │   (Persistence)  │
                    └──────────────────┘
```

### Project Structure

```
claude-dialogue/
├── app.rb                  # Main Sinatra application
├── config.ru              # Rack configuration
├── Gemfile                # Ruby dependencies
├── setup.sh               # Setup script
├── bin/
│   └── claude-dialogue    # CLI executable
├── lib/
│   ├── database.rb        # Database schema & setup
│   ├── claude_client.rb   # API client wrapper
│   └── orchestrator.rb    # Conversation orchestration
├── views/
│   ├── index.erb          # Homepage
│   └── conversation.erb   # Conversation status page
├── public/
│   ├── css/
│   │   └── style.css      # Apple-inspired styles
│   └── js/
│       ├── app.js         # Main app JavaScript
│       └── conversation.js # Conversation page JS
├── db/
│   └── claude_dialogue.db # SQLite database
└── spec/
    ├── spec_helper.rb     # RSpec configuration
    ├── app_spec.rb        # App tests
    └── database_spec.rb   # Database tests
```

## ⚙️ Configuration

### Environment Variables

```bash
# Required
ANTHROPIC_API_KEY=your-api-key-here

# Optional
PORT=4567                  # Server port (default: 4567)
RACK_ENV=production       # Environment (development/production/test)
```

### Stopping Conditions

- `max_turns:N` - Stop after N turns (e.g., `max_turns:10`)
- Either Claude can include `[END CONVERSATION]` in their response to stop early

### Database

The SQLite database has three main tables:

- **conversations**: Stores conversation metadata
- **messages**: Stores all messages from both Claude instances
- **summaries**: Stores periodic conversation summaries

## 🧪 Testing

```bash
# Run all tests
bundle exec rspec

# Run with coverage
bundle exec rspec --format documentation

# Run specific test file
bundle exec rspec spec/app_spec.rb
```

## 🎨 UI Design

The interface follows Apple's design principles:

- **Color Palette**: Black, dark gray, gray, light gray, white, blue, light blue
- **Typography**: San Francisco font (-apple-system)
- **Components**: Rounded corners (18px), floating cards with shadows
- **Animations**: Smooth transitions with cubic-bezier easing
- **Layout**: Clean, spacious, mobile-responsive

## 🔒 Security Considerations

- Never commit your `ANTHROPIC_API_KEY` to version control
- Use environment variables or `.env` files (which are gitignored)
- The application doesn't implement authentication - deploy behind auth if exposing publicly
- Rate limiting on API calls is handled by the Anthropic SDK

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Sinatra](http://sinatrarb.com/)
- UI powered by [Bootstrap 5](https://getbootstrap.com/)
- AI by [Anthropic's Claude](https://www.anthropic.com/)
- Inspired by the Grateful Dead's endless improvisational dialogues 🎸

## 📧 Contact

Questions? Feedback? Open an issue or reach out!

---

**"The only way to discover the limits of the possible is to go beyond them into the impossible."** - Arthur C. Clarke

Enjoy watching Claude converse with itself! 🤖💭🤖
