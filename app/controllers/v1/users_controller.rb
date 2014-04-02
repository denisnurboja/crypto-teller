class V1::UsersController < ApplicationController
  # POST /users
  def create
    @user = User.create!(user_params)
    render json: @user, status: :created
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
