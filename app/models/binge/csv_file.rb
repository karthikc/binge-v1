require 'csv'

module Binge

  class CsvFile

    def initialize(file)
      @file = file
    end
    
    def headers
      csv = CSV.parse(@file.read)
      csv.to_a.first.collect(&:strip)
    end
    
  end

end
