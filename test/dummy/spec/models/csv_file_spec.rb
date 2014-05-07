require 'spec_helper'

module Binge

  describe CsvFile do
    let(:schools_with_name_and_location) { File.new("#{Rails.root}/spec/fixtures/schools_one_wrong_header.csv") }

    it "should be able to retrieve the headers" do
      csv_file = CsvFile.new(schools_with_name_and_location)
      expect(csv_file.headers).to match_array ["name", "location"]
    end
  end

end