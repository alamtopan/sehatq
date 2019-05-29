module Versions
  module Kernel
    extend ActiveSupport::Concern

    included do
      version 'v1', using: :path
      format :json
      prefix :api
      default_format :json
      error_formatter :json, ::Versions::ErrorFormatter

      rescue_from :all do |e|
        error!(e.message, 400)
        # message = e.message.split(',').first
        # error!(message, 400)
      end


      helpers do
        def auth_token
          headers['Authorization'].split('Bearer ')[1] if headers['Authorization'].present?
        end

        def current_user
          error!('Not Authorize', 400) unless auth_token

          decoded_data = JWT.decode(auth_token, 'SIGNATURE-KEY-BASE', 'HS256')
          error!('Token has been expired', 400) if Time.now.to_i > decoded_data.first['expiry_date'].to_datetime.to_i

          token = Token.find_by_token auth_token
          error!('Token not found', 400) unless token

          user = User.find decoded_data.first['identifier']
        end

        def current_order
          if env['rack.session'][:order_id].present?
            @current_order = Order.find(env['rack.session'][:order_id])
          else
            @current_order = Order.create!(user_id: current_user.id)
            env['rack.session'][:order_id] = @current_order.id
          end
          
          return @current_order
        end

        def authenticate
          error!('401 Unauthorized', 401) unless current_user
        end

        def permitted_params
          @permitted_params ||= declared(params, include_missing: false)
        end

        def logger
          Rails.logger
        end
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        error_response(message: e.message, status: 404)
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        error_response(message: e.message, status: 422)
      end
    end
  end
end