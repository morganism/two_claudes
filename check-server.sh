#!/usr/bin/env bash

# Source ANSI color functions
[[ -f ~/.ansi.functions ]] && source ~/.ansi.functions

# Trap to reset terminal on exit
trap 'echo -e "${Reset}"; show_cursor' EXIT INT TERM

# Configuration
PORT=${PORT:-4567}
HOST="localhost"
MAX_RETRIES=3
RETRY_DELAY=2

# Banner
echo -e "${bICyan}${On_Black}╔══════════════════════════════════════╗${Reset}"
echo -e "${bICyan}${On_Black}║  🔍  Server Health Check  🔍        ║${Reset}"
echo -e "${bICyan}${On_Black}╚══════════════════════════════════════╝${Reset}"
echo ""

# Function to print status
print_check() {
    local status=$1
    local message=$2
    if [ "$status" == "ok" ]; then
        echo -e "${bGreen}✓${Reset} $message"
    elif [ "$status" == "warn" ]; then
        echo -e "${bYellow}⚠${Reset} $message"
    elif [ "$status" == "fail" ]; then
        echo -e "${bRed}✗${Reset} $message"
    else
        echo -e "${bBlue}▶${Reset} $message"
    fi
}

# Function to print section header
print_section() {
    echo ""
    echo -e "${bPurple}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${Reset}"
    echo -e "${bPurple}┃${Reset} ${bIWhite}$1${Reset}"
    echo -e "${bPurple}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${Reset}"
}

# Track overall health
ISSUES=0

# ════════════════════════════════════════
# Check 1: Ruby Installation
# ════════════════════════════════════════
print_section "🔧 Environment Checks"

if command -v ruby &> /dev/null; then
    RUBY_VERSION=$(ruby -v | cut -d ' ' -f 2 | cut -d 'p' -f 1)
    print_check "ok" "Ruby installed: ${bCyan}$RUBY_VERSION${Reset}"
    
    # Check Ruby version
    REQUIRED_VERSION="3.0.0"
    if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$RUBY_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
        print_check "fail" "Ruby version too old (need >= 3.0.0)"
        ((ISSUES++))
    fi
else
    print_check "fail" "Ruby not found"
    ((ISSUES++))
fi

# ════════════════════════════════════════
# Check 2: Bundler
# ════════════════════════════════════════
if command -v bundle &> /dev/null; then
    BUNDLER_VERSION=$(bundle -v | cut -d ' ' -f 3)
    print_check "ok" "Bundler installed: ${bCyan}$BUNDLER_VERSION${Reset}"
else
    print_check "fail" "Bundler not found - run: ${bCyan}gem install bundler${Reset}"
    ((ISSUES++))
fi

# ════════════════════════════════════════
# Check 3: Project Structure
# ════════════════════════════════════════
print_section "📁 Project Structure"

required_files=(
    "app.rb"
    "Gemfile"
    "lib/database.rb"
    "lib/orchestrator.rb"
    "lib/claude_client.rb"
    "views/index.erb"
    "views/conversation.erb"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        print_check "ok" "$file"
    else
        print_check "fail" "$file missing"
        ((ISSUES++))
    fi
done

# ════════════════════════════════════════
# Check 4: Dependencies
# ════════════════════════════════════════
print_section "📦 Gem Dependencies"

if [ -f "Gemfile.lock" ]; then
    print_check "ok" "Gemfile.lock exists"
    
    # Check if gems are installed
    if bundle check &> /dev/null; then
        print_check "ok" "All gems installed"
    else
        print_check "fail" "Gems not installed - run: ${bCyan}bundle install${Reset}"
        ((ISSUES++))
    fi
else
    print_check "warn" "Gemfile.lock missing - run: ${bCyan}bundle install${Reset}"
    ((ISSUES++))
fi

# ════════════════════════════════════════
# Check 5: API Key
# ════════════════════════════════════════
print_section "🔑 API Configuration"

# Check .env file
if [ -f ".env" ]; then
    print_check "ok" ".env file exists"
    
    # Source it to check
    export $(cat .env | grep -v '^#' | xargs 2>/dev/null)
fi

if [ -z "$ANTHROPIC_API_KEY" ]; then
    print_check "fail" "ANTHROPIC_API_KEY not set"
    echo -e "   ${dWhite}Set it with:${Reset}"
    echo -e "   ${bCyan}➜${Reset} ${Cyan}export ANTHROPIC_API_KEY='your-key'${Reset}"
    echo -e "   ${dWhite}Or create .env file:${Reset}"
    echo -e "   ${bCyan}➜${Reset} ${Cyan}echo \"ANTHROPIC_API_KEY=your-key\" > .env${Reset}"
    ((ISSUES++))
else
    KEY_PREFIX="${ANTHROPIC_API_KEY:0:20}"
    print_check "ok" "API key configured: ${dGreen}${KEY_PREFIX}...${Reset}"
fi

# ════════════════════════════════════════
# Check 6: Database
# ════════════════════════════════════════
print_section "🗄️  Database"

if [ -d "db" ]; then
    print_check "ok" "Database directory exists"
    
    if [ -f "db/claude_dialogue.db" ]; then
        DB_SIZE=$(ls -lh db/claude_dialogue.db | awk '{print $5}')
        print_check "ok" "Database file exists (${bCyan}${DB_SIZE}${Reset})"
    else
        print_check "warn" "Database not initialized - will be created on first run"
    fi
else
    print_check "fail" "Database directory missing - run: ${bCyan}mkdir -p db${Reset}"
    ((ISSUES++))
fi

# ════════════════════════════════════════
# Check 7: Server Process
# ════════════════════════════════════════
print_section "🚀 Server Status"

# Check if process is running
if pgrep -f "ruby.*app.rb" > /dev/null; then
    PID=$(pgrep -f "ruby.*app.rb")
    print_check "ok" "Server process running (PID: ${bCyan}${PID}${Reset})"
    
    # Check port
    if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1 || netstat -an 2>/dev/null | grep -q ":$PORT.*LISTEN"; then
        print_check "ok" "Port ${bCyan}${PORT}${Reset} is listening"
    else
        print_check "warn" "Process running but port ${PORT} not listening"
        ((ISSUES++))
    fi
    
    # Try to connect
    echo -e "${dWhite}   Testing HTTP connection...${Reset}"
    if curl -s -f -m 5 "http://${HOST}:${PORT}/" > /dev/null 2>&1; then
        print_check "ok" "Server responding to HTTP requests"
        echo -e "   ${bCyan}➜${Reset} ${uBlue}http://${HOST}:${PORT}/${Reset}"
    else
        print_check "fail" "Server not responding to HTTP requests"
        echo -e "   ${dWhite}Try:${Reset} ${Cyan}curl -v http://${HOST}:${PORT}/${Reset}"
        ((ISSUES++))
    fi
else
    print_check "warn" "Server process not running"
    echo -e "   ${dWhite}Start with:${Reset}"
    echo -e "   ${bCyan}➜${Reset} ${Cyan}./start.sh${Reset}"
    echo -e "   ${dWhite}or${Reset} ${Cyan}ruby app.rb${Reset}"
fi

# ════════════════════════════════════════
# Check 8: Port Availability
# ════════════════════════════════════════
if ! pgrep -f "ruby.*app.rb" > /dev/null; then
    print_section "🔌 Port Availability"
    
    if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
        BLOCKING_PID=$(lsof -ti :$PORT)
        BLOCKING_CMD=$(ps -p $BLOCKING_PID -o comm= 2>/dev/null || echo "unknown")
        print_check "fail" "Port ${PORT} already in use by ${bRed}${BLOCKING_CMD}${Reset} (PID: ${BLOCKING_PID})"
        echo -e "   ${dWhite}Kill it with:${Reset} ${Cyan}kill ${BLOCKING_PID}${Reset}"
        ((ISSUES++))
    else
        print_check "ok" "Port ${bCyan}${PORT}${Reset} is available"
    fi
fi

# ════════════════════════════════════════
# Summary
# ════════════════════════════════════════
echo ""
echo -e "${bPurple}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"

if [ $ISSUES -eq 0 ]; then
    echo -e "${bGreen}${On_Black}╔════════════════════════════════╗${Reset}"
    echo -e "${bGreen}${On_Black}║  ✓  All Checks Passed!  ✓    ║${Reset}"
    echo -e "${bGreen}${On_Black}╚════════════════════════════════╝${Reset}"
    echo ""
    if pgrep -f "ruby.*app.rb" > /dev/null; then
        echo -e "${bWhite}Server is healthy and running:${Reset}"
        echo -e "  ${bCyan}➜${Reset} ${uBlue}http://${HOST}:${PORT}/${Reset}"
    else
        echo -e "${bWhite}Server is ready to start:${Reset}"
        echo -e "  ${bCyan}➜${Reset} ${Cyan}./start.sh${Reset}"
    fi
else
    echo -e "${bRed}${On_Black}╔════════════════════════════════╗${Reset}"
    echo -e "${bRed}${On_Black}║  ✗  ${ISSUES} Issue(s) Found  ✗      ║${Reset}"
    echo -e "${bRed}${On_Black}╚════════════════════════════════╝${Reset}"
    echo ""
    echo -e "${bYellow}Fix the issues above before starting the server.${Reset}"
    exit 1
fi

echo ""
