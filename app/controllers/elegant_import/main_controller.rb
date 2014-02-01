require_dependency "elegant_import/application_controller"

module ElegantImport
  class MainController < ApplicationController
    def index
      @import_classes = ElegantImport.import_classes
      @selected_class_name = params[:model_name] || @import_classes.first.underscore
      @selected_class = @selected_class_name.classify.constantize
    end
    
    def process_file
      uploader = DataUploader.new
      data_file = params['datafile']
      uploader.store!(data_file)
      @file_name = uploader.filename
      @csv_file = uploader.retrieve_from_store!(@file_name)
    end
  end
end
