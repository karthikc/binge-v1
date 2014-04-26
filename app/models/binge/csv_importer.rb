require 'csv'

module Binge
  class CsvImporter

    attr_reader :total_rows_count
    attr_reader :rows_with_errors

    def initialize(base)
      @base = base
      @rows_with_errors = []

      define_converters
    end

    def import
      total_rows = csv_data.to_a.map(&:to_hash)
      @total_rows_count = total_rows.size

      @base.model.klass.transaction do
        total_rows.each do |row_hash|
          model = @base.model.create(row_hash)
          @rows_with_errors << model if model.errors.any?
        end
      end
    end

    def imported_rows_count
      total_rows_count - rows_with_errors.size
    end

    private

    def define_converters
      CSV::HeaderConverters[:to_attribute] = lambda do |header|
        header.strip.to_sym
      end
      CSV::Converters[:strip] = lambda do |field|
        field.blank? ? nil : field.strip
      end
    end

    def csv_data
      CSV.new(@base.data_file.read,
        headers: true,
        header_converters: :to_attribute,
        converters: [:strip, :all]
      )
    end
  end
end
