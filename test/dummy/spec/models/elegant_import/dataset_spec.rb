require 'spec_helper'

module ElegantImport

  describe Dataset do
  
    let(:school_model) {Model.new(class_name: "School")}

    describe "#initialize" do
    
      let(:student_model) {Model.new(class_name: "Student")}
      let(:empty_csv) do
        extend ActionDispatch::TestProcess
        fixture_file_upload("empty.csv", "text/text")
      end

      context "when the model object is passed" do
        it "should initialize the model attribute" do
          dataset = Dataset.new(model: student_model)
          expect(dataset.model).to be student_model
        end
      end

      context "when the model class name is passed" do
        it "should initialize the model using the class name" do
          dataset = Dataset.new(model_class_name: "Student")
          expect(dataset.model).to eq student_model
        end
      end
    
      it "should initialize the data_file attribute" do
        dataset = Dataset.new(data_file: empty_csv)
        expect(dataset.data_file.filename).to eq "empty.csv"
      end

    end
  
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

      it "should contain the data file" do
        dataset = Dataset.new({})
        expect(dataset).to have(1).error_on(:data_file)
        expect(dataset.errors_on(:data_file)).to include("can't be blank")
      end

      it "should contain the model" do
        dataset = Dataset.new({})
        expect(dataset).to have(1).error_on(:model)
        expect(dataset.errors_on(:model)).to include("can't be blank")
      end
      
      it "should have atleast one row in the data file" do
        dataset = Dataset.new(data_file: schools_only_headers_csv, model: school_model)
        expect(dataset).to have(1).error_on(:data_file)
        expect(dataset.errors_on(:data_file)).to include("should have atleast one data row")
      end

      context "when one of the model attributes is missing" do
        it "should show an error message with the missing attribute" do
          dataset = Dataset.new(data_file: schools_one_wrong_header_csv, model: school_model)
          expect(dataset).to have(1).error_on(:data_file)
          expect(dataset.errors_on(:data_file)).to include("does not have the following columns: city")
        end
      end

      context "when all model attributes are missing" do
        it "should show an error message with all the attributes" do
          dataset = Dataset.new(data_file: schools_all_wrong_headers_csv, model: school_model)
          expect(dataset).to have(1).error_on(:data_file)
          expect(dataset.errors_on(:data_file)).to include("does not have the following columns: name, city")
        end
      end
    
    end
    
    context "with valid data" do
      let(:schools_csv) do
        extend ActionDispatch::TestProcess
        fixture_file_upload("schools.csv", "text/text")
      end

      it "should have no errors when data file has valid rows" do
        dataset = Dataset.new(data_file: schools_csv, model: school_model)
        expect(dataset).to have(:no).errors_on(:data_file)
      end
    end
  
  end

end