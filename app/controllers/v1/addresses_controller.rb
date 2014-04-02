class V1::AddressesController < ApplicationController
  before_action :authenticate_user!

  # GET /account/addresses
  def index
    @addresses = current_account.addresses.where(filter_params)

    render json: @addresses
  end

  # POST /account/addresses
  def create
    @address = current_account.addresses.build(create_params)
    # Generate new receive address with Cryptsy client
    @address.address = client.generate_new_address(@address.currency)
    @address.save!

    render json: @address, status: :created
  end

  # PUT /account/addresses/:id
  def update
    @address = current_account.addresses.find(params[:id])
    @address.update_attributes!(update_params)

    render json: @address
  end

  private

  def current_account
    current_user.account
  end

  def client
    CryptoTeller.cryptsy_client
  end

  def filter_params
    params.permit(:currency)
  end

  def create_params
    params.require(:address).permit(:currency, :label)
  end

  def update_params
    params.require(:address).permit(:label)
  end
end
