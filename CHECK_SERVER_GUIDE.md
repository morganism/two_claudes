# Server Health Check Script

## Overview

`check-server.sh` - Comprehensive diagnostic tool for the Claude Dialogue server.

## Features

✅ **Environment Checks**
- Ruby installation and version
- Bundler installation
- Required Ruby version (>= 3.0.0)

✅ **Project Structure**
- Verifies all required files exist
- Checks app.rb, Gemfile, lib/, views/

✅ **Dependencies**
- Validates Gemfile.lock
- Checks if all gems are installed
- Suggests `bundle install` if needed

✅ **API Configuration**
- Checks for .env file
- Validates ANTHROPIC_API_KEY is set
- Shows masked API key prefix

✅ **Database**
- Verifies db/ directory exists
- Checks if database is initialized
- Shows database file size

✅ **Server Status**
- Detects if server process is running
- Checks if port is listening
- Tests HTTP connectivity
- Shows server URL

✅ **Port Availability**
- Checks if port is available
- Identifies blocking processes
- Suggests how to kill them

## Usage

### Standalone

```bash
# Run health check
./check-server.sh

# Make executable if needed
chmod +x check-server.sh
```

### With Start Script

```bash
# Start with health check
./start-enhanced.sh --check

# Or
./start-enhanced.sh -c
```

## Output Example

```
╔══════════════════════════════════════╗
║  🔍  Server Health Check  🔍        ║
╚══════════════════════════════════════╝

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 🔧 Environment Checks
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

✓ Ruby installed: 3.2.0
✓ Bundler installed: 2.5.4

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 📁 Project Structure
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

✓ app.rb
✓ Gemfile
✓ lib/database.rb
✓ lib/orchestrator.rb
✓ lib/claude_client.rb
✓ views/index.erb
✓ views/conversation.erb

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 📦 Gem Dependencies
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

✓ Gemfile.lock exists
✓ All gems installed

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 🔑 API Configuration
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

✓ .env file exists
✓ API key configured: sk-ant-api03-abc123...

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 🗄️  Database
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

✓ Database directory exists
✓ Database file exists (128K)

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ 🚀 Server Status
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

✓ Server process running (PID: 12345)
✓ Port 4567 is listening
   Testing HTTP connection...
✓ Server responding to HTTP requests
   ➜ http://localhost:4567/

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
╔════════════════════════════════╗
║  ✓  All Checks Passed!  ✓    ║
╚════════════════════════════════╝

Server is healthy and running:
  ➜ http://localhost:4567/
```

## Error Detection

### Missing Gems
```
✗ Gems not installed - run: bundle install
```

### Missing API Key
```
✗ ANTHROPIC_API_KEY not set
   Set it with:
   ➜ export ANTHROPIC_API_KEY='your-key'
   Or create .env file:
   ➜ echo "ANTHROPIC_API_KEY=your-key" > .env
```

### Port Blocked
```
✗ Port 4567 already in use by ruby (PID: 12345)
   Kill it with: kill 12345
```

### Ruby Version
```
✗ Ruby version too old (need >= 3.0.0)
```

## Exit Codes

- `0` - All checks passed
- `1` - One or more issues found

## Integration with CI/CD

```bash
# In your CI pipeline
./check-server.sh || exit 1
```

## Common Issues & Fixes

### Issue: Gems Not Installed
```bash
bundle install
```

### Issue: API Key Not Set
```bash
export ANTHROPIC_API_KEY='your-key-here'
# Or
echo "ANTHROPIC_API_KEY=your-key" > .env
```

### Issue: Port Already in Use
```bash
# Find the process
lsof -ti :4567

# Kill it
kill $(lsof -ti :4567)

# Or use a different port
PORT=4568 ./start.sh
```

### Issue: Database Missing
```bash
mkdir -p db
ruby -r ./lib/database -e "ClaudeDialogue::Database.setup"
```

### Issue: Files Missing
```bash
# Re-extract or re-clone the project
git pull
```

## Customization

### Check Different Port
```bash
PORT=8080 ./check-server.sh
```

### Skip Certain Checks

Edit the script and comment out sections you don't need.

## Requirements

- Bash 3.0+
- `~/.ansi.functions` (optional, for colors)
- `lsof` or `netstat` (for port checking)
- `pgrep` (for process detection)
- `curl` (for HTTP testing)

## Troubleshooting

### "command not found: lsof"

Install lsof:
```bash
# macOS
brew install lsof

# Debian/Ubuntu
sudo apt-get install lsof
```

### "command not found: pgrep"

pgrep is part of procps, usually installed by default. If missing:
```bash
# Debian/Ubuntu
sudo apt-get install procps
```

### Colors Not Showing

Make sure `~/.ansi.functions` exists and is sourced, or the script will work without colors.

---

**Pro Tip:** Run `./check-server.sh` before reporting issues - it will diagnose most common problems! 🔍✨
