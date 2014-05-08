require 'csv'
require 'forwardable'

module Binge
  class CsvFile
    extend Forwardable

    def_delegators :@file, :headers, :size, :empty?

    def initialize(file)
      @file = CSV.parse(file.read, OPTIONS)
    end

    def has_header?(header_name)
      headers.include?(header_name.to_sym)
    end

    private

    OPTIONS = {
      headers: true,
      header_converters: :to_attribute,
      converters: [:strip, :all]
    }

  end
end
