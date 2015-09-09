module Binge
  class ImportResult

    attr_reader :total_rows,
                :failed_rows

    def initialize(file)
      @total_rows  = file.size
      @failed_rows = file.errors_count
    end

    def imported_rows
      total_rows - failed_rows
    end

  end
end
