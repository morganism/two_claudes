# Claude Dialogue - Unicode & Color Scheme

Beautiful terminal output using ANSI colors and Unicode box drawing characters.

## Unicode Characters Used

### Box Drawing Characters

**Double Line Boxes (╔═╗ style)**
- Used for: Major banners, headers
- Characters: `╔ ═ ╗ ║ ╚ ╝`
- Example:
  ```
  ╔════════════════════════════════════════╗
  ║  🚀  Claude Dialogue Setup Script  🚀 ║
  ╚════════════════════════════════════════╝
  ```

**Heavy Line Dividers (━ style)**
- Used for: Section dividers, borders
- Characters: `┏ ━ ┓ ┃ ┗ ┛`
- Example:
  ```
  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  ┃ 📖 Quick Start Guide                    ┃
  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
  ```

**Simple Line Dividers**
- Used for: Subtle separators
- Character: `━`
- Example: `━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`

**Tree Characters**
- Used for: Nested information, hierarchies
- Characters: `├ └ ─`
- Example:
  ```
  ├─ Installing Bundler...
  └─ You have: 2.7.0
  ```

### Arrows & Bullets

**Right Arrow (➜)**
- Used for: Commands, actions to take
- Example: `➜ export ANTHROPIC_API_KEY='your-key'`

**Triangle Arrows (▶)**
- Used for: Progress indicators, running actions
- Example: `▶ Checking Ruby version...`

**Bullets (•)**
- Used for: List items
- Example: `• README.md          ─ Full documentation`

**Numbered Circles (①②③)**
- Used for: Numbered steps
- Example: `① Set your API key`

### Status Symbols

**Check Marks**
- `✓` - Success (regular)
- `✔` - Success (heavy)

**Cross Marks**
- `✗` - Error/failure (regular)
- `✘` - Error/failure (heavy)

**Warning**
- `⚠` - Warning/caution

**Em Dash (─)**
- Used for: Connecting descriptions
- Example: `README.md ─ Full documentation`

## Color Usage Guide

### Status Colors
- 🟢 **Green** (`${bGreen}`) → Success, completion, checkmarks
- 🔴 **Red** (`${bRed}`) → Errors, failures
- 🟡 **Yellow** (`${bYellow}`) → Warnings, important notices
- 🔵 **Blue** (`${bBlue}`) → Information, headers, sections
- 🔷 **Cyan** (`${bCyan}`, `${Cyan}`) → Commands, URLs, code snippets
- 🟣 **Purple** (`${bPurple}`) → Decorative dividers, borders

### Text Styles
- **Bold** (`${bWhite}`, `${bBlue}`, etc.) → Headers, labels, important text
- **Dim** (`${dWhite}`) → Secondary info, help text
- **Underline** (`${uBlue}`, `${uCyan}`) → Links, file names
- **Backgrounds** (`${On_Blue}`, `${On_Black}`) → Banner headers

### Intensity Levels
- **Regular** (`${Red}`, `${Blue}`, etc.) → Standard text
- **Bold** (`${bRed}`, `${bBlue}`) → Emphasis
- **High Intensity** (`${IWhite}`, `${ICyan}`) → Bright text
- **Bold + High Intensity** (`${bIWhite}`) → Maximum emphasis

## Visual Examples

### Header Banner
```
╔════════════════════════════════════════╗
║  🚀  Claude Dialogue Setup Script  🚀 ║
╚════════════════════════════════════════╝
```
**Colors:** Bold intense white on blue background

### Progress Indicator
```
▶ Installing dependencies...
✓ Dependencies installed
```
**Colors:** Bold blue for progress, bold green for success

### Error Message
```
✗ Ruby 3.0.0 or higher is required
  └─ You have: 2.7.0
```
**Colors:** Bold red for error, red for context

### Section with Border
```
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
```
**Colors:** Bold purple borders, bold white header, bold white numbers, bold cyan arrows, cyan commands, underlined URLs

### List with Bullets
```
  • README.md          ─ Full documentation
  • EXAMPLES.md        ─ Example prompts
  • QUICK_REFERENCE.md ─ Command reference
```
**Colors:** Bold cyan bullets, underlined blue filenames, dim white descriptions

### Success Banner
```
╔════════════════════════════════╗
║  ✓  Setup Complete!  ✓       ║
╚════════════════════════════════╝
```
**Colors:** Bold green on black background

### Warning
```
⚠ ANTHROPIC_API_KEY environment variable is not set
```
**Colors:** Bold yellow symbol, yellow text

## Character Reference

### All Box Drawing Characters Available
```
Single Line:  ─ │ ┌ ┐ └ ┘ ├ ┤ ┬ ┴ ┼
Double Line:  ═ ║ ╔ ╗ ╚ ╝ ╠ ╣ ╦ ╩ ╬
Heavy Line:   ━ ┃ ┏ ┓ ┗ ┛ ┣ ┫ ┳ ┻ ╋
```

### Other Useful Unicode
```
Arrows:       → ← ↑ ↓ ⇒ ⇐ ➜ ➤
Bullets:      • ◦ ▪ ▫ ● ○ ■ □
Stars:        ★ ☆ ✦ ✧
Check/X:      ✓ ✔ ✗ ✘ ☑ ☒
Numbers:      ① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩
Shapes:       ◆ ◇ ▶ ▷ ◀ ◁ ▲ △ ▼ ▽
Misc:         ─ • ➜ ▶
```

## Script-Specific Usage

### setup.sh
- Double-line box (`╔═╗`) for main banner
- Heavy-line box (`┏━┓`) for sections
- Triangle arrow (`▶`) for progress
- Right arrow (`➜`) for commands
- Tree chars (`├─`, `└─`) for nested info
- Numbered circles (`①②③`) for steps
- Bullets (`•`) for lists
- Em dash (`─`) for descriptions

### start.sh
- Double-line box (`╔═╗`) for banner
- Heavy-line box (`┏━┓`) for server info
- Triangle arrow (`▶`) for actions
- Single line (`━`) for dividers
- Right arrow (`➜`) for commands

### bin/claude-dialogue
- Double-line box (`╔═╗`) for banners
- Heavy-line box (`┏━┓`) for sections
- Right arrow (`➜`) for examples
- Tree chars for hierarchical display

## ANSI Functions Required

All scripts source `~/.ansi.functions` which provides:
- Color variables (Regular, Bold, Dim, Italic, Underline)
- High intensity variants
- Background colors
- Cursor control functions
- Screen management

## Terminal Reset

All scripts include trap handlers:
```bash
trap 'echo -e "${Reset}"; show_cursor' EXIT INT TERM
```

This ensures proper cleanup on:
- Normal exit
- Ctrl+C (SIGINT)
- Kill signals (SIGTERM)

## Fallback Behavior

If `~/.ansi.functions` is not found:
- Scripts run without errors
- Color variables are empty
- Unicode characters still display
- Output is functional but monochrome

## Testing Your Terminal

Test Unicode support:
```bash
echo "╔═══╗ ┏━━━┓ ─── • ➜ ▶ ✓ ✗ ⚠"
```

If you see boxes or question marks, your terminal may not support Unicode fully. Try:
- Using UTF-8 locale: `export LANG=en_US.UTF-8`
- Modern terminals: iTerm2, Alacritty, Windows Terminal
- Installing proper fonts with Unicode coverage

## Tips for Best Display

1. **Terminal Settings**
   - Use UTF-8 encoding
   - Set LANG environment variable
   - Use a modern terminal emulator

2. **Font Selection**
   - Monospace fonts with good Unicode coverage
   - Recommended: Fira Code, JetBrains Mono, Cascadia Code
   - Avoid legacy bitmap fonts

3. **Color Scheme**
   - Dark backgrounds work best
   - Ensure good contrast ratios
   - Test with your terminal's theme

## Customization

To modify the output style:

1. **Change Box Style**
   - Replace `╔═╗` with `┌─┐` for single-line
   - Replace `┏━┓` with `╔═╗` for double-line
   - Mix and match as desired

2. **Change Symbols**
   - Replace `▶` with `►` or `→`
   - Replace `➜` with `→` or `⇒`
   - Replace `•` with `◦` or `▪`

3. **Adjust Colors**
   - Edit color assignments in scripts
   - Modify `~/.ansi.functions` for global changes
   - Create your own color schemes

Enjoy your beautiful, professional terminal output! ✨
