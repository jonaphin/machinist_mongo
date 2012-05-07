require "machinist"
require "machinist/machinable"
begin
  require "mongo_mapper"
  require "mongo_mapper/embedded_document"
rescue LoadError
  puts "MongoMapper is not installed (gem install mongo_mapper)"
  exit
end

module Machinist

  module MongoMapper

    module Machinable
      extend ActiveSupport::Concern

      module ClassMethods
        include Machinist::Machinable
        def blueprint_class
          Machinist::MongoMapper::Blueprint
        end
      end
    end

    class Blueprint < Machinist::Blueprint

      def make!(attributes = {})
        object = make(attributes)
        object.save!
        object.reload
      end

      def lathe_class #:nodoc:
        Machinist::MongoMapper::Lathe
      end

      def outside_transaction
        yield
      end

      def box(object)
        object.id
      end

      # Unbox an object from the warehouse.
      def unbox(id)
        @klass.find(id)
      end
    end

    class Lathe < Machinist::Lathe
      def make_one_value(attribute, args) #:nodoc:
        if block_given?
          raise_argument_error(attribute) unless args.empty?
          yield
        else
          make_association(attribute, args)
        end
      end

      def make_association(attribute, args) #:nodoc:
        association = @klass.associations[attribute.to_sym]
        if association
          association.klass.make(*args)
        else
          if args.nil? || args.length > 1
            raise_argument_error(attribute)
          else
            assign_attribute(attribute, args[0])
          end
        end
      end

      def assign_attribute(key, value)
        @assigned_attributes[key.to_sym] = value
        if @object.respond_to?("#{key}=")
          @object.send("#{key}=", value)
        else
          @object[key] = value
        end
      end
    end
  end
end

module MongoMapper::Document
  include Machinist::MongoMapper::Machinable
end

module MongoMapper::EmbeddedDocument
  include Machinist::MongoMapper::Machinable
end
