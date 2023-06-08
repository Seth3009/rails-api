class Api::V1::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :null_session #disable Cross site request forgery
  before_action :ensure_params_exist, only: :create

  def create
    user = User.new user_params
    if user.save
      json_response("Signup Successfully", true, {user: user}, :ok)
    else
      json_response("Something Wrong", false, {}, :unprocessable_entity)
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def ensure_params_exist
    return if params[:user].present?
    json_response("params are missing", false, {}, :bad_request)
  end
end