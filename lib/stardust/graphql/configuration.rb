module Stardust
  module GraphQL
    class Configuration

      def setup_context(&block)
        if block_given?
          @setup_context = block
        else
          @setup_context
        end
      end

      def around_execute(&block)
        if block_given?
          @around_execute = block
        else
          @around_execute
        end
      end

    end
  end
end
