#!/usr/bin/env rake

##
# Configure the test suite.
##
require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

##
# RuboCop
##
require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-rspec'
end
task lint: :rubocop

##
# By default, just run the tests.
##
task default: :spec
