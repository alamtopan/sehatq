module Versions::V1::Endpoints
  class UserEndpoint < Grape::API
    resources :users do
      desc '------------ Login or Register with omniouth facebook/google_oauth2 ---------------'
      params do
        requires :uid, type: String, allow_blank: false
        requires :name, type: String, allow_blank: false
        optional :email, type: String
      end

      get "auth/:provider/callback" do 
        @user = UserService::Auth.new(params: params).omniouth
        present @user, with: Versions::V1::Entities::UserEntity, message: 'Success'
      end

      desc '------------ Check token ---------------'
      get '/check-token' do
        @user = current_user
        present @user, with: Versions::V1::Entities::UserEntity, message: 'Token found'
      end

      desc '------------ Logout User ---------------'
      delete '/logout' do 
        @user = UserService::Auth.new(current_user: current_user).logout
        present @user, with: Versions::V1::Entities::UserEntity, message: 'Successfully logout'
      end

      desc "------------ Login user ---------------"
      params do
        requires :identifier, type: String, allow_blank: false
        requires :password, type: String, allow_blank: false
      end

      post '/login' do
        @user = UserService::Auth.new(params: params).login
        present @user, with: Versions::V1::Entities::UserEntity, message: 'Successfully login'
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
        @user = UserService::Auth.new(params: params).register
        present @user, with: Versions::V1::Entities::UserEntity, message: 'Successfully registered'
      end
    end

  end
end


