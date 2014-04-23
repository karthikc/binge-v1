Binge::Engine.routes.draw do
  get '/:model_name', to: 'datasets#new', as: 'upload'
  post '/datasets', to: 'datasets#create'
  root to: "datasets#new"
end
