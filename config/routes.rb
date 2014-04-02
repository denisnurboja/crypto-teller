CryptoTeller::Application.routes.draw do
  devise_for :users, skip: :all

  scope module: 'v1', format: false, defaults: { format: 'json' } do
    # Accounts
    get  'account' => 'account#show'

    # Account receive addresses
    get  'account/addresses' => 'addresses#index'
    post 'account/addresses' => 'addresses#create'
    put  'account/addresses/:id' => 'addresses#update'

    # Orders
    get  'orders' => 'orders#index'
    get  'orders/:id' => 'orders#show'
    post 'orders' => 'orders#create'

    # Prices
    get  'prices/buy' => 'prices#buy'
    get  'prices/sell' => 'prices#sell'

    # Transfers
    get  'transfers' => 'transfers#index'
    get  'transfers/:id' => 'transfers#show'
    post 'transfers' => 'transfers#create'

    # Authenticated user
    get  'user' => 'user#show'
    put  'user' => 'user#update'

    # Users
    post 'users' => 'users#create'

    # CORS preflight
    match '(*any)' => 'home#preflight', via: :options

    root 'home#index'
  end
end
