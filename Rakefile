require 'bundler/gem_tasks'

task :console do
  require 'irb'
  require 'irb/completion'
  require 'diachronr' # You know what to do.
  ARGV.clear
  IRB.start
end

task :test do
  Dir.glob('./test/*_test.rb').each { |file| require file }
end