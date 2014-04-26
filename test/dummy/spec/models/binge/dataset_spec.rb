require 'spec_helper'

module Binge

  describe Dataset do

    let(:school_model) {Model.new(class_name: "School")}
    let(:empty_csv) do
      extend ActionDispatch::TestProcess
      fixture_file_upload("empty.csv", "text/text")
    end
    let(:schools_csv) do
      extend ActionDispatch::TestProcess
      fixture_file_upload("schools.csv", "text/text")
    end

    describe "#initialize" do

      context "when the model object is passed" do
        it "should initialize the model attribute" do
          dataset = Dataset.new(model: school_model)
          expect(dataset.model).to be school_model
        end
      end

      context "when the model class name is passed" do
        it "should initialize the model using the class name" do
          dataset = Dataset.new(model_class_name: "School")
          expect(dataset.model).to eq school_model
        end
      end

      it "should initialize the data_file attribute" do
        dataset = Dataset.new(data_file: empty_csv)
        expect(dataset.data_file.filename).to eq "empty.csv"
      end

    end

    it "should return the model class name" do
      dataset = Dataset.new(model: school_model)
      expect(dataset.model_class_name).to eq "School"
    end

    describe "#valid?" do

      context "with invalid data" do
        let(:schools_only_headers_csv) do
          extend ActionDispatch::TestProcess
          fixture_file_upload("schools_only_headers.csv", "text/text")
        end
        let(:schools_one_wrong_header_csv) do
          extend ActionDispatch::TestProcess
          fixture_file_upload("schools_one_wrong_header.csv", "text/text")
        end

        let(:schools_all_wrong_headers_csv) do
          extend ActionDispatch::TestProcess
          fixture_file_upload("schools_all_wrong_headers.csv", "text/text")
        end

        let(:wrong_format_txt) do
          extend ActionDispatch::TestProcess
          fixture_file_upload("wrong_format.txt", "text/text")
        end

        it "should contain the data file" do
          dataset = Dataset.new({model: school_model})
          expect(dataset).to have(1).error_on(:data_file)
          expect(dataset.errors_on(:data_file)).to include("Data file can't be blank")
        end

        it "should contain the model" do
          dataset = Dataset.new({data_file: schools_csv})
          expect(dataset).to have(1).error_on(:model)
          expect(dataset.errors_on(:model)).to include("Model can't be blank")
        end

        context "when only the header row is present" do
          it "should show an error message" do
            dataset = Dataset.new(data_file: schools_only_headers_csv, model: school_model)
            expect(dataset).to have(1).error_on(:data_file)
            expect(dataset.errors_on(:data_file)).to include("The file should have atleast one data row")
          end
        end

        context "when no rows are present" do
          it "should show an error message" do
            dataset = Dataset.new(data_file: empty_csv, model: school_model)
            expect(dataset).to have(1).error_on(:data_file)
            expect(dataset.errors_on(:data_file)).to include("The file should have atleast one data row")
          end
        end

        context "when one of the model attributes is missing" do
          it "should show an error message with the missing attribute" do
            dataset = Dataset.new(data_file: schools_one_wrong_header_csv, model: school_model)
            expect(dataset).to have(1).error_on(:data_file)
            expect(dataset.errors_on(:data_file)).to include("The file does not have the following required columns: city")
          end
        end

        context "when all model attributes are missing" do
          it "should show an error message with all the attributes" do
            dataset = Dataset.new(data_file: schools_all_wrong_headers_csv, model: school_model)
            expect(dataset).to have(1).error_on(:data_file)
            expect(dataset.errors_on(:data_file)).to include("The file does not have the following required columns: name, city")
          end
        end

        it "should not contain data in formats other than csv " do
          dataset = Dataset.new(data_file: wrong_format_txt, model: school_model)
          expect(dataset).to have(1).error_on(:data_file)
          expect(dataset.errors_on(:data_file)).to include("You are not allowed to upload \"txt\" files, allowed types: csv")
        end
      end

      context "with valid data" do
        it "should have no errors when data file has valid rows" do
          dataset = Dataset.new(data_file: schools_csv, model: school_model)
          expect(dataset).to have(:no).errors_on(:data_file)
        end
      end
    end

    describe "#import" do
      let(:three_schools_csv) do
        extend ActionDispatch::TestProcess
        fixture_file_upload("3_valid_schools.csv", "text/text")
      end

      let(:two_schools_csv) do
        extend ActionDispatch::TestProcess
        fixture_file_upload("2_valid_1_invalid_school.csv", "text/text")
      end

      it "should import all valid data into the databse" do
        dataset = Dataset.new(data_file: schools_csv, model: school_model)
        expect(dataset.import_valid.rows_with_errors.size).to eq 0
        expect(School).to have(1).record
        expect(School.first.name).to eq "Baldwin Boys High School"
      end

      it "should import multiple rows into the databse" do
        dataset = Dataset.new(data_file: three_schools_csv, model: school_model)
        expect(dataset.import_valid.rows_with_errors.size).to eq 0
        expect(School).to have(3).records

        school_names = School.all.collect(&:name)
        expect(school_names).to match_array ["Baldwin Boys High School", "St. Joseph's Boys School", "UCLA"]
      end

      it "should not import invalid rows into the databse" do
        dataset = Dataset.new(data_file: two_schools_csv, model: school_model)
        expect(dataset.import_valid.rows_with_errors.size).to eq 1
        expect(School).to have(2).records

        school_names = School.all.collect(&:name)
        expect(school_names).to match_array ["Baldwin Boys High School", "St. Joseph's Boys School"]
      end
    end

  end

end
