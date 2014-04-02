class V1::AccountController < ApplicationController
  before_action :authenticate_user!

  # GET /account
  def show
    @account = current_user.account
    render json: @account
  end
end
