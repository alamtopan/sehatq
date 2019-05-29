module UserService
  class Auth
    def initialize(opsts={})
      @params = opsts[:params]
      @current_user = opsts[:current_user] if opsts[:current_user].present?
    end

    def omniouth
      raise ::StandardError, 'Provider not authorize' unless ['facebook','google-oauth2'].include?(@params[:provider])

      @user = User.find_or_create_by(uid: @params[:uid], provider: @params[:provider])
      @user.username = @params[:uid]
      @user.email = "#{@params[:uid]}@#{@params[:provider]}.com" if @params[:email].blank?
      @user.email = @params[:email] if @params[:email].present?
      @user.full_name = @params[:fullname].present? ? @params[:fullname] : @params[:name]
      @user.password = @params[:uid]
      @user.save! unless @user.persisted?
      @user.generate_token
      @user
    end

    def login
      @user = User.where("users.email =? or users.username =?", @params[:identifier], @params[:identifier]).last

      raise ::StandardError, 'Email or Username Not Found' if @user.blank?
      raise ::StandardError, 'Wrong Password' unless @user.has_password?(@params[:password])

      @user.generate_token
      @user
    end

    def register
      raise ::StandardError, 'Password must be at least 6 digits' if @params[:password].length < 6

      @user = User.create!(@params)
      @user
    end

    def logout
      raise ::StandardError, 'Curren user not found' if @current_user.blank?

      @current_user.tokens.destroy_all
      @current_user
    end
  end
end