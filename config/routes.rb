Rails.application.routes.draw do
  resources :customers
  post 'customers/:id/ephemeral_key' => 'customers#generate_ephemeral_key'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
