Rails.application.routes.draw do

  mount Binge::Engine => "/import"
end
