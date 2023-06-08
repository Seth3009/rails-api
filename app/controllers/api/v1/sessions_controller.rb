class Api::V1::SessionsController < Devise::SessionsController
  # protect_from_forgery with: :null_session #disable Cross site request forgery
  before_action :sign_in_params, only: [:create]
  before_action :load_user, only: [:create]
  before_action :valid_token, only: [:destroy]
  skip_before_action :verify_signed_out_user, only: [:destroy]

  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in "user", @user
      json_response "Signed in", true, {user: @user}, :ok
    else
      json_response "Unauthorized", false, {}, :unauthorized
    end
  end

  def destroy
    
    sign_out @user
    @user.generate_new_authentication_token
    json_response "Signed out successfuly", true, {}, :ok
  end

  private
  def sign_in_params
    params.require(:sign_in).permit(:email, :password)
  end

  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
    if @user && @user.persisted?
      return @user
    else
      json_response("Cannot find the user", false, {}, :failure)
    end
  end

  def valid_token
    @user = User.find_by authentication_token: request.headers["AUTH-TOKEN"]
    if @user
      return @user
    else
      json_response "Invalid Token", false, {}, :ok
    end
  end
end