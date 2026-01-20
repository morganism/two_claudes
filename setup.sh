#!/usr/bin/env bash

# Source ANSI color functions
[[ -f ~/.ansi.functions ]] && source ~/.ansi.functions

# Trap to reset terminal on exit
trap 'echo -e "${Reset}"; show_cursor' EXIT INT TERM

set -e

# Header with Unicode box drawing
echo -e "${bIWhite}${On_Blue}╔════════════════════════════════════════╗${Reset}"
echo -e "${bIWhite}${On_Blue}║  🚀  Claude Dialogue Setup Script  🚀  ║${Reset}"
echo -e "${bIWhite}${On_Blue}╚════════════════════════════════════════╝${Reset}"
echo ""

# Check Ruby version
echo -e "${bBlue}▶ Checking Ruby version...${Reset}"
RUBY_VERSION=$(ruby -v | cut -d ' ' -f 2 | cut -d 'p' -f 1)
REQUIRED_VERSION="3.0.0"

if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$RUBY_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then 
  echo -e "${bRed}✗ Ruby $REQUIRED_VERSION or higher is required${Reset}"
  echo -e "${Red}  └─ You have: ${bRed}$RUBY_VERSION${Reset}"
  exit 1
fi

echo -e "${bGreen}✓${Reset} Ruby version: ${bCyan}$RUBY_VERSION${Reset}"
echo ""

# Check for bundler
echo -e "${bBlue}▶ Checking for Bundler...${Reset}"
if ! command -v bundle &> /dev/null; then
  echo -e "${Yellow}  ├─ Installing Bundler...${Reset}"
  gem install bundler
fi
echo -e "${bGreen}✓${Reset} Bundler installed"
echo ""

# Install dependencies
echo -e "${bBlue}▶ Installing dependencies...${Reset}"
bundle install --quiet
echo -e "${bGreen}✓${Reset} Dependencies installed"
echo ""

# Source .env file if it exists
if [ -f .env ]; then
  echo -e "${bBlue}▶ Loading .env file...${Reset}"
  export $(cat .env | grep -v '^#' | xargs)
  echo -e "${bGreen}✓${Reset} Environment variables loaded from ${uCyan}.env${Reset}"
  echo ""
fi

# Check for ANTHROPIC_API_KEY
echo -e "${bBlue}▶ Checking for API key...${Reset}"
if [ -z "$ANTHROPIC_API_KEY" ]; then
  echo -e "${bYellow}⚠${Reset}  ${Yellow}ANTHROPIC_API_KEY environment variable is not set${Reset}"
  echo ""
  echo -e "   ${dWhite}Please set your Anthropic API key:${Reset}"
  echo -e "   ${bCyan}➜${Reset} ${Cyan}export ANTHROPIC_API_KEY='your-api-key-here'${Reset}"
  echo ""
  echo -e "   ${dWhite}Or create a ${uWhite}.env${Reset}${dWhite} file with:${Reset}"
  echo -e "   ${bCyan}➜${Reset} ${Cyan}ANTHROPIC_API_KEY=your-api-key-here${Reset}"
  echo ""
else
  echo -e "${bGreen}✓${Reset} API key found: ${dGreen}${ANTHROPIC_API_KEY:0:20}...${Reset}"
fi
echo ""

# Create database directory
echo -e "${bBlue}▶ Setting up database...${Reset}"
mkdir -p db
echo -e "${bGreen}✓${Reset} Database directory created"
echo ""

# Make CLI executable
echo -e "${bBlue}▶ Setting up CLI...${Reset}"
chmod +x bin/claude-dialogue
echo -e "${bGreen}✓${Reset} CLI is executable"
echo ""

# Run tests
echo -e "${bBlue}▶ Running tests...${Reset}"
if bundle exec rspec --format progress 2>&1 | grep -q "0 failures"; then
  echo -e "${bGreen}✓${Reset} All tests passed"
else
  echo -e "${bYellow}⚠${Reset}  ${Yellow}Some tests failed, but setup is complete${Reset}"
fi
echo ""

# Success banner
echo -e "${bGreen}${On_Black}╔════════════════════════════════╗${Reset}"
echo -e "${bGreen}${On_Black}║  ✓  Setup Complete!  ✓         ║${Reset}"
echo -e "${bGreen}${On_Black}╚════════════════════════════════╝${Reset}"
echo ""

# Quick Start Guide
echo -e "${bPurple}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${Reset}"
echo -e "${bPurple}┃${Reset} ${bIWhite}📖 Quick Start Guide${Reset}                  ${bPurple}┃${Reset}"
echo -e "${bPurple}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${Reset}"
echo ""
echo -e "  ${bWhite}①${Reset} Set your API key:"
echo -e "     ${bCyan}➜${Reset} ${Cyan}export ANTHROPIC_API_KEY='your-key'${Reset}"
echo ""
echo -e "  ${bWhite}②${Reset} Start the server:"
echo -e "     ${bCyan}➜${Reset} ${Cyan}./start.sh${Reset}"
echo -e "     ${dWhite}or${Reset} ${Cyan}ruby app.rb${Reset}"
echo ""
echo -e "  ${bWhite}③${Reset} Open browser:"
echo -e "     ${bCyan}➜${Reset} ${uBlue}http://localhost:4567${Reset}"
echo ""
echo -e "${bPurple}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${Reset}"
echo -e "${bPurple}┃${Reset} ${bIWhite}🔧 CLI Usage${Reset}                          ${bPurple}┃${Reset}"
echo -e "${bPurple}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${Reset}"
echo ""
echo -e "  ${bCyan}➜${Reset} ${Cyan}./bin/claude-dialogue -p 'Discuss consciousness'${Reset}"
echo ""
echo -e "${bPurple}┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${Reset}"
echo -e "${bPurple}┃${Reset} ${bIWhite}📚 Documentation${Reset}                      ${bPurple}┃${Reset}"
echo -e "${bPurple}┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${Reset}"
echo ""
echo -e "  ${bCyan}•${Reset} ${uBlue}README.md${Reset}          ${dWhite}─ Full documentation${Reset}"
echo -e "  ${bCyan}•${Reset} ${uBlue}EXAMPLES.md${Reset}        ${dWhite}─ Example prompts${Reset}"
echo -e "  ${bCyan}•${Reset} ${uBlue}QUICK_REFERENCE.md${Reset} ${dWhite}─ Command reference${Reset}"
echo ""
