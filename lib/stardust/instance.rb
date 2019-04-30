module Stardust
  module Instance

    def instance
      if Rails.env == 'production'
        ENV['INSTANCE']&.to_sym || :production
      else
        Rails.env.to_sym
      end
    end

    def production?
      instance == :production
    end

    def staging?
      instance == :staging
    end

    def development?
      instance == :development
    end

  end
end
