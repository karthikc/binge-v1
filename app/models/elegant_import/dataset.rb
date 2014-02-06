require 'csv'
module ElegantImport

  class Dataset
    include ActiveModel::Model
    extend CarrierWave::Mount
    include CarrierWave::Validations::ActiveModel

    attr_accessor :data_file, :model
    mount_uploader :data_file, DataUploader
    
    def initialize(attributes)
      if(attributes && attributes[:model_class_name])
        model_class_name = attributes.delete(:model_class_name)
        attributes[:model] = Model.find(model_class_name)
      end
      super(attributes)
    end
    
    validates_integrity_of :data_file
    validates :data_file, presence: true, unless: "data_file_integrity_error"
    validate :atleast_one_row, unless: "data_file.blank?"
    validate :header_matches_model_attributes, unless: "data_file.blank?"
    
    def model_class_name
      model.class_name
    end
    
    def csv
      @csv ||= CSV.parse(data_file.read)
    end
    
    private
    def atleast_one_row
      self.errors.add(:data_file, "should have atleast one data row") if csv.to_a.size <= 1
    end
    
    def header_matches_model_attributes
      headers = csv.to_a.first
      all_columns_present = model.columns.all? {|column| headers.include?(column.name)}
      self.errors.add(:data_file, "header does not match model attributes #{model.columns.collect(&:name)}") unless all_columns_present
    end
    
  end

end