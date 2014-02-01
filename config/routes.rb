ElegantImport::Engine.routes.draw do
  get '/:model_name', to: 'main#index', as: 'upload'
  post '/process_file', to: 'main#process_file', as: 'process_file'
  root to: "main#index"
end
