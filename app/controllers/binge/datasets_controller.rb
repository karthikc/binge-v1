require_dependency "binge/application_controller"

module Binge
  class DatasetsController < ApplicationController

    def new
      @selected_model = params[:model_name] ? Model.find(params[:model_name]) : Model.first
      @dataset = Dataset.new(model: @selected_model)
    end
    
    def create
      @dataset = Dataset.new(params[:dataset])
      @selected_model = @dataset.model
      unless @dataset.valid?
        render :new
        return
      end
      number_of_rows = @dataset.import_valid
      model_name = @selected_model.humanized_name.pluralize(number_of_rows)
      @import_message = "#{number_of_rows} #{model_name} imported."
      render :new
    end
    
  end
end
