module Stardust
  class GraphQLController < ActionController::API

    def execute
      result = nil

      around_execute do
        result = GraphQL::Schema.execute(
          query,
          variables: variables,
          context: context.merge({tracing_enabled: tracing_enabled}),
          operation_name: operation_name
        )
      end

      render json: ApolloFederation::Tracing.attach_trace_to_result(result)


    rescue Stardust::Errors::FailedAuthorization => e
      render json: {
        error: { message: e.message }
      }, status: 401
    rescue StandardError => e
      raise e unless Rails.env.development?
      handle_error_in_development e
    end


    private

    def operation_name
      params[:operationName]
    end

    def query
      params[:query]
    end

    def variables
      ensure_hash(params[:variables])
    end

    def tracing_enabled
      ApolloFederation::Tracing.should_add_traces(headers)
    end

    def context
      setup_context = Stardust.configuration.graphql.setup_context
      setup_context ? setup_context.(request) : {}
    end

    def around_execute(&block)
      around_execute = Stardust.configuration.graphql.around_execute
      if around_execute
        around_execute.call(request,&block)
      else
        yield
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

      render json: {
        error: {
          message: e.message,
          backtrace: e.backtrace
        },
        data: {}
      }, status: 500

    end
  end
end
