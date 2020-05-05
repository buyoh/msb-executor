#!/usr/bin/env ruby

argv = ARGV.clone

subcmd = argv.shift

if subcmd == 'start'
  puts 'wip'

elsif subcmd == 'init'
  system 'bundle install'

elsif subcmd == 'test'
  system 'bundle exec rspec'

elsif subcmd == 'help'
  puts 'subcommand list = [start, init, test, help]'
  
else
  puts 'subcommand not found'
  abort
end
