require 'csv'
require 'forwardable'

module Binge
  class CsvFile
    extend Forwardable

    def_delegators :data, :headers, :size, :empty?

    attr_reader :data, :rows_with_errors

    def initialize(data)
      @data = CSV.parse(data.read, OPTIONS)
      @rows_with_errors = []
    end

    def has_header?(header_name)
      headers.include?(header_name.to_s.to_sym)
    end

    def import(model)
      model.klass.transaction do
        data.each_with_index do |row, index|
          model_instance = model.create(row.to_hash)
          push_errors(index, model_instance)
        end
      end
    end

    def preview(model)
      data.each_with_index do |row, index|
        model_instance = model.validate(row.to_hash)
        push_errors(index, model_instance)
      end
    end

    def errors_count
      rows_with_errors.size
    end

    def has_errors?
      rows_with_errors.any?
    end

    private

    OPTIONS = {
      headers: true,
      header_converters: :to_attribute,
      skip_blanks: true,
      converters: [:strip, :all]
    }

    def push_errors(index, model_instance)
      return unless model_instance.errors.any?
      @rows_with_errors << {row_number: index+1, model: model_instance}
    end
  end
end
