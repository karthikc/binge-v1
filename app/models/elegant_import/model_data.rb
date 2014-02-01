module ElegantImport
  class ModelData 
    include ActiveModel::Model
    attr_accessor :file_path
  end
end