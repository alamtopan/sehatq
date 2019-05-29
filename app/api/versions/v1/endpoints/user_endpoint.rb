module Versions::V1::Endpoints
  class UserEndpoint < Grape::API
    resources :users do
      desc '------------ Login or Register with omniouth facebook/google_oauth2 ---------------'
      get "auth/:provider/callback" do 
        auth_response = params
        @user = User.find_or_create_by(uid: auth_response[:uid], provider: auth_response[:provider])
        @user.username = auth_response[:uid]
        @user.email = "#{auth_response[:uid]}@#{auth_response[:provider]}.com" if auth_response[:email].blank?
        @user.email = auth_response[:email] if auth_response[:email].present?
        @user.full_name = auth_response[:name]
        @user.password = auth_response[:uid]
        if @user.persisted?
          @user.generate_token
          @user
        else
          @user.save!
          @user.generate_token
          @user
        end
        present @user, with: Versions::V1::Entities::UserEntity
      end

      desc '------------ Check token ---------------'
      get '/check-token' do
        @user = current_user
        error!('User with token not found') if @user.blank?
        present @user, with: Versions::V1::Entities::UserEntity
      end

      desc '------------ Logout User ---------------'
      delete '/logout' do 
        current_user.delete_token
      end

      desc "------------ Login user ---------------"
      params do
        requires :identifier, type: String, allow_blank: false
        requires :password, type: String, allow_blank: false
      end

      post '/login' do
        @user = User.where("users.email =? or users.username =?", params[:identifier], params[:identifier]).last

        error!('Email or Username Not Found', 401) if @user.blank?
        error!('Wrong Password') unless @user.has_password?(params[:password])

        @user.generate_token
        present @user, with: Versions::V1::Entities::UserEntity
      end

      desc "------------ Register user ---------------"
      params do
        requires :email, type: String, allow_blank: false
        requires :username, type: String, allow_blank: false
        requires :full_name, type: String, allow_blank: false
        requires :password, type: String, allow_blank: false
        optional :avatar, type: File
      end

      post '/register' do
        @user = User.create!(params)
        present @user, with: Versions::V1::Entities::UserEntity
      end
    end

  end
end


