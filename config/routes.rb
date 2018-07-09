Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  namespace :api, defaults: { format: "json" } do
    get :me, to: 'me#me'
    get :people, to: 'people#index'
    get :letter_frequency, to: 'people#letter_frequency'
    get :potential_duplicates, to: 'people#potential_duplicates'
  end

  root to: "main#index"
end
