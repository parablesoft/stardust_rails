module Stardust
  module GraphQL
    module Extensions
      class Authorize < ::GraphQL::Schema::FieldExtension

        def after_resolve(object:, arguments:, context:, value:, memo:)
         klass = field.instance_variable_get(:@resolver_class)
         instance = klass.new(object: object, context: context)

         if instance.respond_to?(:authorized?)
           unless instance.authorized?(value: value, context: context, arguments: arguments)
             raise ::GraphQL::ExecutionError, "Not authorized to access"
           end
         end
         
         value
       end

      end
    end
  end
end
