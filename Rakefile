# encoding: utf-8
require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "machinist_mongo"
    gem.summary = %Q{Machinist adapters for MongoDB ORMs}
    gem.email = "nicolas.merouze@gmail.com"
    gem.homepage = "http://github.com/nmerouze/machinist_mongo"
    gem.authors = ["Nicolas Merouze", "Cyril Mougel"]
    gem.files = Dir["README.md", "LICENSE", "lib/**/*"]

    gem.add_dependency('machinist',  '>= 2.0.0')
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

desc 'Default: run specs.'
task :default => "spec"

desc "Run available specs for MongoMapper and Mongoid if gems exist."
RSpec::Core::RakeTask.new(:rspec)

desc 'Run all the specs for the Machinist::MongoMapper plugin. Will fail if the MongoMapper gem is not installed.'
mongo_mapper_task = RSpec::Core::RakeTask.new("rspec:mongo_mapper")
mongo_mapper_task.pattern = "spec/mongo_mapper_spec.rb"

desc 'Run all the specs for the Machinist::Mongoid plugin. Will fail if the Mongoid Gem is not installed.'
mongoid_task = RSpec::Core::RakeTask.new("rspec:mongoid")
mongoid_task.pattern = "spec/mongoid_spec.rb"


namespace :spec do
  desc "The Machinist:;MongoMapper specs if MongoMapper is defined"
  task :mongo_mapper do
    begin
      require "mongo_mapper"
      Rake::Task['rspec:mongo_mapper'].invoke
    rescue LoadError
    end
  end

  desc "The Machinist::Mongoid specs if Mongoid is defined"
  task :mongoid do
    begin
      require "mongoid"
      Rake::Task['rspec:mongoid'].invoke
    rescue LoadError
    end
  end
end

task :spec => ["spec:mongo_mapper", "spec:mongoid"]
