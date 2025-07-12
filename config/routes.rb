Rails.application.routes.draw do

  scope '/api/v1' do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
  end

  namespace :api do
    namespace :v1 do
      resources :transactions
      resources :budgets
      resources :categories
    end
  end

  root to: "api/v1/transactions#index"
end
