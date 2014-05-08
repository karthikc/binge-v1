module Binge
  class DatasetsController < ApplicationController

    def new
      selected_model = params[:model_name] ? Model.find(params[:model_name]) : Model.first
      @dataset = Dataset.new(model: selected_model)
    end

    def create
      @dataset = Dataset.new(params[:dataset])
      @import_results = @dataset.valid? ? @dataset.import_valid : nil
      render :new
    end

  end
end
