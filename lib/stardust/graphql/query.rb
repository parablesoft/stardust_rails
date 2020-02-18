module Stardust
  module GraphQL
    class Query
      attr_reader :context
      attr_reader :field

      def initialize(object:, context:, field: nil)
        @context = context
        @field = field
      end

      def current_user
        context[:current_user]
      end

      def self.authorized?(object, context)
        true
      end

      def self.accessible?(context)
        true
      end

      def self.visible?(context)
        true
      end

      class << self
        def type(type)
          @__type__ = type
        end

        def null(null)
          @__null__ = null
        end

        def description(description)
          @__description__ = description
        end

        def argument(name, type, description = nil, **kwargs, &block)
          @__arguments__ ||= []
          @__arguments__ << [name, type, description, kwargs, block]
        end

        def get_type
          @__type__
        end

        def get_null
          @__null__
        end

        def get_description
          @__description__
        end

        def get_arguments
          @__arguments__ || []
        end
      end
    end
  end
end
