Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :transactions
      resources :budgets
      resources :categories
    end
  end

  root to: "api/v1/transactions#index"
end
