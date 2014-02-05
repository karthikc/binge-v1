require_dependency "elegant_import/application_controller"

module ElegantImport
  class MainController < ApplicationController
    def index
      @selected_model = params[:model_name] ? Model.find(params[:model_name]) : Model.first
      @dataset = Dataset.new(model: @selected_model)
    end
    
    def process_file
      @dataset = Dataset.new(params[:dataset])
      @selected_model = @dataset.model
      unless @dataset.valid?
        render :index
        return
      end
      
      # uploader = DataUploader.new
      # data_file = params['data_file']
      # 
      # 
      # csv = CSV.new(data_file, :headers => true)
      # rows = csv.to_a.map {|row| row.to_hash }
      # 
      # model_class = params[:model_name].classify.constantize
      # rows.each do |row|
      #   model_class.create!(row)
      # end
      
      # uploader.store!(data_file)
      # @file_name = uploader.filename
      # @csv_file = uploader.retrieve_from_store!(@file_name)
    end
  end
end
