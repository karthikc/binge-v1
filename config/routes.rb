Binge::Engine.routes.draw do
  get '/:model_name', to: 'datasets#new', as: 'upload'
  root to: "datasets#new"
  resources :datasets
end
