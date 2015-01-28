Binge::Engine.routes.draw do
  get '/:model_name', to: 'datasets#new', as: 'upload'
  post '/datasets', to: 'datasets#create'
  post '/datasets/preview', to: 'datasets#preview'

  root to: "datasets#new"
end
