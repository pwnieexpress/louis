require "bundler/gem_tasks"

task :environment do
  base_path = File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
  $LOAD_PATH.unshift(base_path) unless $LOAD_PATH.include?(base_path)

  require 'louis'
end

desc "Start a pry session with the code loaded"
task :console => [:environment] do
  require 'pry'
  pry
end
