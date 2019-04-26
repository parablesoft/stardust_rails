module Stardust
  module GraphQL
    class Field < ::GraphQL::Schema::Field

      def initialize(*args, **kwargs, &block)
        super(*args, **kwargs, &block)
      end

      def authorize(proc, &block)
        @authorize = block_given? ? block : proc
      end

      def authorized?(obj, ctx)
        if @authorize.respond_to?(:call)
          unless @authorize.(obj, ctx)
            raise ::GraphQL::ExecutionError, "Not authorized"
          end
        else
          super(obj, ctx)
        end
      end

      def resolve(&block)
        @resolve = block
      end

      def argument(name, type, description = nil, loads: nil, **kwargs)
        actual_type = Collector.lookup_type(type)
        if loads
          kwargs[:prepare] = ->(obj, ctx) { loads.find(obj) }
        end

        super(name, actual_type, description, **kwargs)
      end

    end
  end
end
