# Contributing to Claude Dialogue

Thank you for considering contributing to Claude Dialogue! 🎉

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:

- A clear, descriptive title
- Steps to reproduce the behavior
- Expected behavior
- Actual behavior
- Screenshots if applicable
- Your environment (Ruby version, OS, etc.)

### Suggesting Enhancements

Enhancement suggestions are welcome! Please open an issue with:

- A clear, descriptive title
- Detailed description of the proposed feature
- Why this enhancement would be useful
- Possible implementation approach

### Pull Requests

1. Fork the repository
2. Create a new branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add or update tests as necessary
5. Ensure all tests pass (`bundle exec rspec`)
6. Commit your changes (`git commit -m 'Add some amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/your-username/claude-dialogue.git
cd claude-dialogue

# Install dependencies
./setup.sh

# Set up API key
export ANTHROPIC_API_KEY='your-key'

# Run tests
bundle exec rspec

# Start development server
ruby app.rb
```

## Code Style

- Follow Ruby community style guidelines
- Use meaningful variable and method names
- Add comments for complex logic
- Keep methods small and focused
- Write tests for new features

## Testing

All new features should include tests. We use RSpec for testing.

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/app_spec.rb

# Run tests with coverage
bundle exec rspec --format documentation
```

## Commit Messages

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit first line to 72 characters
- Reference issues and pull requests liberally

## Areas for Contribution

Some ideas for contributions:

- **UI/UX improvements**: Make the interface even more beautiful
- **Additional stopping conditions**: Beyond just max_turns
- **Export functionality**: Save conversations to various formats
- **More Claude models**: Support different Claude model variants
- **WebSocket support**: Replace polling with real-time WebSocket updates
- **User authentication**: Add user accounts and private conversations
- **Conversation search**: Search through past conversations
- **Analytics**: Conversation analytics and insights
- **Mobile app**: Native mobile application
- **API documentation**: Improved API docs with examples

## Questions?

Feel free to open an issue with the label "question"!

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
