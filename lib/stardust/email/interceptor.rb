module Stardust
  module Email
    class Interceptor

      def self.delivering_email( message )
        message.cc = []
        message.subject = '[STAGING] ' + message.subject
      end

    end
  end
end
