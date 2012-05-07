$LOAD_PATH.unshift File.dirname(__FILE__) + "/../lib"
require "rubygems"
require "rspec"

module Spec
  module MongoMapper
    def self.configure!
      ::MongoMapper.database = "machinist_mongomapper"
  
      ::RSpec.configure do |config|
        config.after(:all)   { ::MongoMapper.database.collections.each { |c| c.remove } }
      end
    end
  end

  module Mongoid
    def self.configure!
      ::Mongoid.configure do |config|
        config.master = Mongo::Connection.new.db("machinist_mongoid")
        config.allow_dynamic_fields = true
      end

      ::RSpec.configure do |config|
        config.after(:all)   { ::Mongoid.master.collections.each { |c| c.remove } }
      end
    end
  end
end
