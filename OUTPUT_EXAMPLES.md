# Visual Output Examples

These examples show what you'll see when running the scripts (colors not shown in markdown).

## setup.sh Output

```
╔════════════════════════════════════════╗
║  🚀  Claude Dialogue Setup Script  🚀 ║
╚════════════════════════════════════════╝

▶ Checking Ruby version...
✓ Ruby version: 3.2.0

▶ Checking for Bundler...
✓ Bundler installed

▶ Installing dependencies...
✓ Dependencies installed

▶ Loading .env file...
✓ Environment variables loaded from .env

▶ Checking for API key...
✓ API key found: sk-ant-api03-abc123...

▶ Setting up database...
✓ Database directory created

▶ Setting up CLI...
✓ CLI is executable

▶ Running tests...
✓ All tests passed

╔════════════════════════════════╗
║  ✓  Setup Complete!  ✓       ║
╚════════════════════════════════╝

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 📖 Quick Start Guide                    ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  ① Set your API key:
     ➜ export ANTHROPIC_API_KEY='your-key'

  ② Start the server:
     ➜ ./start.sh
     or ruby app.rb

  ③ Open browser:
     ➜ http://localhost:4567

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 🔧 CLI Usage                            ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  ➜ ./bin/claude-dialogue -p 'Discuss consciousness'

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 📚 Documentation                        ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  • README.md          ─ Full documentation
  • EXAMPLES.md        ─ Example prompts
  • QUICK_REFERENCE.md ─ Command reference

```

## start.sh Output

```
╔══════════════════════════════╗
║  🤖  Claude Dialogue  🤖    ║
╚══════════════════════════════╝

▶ Loading .env file...
✓ Environment loaded

✓ API key configured: sk-ant-api03-abc123...

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 🚀 Starting Server                      ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  URL:  http://localhost:4567
  Port: 4567

Press Ctrl+C to stop the server

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

```

## CLI Help Output

```
╔════════════════════════════════════╗
║  🤖  Claude Dialogue CLI  🤖     ║
╚════════════════════════════════════╝

Usage: claude-dialogue [options]

Options:

    -p, --prompt PROMPT              Initial prompt for Claude A (required)
    -a, --claude-a PROMPT            System prompt for Claude A
    -2, --claude-2 PROMPT            System prompt for Claude 2
    -s, --stop CONDITION             Stopping condition (e.g., max_turns:20)
    -H, --host HOST                  Server host (default: localhost)
    -P, --port PORT                  Server port (default: 4567)
    -j, --json                       Output as JSON
    -h, --help                       Show this help message

Examples:
  ➜ claude-dialogue -p 'Discuss consciousness'
  ➜ claude-dialogue -p 'Debate free will' -s max_turns:20
  ➜ claude-dialogue -p 'AI safety' -a 'You are cautious' -2 'You are optimistic'

```

## CLI Success Output

```
▶ Starting conversation...
  ├─ Prompt: Discuss the nature of consciousness and whether it is fu...
  └─ Server: http://localhost:4567

╔════════════════════════════════════╗
║  ✓  Conversation Started!  ✓    ║
╚════════════════════════════════════╝

Conversation ID: #42
Status:          started

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 🔗 Links                                ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

  View:
  ➜ http://localhost:4567/conversation/42

  Track:
  ➜ watch -n 2 "curl -s http://localhost:4567/api/conversations/42"

```

## CLI Error Output

```
╔════════════════════╗
║  ✗  Error  ✗     ║
╚════════════════════╝

Connection refused - connect(2) for "localhost" port 4567

Make sure the server is running:
  ➜ ./start.sh
  or ruby app.rb

```

## Error Example (Missing API Key)

```
▶ Checking for API key...
⚠ ANTHROPIC_API_KEY environment variable is not set

   Please set your Anthropic API key:
   ➜ export ANTHROPIC_API_KEY='your-api-key-here'

   Or create a .env file with:
   ➜ ANTHROPIC_API_KEY=your-api-key-here

```

## Tree Structure Example

```
✗ Ruby 3.0.0 or higher is required
  └─ You have: 2.7.0
```

```
▶ Starting conversation...
  ├─ Prompt: What is the meaning of life?
  └─ Server: http://localhost:4567
```

## Color Legend (not visible in markdown)

When run in terminal with ANSI colors:
- Blue = Information, headers, progress indicators
- Green = Success checkmarks and messages
- Red = Errors and failures
- Yellow = Warnings
- Cyan = Commands, code, URLs
- Purple = Borders, dividers
- White/Bold White = Headers in banners
- Dim White = Secondary help text
- Underlined = Links

All boxes and Unicode characters render perfectly in modern terminals with UTF-8 support!
