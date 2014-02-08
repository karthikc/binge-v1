require 'spec_helper'

describe ElegantImport::Dataset do
  
  describe "#initialize" do
    
    let(:student_model) {ElegantImport::Model.new(class_name: "Student")}
    let(:sample_csv) do
      extend ActionDispatch::TestProcess
      fixture_file_upload("sample.csv", "text/text")
    end

    context "when the model object is passed" do
      it "should initialize the model attribute" do
        dataset = ElegantImport::Dataset.new(model: student_model)
        expect(dataset.model).to be student_model
      end
    end

    context "when the model class name is passed" do
      it "should look the model up" do
        dataset = ElegantImport::Dataset.new(model_class_name: "Student")
        expect(dataset.model).to eq student_model
      end
    end
    
    it "should initialize the data_file attribute" do
      dataset = ElegantImport::Dataset.new(data_file: sample_csv)
      expect(dataset.data_file.filename).to eq "sample.csv"
    end

  end
  
  
  
end
