require 'csv'
require 'forwardable'

module Binge
  class CsvFile
    extend Forwardable

    def_delegators :file, :headers, :size, :empty?

    attr_reader :file, :rows_with_errors

    alias_method :total_rows_count, :size

    def initialize(file)
      @file = CSV.parse(file.read, OPTIONS)
      @rows_with_errors = []
    end

    def has_header?(header_name)
      headers.include?(header_name.to_s.to_sym)
    end

    def import(model)
      model.klass.transaction do
        file.each_with_index do |row, index|
          model_instance = model.create(row.to_hash)
          push_errors(index, model_instance)
        end
      end
    end

    def preview(model)
      file.each_with_index do |row, index|
        model_instance = model.validate(row.to_hash)
        push_errors(index, model_instance)
      end
    end

    def imported_rows_count
      total_rows_count - rows_with_errors.size
    end

    private

    OPTIONS = {
      headers: true,
      header_converters: :to_attribute,
      converters: [:strip, :all]
    }

    def push_errors(index, model_instance)
      return  unless model_instance.errors.any?
      @rows_with_errors << {row_number: index+1, model: model_instance}
    end
  end
end
