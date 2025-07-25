Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do

      post   'users/sign_in',  to: 'auth#login'
      post   'users',          to: 'auth#signup'
      delete 'users/sign_out', to: 'auth#logout'

      resources :transactions
      resources :budgets
      resources :categories
    end
  end

  root to: "api/v1/transactions#index"
end
