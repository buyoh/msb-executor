#!/usr/bin/env ruby

argv = ARGV.clone

subcmd = argv.shift

if subcmd == 'start'
  puts 'wip'

elsif subcmd == 'setup'
  system 'bundle install'

elsif subcmd == 'test'
  aa = argv & ['--only-failures']
  system 'bundle exec rspec ' + aa*' '

elsif subcmd == 'help'
  puts 'subcommand list = [start, setup, test, help]'
  
else
  puts 'subcommand not found'
  abort
end
