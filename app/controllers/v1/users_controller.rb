class V1::UsersController < V1::BaseController
  before_action :authenticate_user!, except: [:create]

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
