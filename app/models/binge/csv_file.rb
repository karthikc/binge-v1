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
          _model = model.create(row.to_hash)
          @rows_with_errors << {row_number: index+1, model: _model} if _model.errors.any?
        end
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

  end
end
