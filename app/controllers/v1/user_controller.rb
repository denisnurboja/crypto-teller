class V1::UserController < ApplicationController
  before_action :authenticate_user!

  # GET /user
  def show
    @user = current_user
    render json: @user
  end

  # PUT /user
  def update
    @user = current_user
    @user.update_attributes!(user_params)

    render json: @user
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
