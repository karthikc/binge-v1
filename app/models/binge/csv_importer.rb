require 'csv'

module Binge
  class CsvImporter

    attr_reader :total_rows_count
    attr_reader :rows_with_errors

    def initialize(base)
      @base = base
      @rows_with_errors = []
    end

    def import
      total_rows = csv_data.to_a.map(&:to_hash)
      @total_rows_count = total_rows.size

      @base.model.klass.transaction do
        total_rows.each_with_index do |row_hash, index|
          model = @base.model.create(row_hash)
          @rows_with_errors << {row_number: index+1, model: model} if model.errors.any?
        end
      end
    end

    def imported_rows_count
      total_rows_count - rows_with_errors.size
    end

    private

    def csv_data
      CSV.new(@base.data_file.read,
        headers: true,
        header_converters: :to_attribute,
        converters: [:strip, :all]
      )
    end
  end
end
