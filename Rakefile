require 'rspec/core/rake_task'
require_relative 'lib/database'

desc 'Run RSpec tests'
RSpec::Core::RakeTask.new(:spec)

desc 'Start the server'
task :start do
  exec 'ruby app.rb'
end

desc 'Start the server with reloading'
task :dev do
  exec 'bundle exec rerun ruby app.rb'
end

desc 'Reset database'
task :db_reset do
  db_path = 'db/claude_dialogue.db'
  File.delete(db_path) if File.exist?(db_path)
  puts "Database deleted."
  
  ClaudeDialogue::Database.setup(db_path)
  puts "Database recreated with fresh schema."
end

desc 'Database console'
task :db_console do
  require 'sqlite3'
  db_path = 'db/claude_dialogue.db'
  
  if File.exist?(db_path)
    exec "sqlite3 #{db_path}"
  else
    puts "Database not found. Run 'rake db_reset' to create it."
  end
end

desc 'Run code linter'
task :lint do
  puts "Running RuboCop..."
  system('bundle exec rubocop') || true
end

desc 'Show conversation stats'
task :stats do
  require 'sequel'
  db = Sequel.sqlite('db/claude_dialogue.db')
  
  total_conversations = db[:conversations].count
  active_conversations = db[:conversations].where(status: 'active').count
  completed_conversations = db[:conversations].where(status: 'completed').count
  total_messages = db[:messages].count
  
  puts "\n📊 Claude Dialogue Statistics"
  puts "=" * 40
  puts "Total Conversations:     #{total_conversations}"
  puts "Active:                  #{active_conversations}"
  puts "Completed:               #{completed_conversations}"
  puts "Total Messages:          #{total_messages}"
  puts "=" * 40
  puts ""
end

desc 'Clean temporary files'
task :clean do
  FileUtils.rm_rf('tmp')
  FileUtils.rm_rf('log')
  puts "Temporary files cleaned."
end

task default: :spec
