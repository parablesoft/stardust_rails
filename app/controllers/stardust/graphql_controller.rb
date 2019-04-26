module Stardust
  class GraphQLController < ActionController::API

    def execute
      variables = ensure_hash(params[:variables])
      query = params[:query]
      operation_name = params[:operationName]

      context = {
        # Query context goes here, for example:
        current_user: current_user,
        ip: request.remote_ip,
        user_agent: request.headers["HTTP_USER_AGENT"],
        timezone: "Eastern Time (US & Canada)"
      }

      result = GraphQL::Schema.execute(
        query,
        variables: variables,
        context: context,
        operation_name: operation_name
      )

    render json: result

    # rescue JWT::ExpiredSignature
    #   render json: { error: {
    #     message: "Expired ExpiredSignature",
    #   }}, status: 401
    rescue StandardError => e
      raise e unless Rails.env.development?
      handle_error_in_development e
    end


    private

    # gets current user from token stored in session
    def current_user
      if auth_header = request.headers['Authorization']
        # TODO: add logic for authorization verification

        # token = request.headers['Authorization'].split(" ").last
        # decoded_hash = Auth0::Decoder.decode(token)
        # User.new(decoded_hash[0].deep_symbolize_keys)
      end
    end

    # Handle form data, JSON body, or a blank value
    def ensure_hash(ambiguous_param)
      case ambiguous_param
      when String
        if ambiguous_param.present?
          ensure_hash(JSON.parse(ambiguous_param))
        else
          {}
        end
      when Hash, ActionController::Parameters
        ambiguous_param
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
      end
    end

    def handle_error_in_development(e)
      logger.error e.message
      logger.error e.backtrace.join("\n")

      render json: { error: { message: e.message, backtrace: e.backtrace }, data: {} }, status: 500
    end
  end
end
