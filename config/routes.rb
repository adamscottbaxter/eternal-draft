Rails.application.routes.draw do
	root 'draft#index'
	resources :draft, only: [:index]
end
