#!/usr/bin/env bash

# Source ANSI color functions
[[ -f ~/.ansi.functions ]] && source ~/.ansi.functions

# Trap to reset terminal on exit
trap 'echo -e "${Reset}"; show_cursor' EXIT INT TERM

# Banner with Unicode box drawing
echo -e "${bICyan}${On_Black}╔══════════════════════════════╗${Reset}"
echo -e "${bICyan}${On_Black}║  🤖  Claude Dialogue  🤖    ║${Reset}"
echo -e "${bICyan}${On_Black}╚══════════════════════════════╝${Reset}"
echo ""

# Source .env file if it exists
if [ -z "$ANTHROPIC_API_KEY" ]; then
  if [ -f .env ]; then
    echo -e "${bBlue}▶ Loading .env file...${Reset}"
    export $(cat .env | grep -v '^#' | xargs)
    echo -e "${bGreen}✓${Reset} Environment loaded"
    echo ""
  fi
  
  if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${bRed}✗ Error: ANTHROPIC_API_KEY not set${Reset}"
    echo ""
    echo -e "${dWhite}Please set your API key:${Reset}"
    echo -e "  ${bCyan}➜${Reset} ${Cyan}export ANTHROPIC_API_KEY='your-key'${Reset}"
    echo ""
    echo -e "${dWhite}Or create a .env file:${Reset}"
    echo -e "  ${bCyan}➜${Reset} ${Cyan}cp .env.example .env${Reset}"
    echo -e "  ${dWhite}# Edit .env and add your key${Reset}"
    echo ""
    exit 1
  fi
fi

echo -e "${bGreen}✓${Reset} API key configured: ${dGreen}${ANTHROPIC_API_KEY:0:20}...${Reset}"
echo ""

# Check for database
if [ ! -f db/claude_dialogue.db ]; then
  echo -e "${bBlue}▶ Creating database...${Reset}"
  ruby -r ./lib/database -e "ClaudeDialogue::Database.setup"
  echo -e "${bGreen}✓${Reset} Database created"
  echo ""
fi

# Server configuration
PORT=${PORT:-4567}
echo -e "${bPurple}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${Reset}"
echo -e "${bPurple}┃${Reset} ${bIWhite}🚀 Starting Server${Reset}                    ${bPurple}┃${Reset}"
echo -e "${bPurple}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${Reset}"
echo ""
echo -e "  ${bWhite}URL:${Reset}  ${uBlue}http://localhost:$PORT${Reset}"
echo -e "  ${bWhite}Port:${Reset} ${bCyan}$PORT${Reset}"
echo ""
echo -e "${dWhite}Press ${bYellow}Ctrl+C${Reset}${dWhite} to stop the server${Reset}"
echo ""
echo -e "${bPurple}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${Reset}"
echo ""

# Start server
ruby app.rb
