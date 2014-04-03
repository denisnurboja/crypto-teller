class V1::OrdersController < ApplicationController
  before_action :authenticate_user!

  # GET /orders
  def index
    @orders = current_account.orders
    render json: @orders
  end

  # GET /orders/:id
  def show
    @order = current_account.orders.find(params[:id])
    render json: @order
  end

  # POST /orders
  def create
    @order = current_account.orders.build(order_params)
    @order.save!

    OrderWorker.perform_async(@order.id)

    render json: @order, status: :created
  end

  private

  def current_account
    current_user.account
  end

  def order_params
    params.require(:order).permit(:amount, :direction, :address, :currency)
  end
end
