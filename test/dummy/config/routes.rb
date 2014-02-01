Rails.application.routes.draw do

  mount ElegantImport::Engine => "/import"
end
