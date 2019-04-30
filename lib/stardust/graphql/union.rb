module Stardust
  module GraphQL
    class Union < ::GraphQL::Schema::Union


      def self.possible_type(type, klass)
        @__possible_types__ ||= {}
        @__possible_types__[type] = klass
      end

      def self.replace_types!
        return unless @__possible_types__
        @__possible_types__ = @__possible_types__.reduce({}) do |accu, (type, klass)|
          lu_type = Collector.lookup_type(type)
          accu[lu_type] = klass
          accu
        end
        self.send(:possible_types, *@__possible_types__.keys)
      end

      def self.resolve_type(obj, ctx)
        @__possible_types__.invert[obj.class]
      end

    end
  end
end
