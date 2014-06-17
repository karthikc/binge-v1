require 'spec_helper'

module Binge
  describe CsvFile do

    let(:schools_with_name_and_location) { File.new("#{Rails.root}/spec/fixtures/schools_one_wrong_header.csv") }
    let(:valid_schools) { File.new("#{Rails.root}/spec/fixtures/3_valid_schools.csv") }

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
        csv_file.total_rows_count.should eql 1
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

    describe '#import' do
      it 'create model record per valid row' do
        school_model = Model.new(class_name: "School")
        csv_file = CsvFile.new(valid_schools)

        School.destroy_all
        School.count.should eql 0

        csv_file.import(school_model)

        School.count.should eql 3
        csv_file.rows_with_errors.should eql []
      end
    end

    describe '#imported_rows_count' do
      it 'calculates successfully imported rows count' do
        csv_file = CsvFile.new(valid_schools)

        csv_file.imported_rows_count.should eql 3
      end
    end

  end
end
