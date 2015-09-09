require 'forwardable'

module Binge
  class Dataset
    include ActiveModel::Model
    extend CarrierWave::Mount
    include CarrierWave::Validations::ActiveModel
    extend Forwardable

    def_delegators :import_result, :total_rows,
                                   :failed_rows,
                                   :imported_rows

    attr_accessor :data_file, :model
    mount_uploader :data_file, DataUploader

    def initialize(attributes = {})
      if attributes[:model_class_name]
        model_class_name   = attributes.delete(:model_class_name)
        attributes[:model] = Model.find(model_class_name)
      end

      super(attributes)
    end

    validates :model, presence: {message: "Model can't be blank"}
    validates_integrity_of :data_file
    validates :data_file, presence: {message: "Data file can't be blank"}, unless: "data_file_integrity_error"
    validate :atleast_one_row, unless: "data_file.blank?"
    validate :header_matches_model_attributes, unless: "data_file.blank? or model.blank?"

    def model_class_name
      model.class_name
    end

    # Returns nil if self is invalid,
    # otherwise imports file.
    def import_valid
      return unless valid?

      file.import(self.model)
      file
    end

    # Returns nil if self is invalid,
    # otherwise previews file.
    def preview_valid
      return unless valid?

      file.preview(self.model)
      file
    end

    def file
      @file ||= CsvFile.new(data_file)
    end

    def has_result?
      data_file.present?
    end

    def import_result
      @import_result ||= ImportResult.new(@file)
    end

    private

    def atleast_one_row
      self.errors.add(:data_file, "The file should have atleast one data row") if file.size < 1
    end

    def header_matches_model_attributes
      return if file.empty?

      missing_column_names = model.column_names.reject do |column_name|
        file.has_header?(column_name)
      end.join(", ")

      return if missing_column_names.empty?
      self.errors.add(:data_file, "The file does not have the following required columns: #{missing_column_names}")
    end
  end
end
