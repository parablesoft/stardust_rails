module Stardust
  module GraphQL
    class Scalar < GraphQL::Schema::Scalar

      def self.coerce_input(input_value = nil, context = nil, &block)
        if block_given?
          @@__coerce_input_block__ = block
        else
          @@__coerce_input_block__.(input_value, context)
        end
      end

      def self.coerce_result(ruby_value = nil, context = nil, &block)
        if block_given?
          @@__coerce_result_block__ = block
        else
          @@__coerce_result_block__.(ruby_value, context)
        end
      end

    end
  end
end
