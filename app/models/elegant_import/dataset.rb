module ElegantImport
  class Dataset
    include ActiveModel::Model
    attr_accessor :data_file, :model
    
    def initialize(attributes)
      if(attributes && attributes[:model_class_name])
        model_class_name = attributes.delete(:model_class_name)
        attributes[:model] = Model.find(model_class_name)
      end
      super(attributes)
    end
    
    validates :data_file, presence: true
    
    def model_class_name
      model.class_name
    end
    
  end
end