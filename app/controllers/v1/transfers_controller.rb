class V1::TransfersController < ApplicationController
  before_action :authenticate_user!

  # GET /transfers
  def index
    @transfers = current_account.transfers
    render json: @transfers
  end

  # GET /transfers/:id
  def show
    @transfer = current_account.transfers.find(params[:id])
    render json: @transfer
  end

  # POST /transfers
  def create
    @transfer = current_account.transfers.build(transfer_params)
    @transfer.save!

    render json: @transfer, status: :created
  end

  private

  def current_account
    current_user.account
  end

  def transfer_params
    params.require(:transfer).permit(:amount, :direction)
  end
end
