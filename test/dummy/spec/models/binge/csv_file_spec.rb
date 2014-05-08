require 'spec_helper'

module Binge
  describe CsvFile do

    let(:schools_with_name_and_location) { File.new("#{Rails.root}/spec/fixtures/schools_one_wrong_header.csv") }

    describe '#headers' do
      it 'returns array with header names' do
        csv_file = CsvFile.new(schools_with_name_and_location)
        csv_file.headers.should eql [:name, :location]
      end
    end

    describe '#size' do
      it 'returns file size' do
        csv_file = CsvFile.new(schools_with_name_and_location)
        csv_file.size.should eql 1
      end
    end

    describe '#empty?' do
      it 'returns true if file is blank' do
        csv_file = CsvFile.new(File.new("#{Rails.root}/spec/fixtures/empty.csv"))
        csv_file.empty?.should be_true
      end
    end

    describe '#has_header?' do
      it 'checks if header exists in raw csv' do
        csv_file = CsvFile.new(schools_with_name_and_location)

        csv_file.has_header?('name').should be_true
        csv_file.has_header?('location').should be_true
        csv_file.has_header?('wrong_header').should be_false
      end
    end

  end
end
