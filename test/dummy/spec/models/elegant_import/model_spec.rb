require 'spec_helper'

class StudentInvoice 
end

describe ElegantImport::Model do

  before(:each) do
    @exisitng_import_classes = ElegantImport.import_classes
  end

  after(:each) do
    ElegantImport.import_classes = @exisitng_import_classes
  end

  it "returns a parameterized class name" do
    expect(model("Student").parameterized_class_name).to eq "student"
    expect(model("StudentInvoice").parameterized_class_name).to eq "student_invoice"
    expect(model("OMRTest").parameterized_class_name).to eq "omr_test"
  end

  it "returns a human readable class name" do
    expect(model("Student").humanized_name).to eq "student"
    expect(model("StudentInvoice").humanized_name).to eq "student invoice"
    expect(model("OMRTest").humanized_name).to eq "omr test"
  end

  it "returns the associated class" do
    expect(model("StudentInvoice").klass).to eq StudentInvoice
  end
  
  it "fetches all its important columns" do
    student_columns_names = model("Student").columns.collect(&:name)
    expect(student_columns_names).to eq ["name", "date_of_birth", "school_id"]

    school_columns_names = model("School").columns.collect(&:name)
    expect(school_columns_names).to eq ["name", "city"]
  end
  
  it "should fetch all configured classes" do
    ElegantImport.import_classes = ["StudentInvoice", "OMRTest"]
    expect(ElegantImport::Model.all).to eq [model("StudentInvoice"), model("OMRTest")]
  end
  
  describe ".first" do
    context "when there are multiple classes configured" do
      it "should fetch the first configured class" do
        ElegantImport.import_classes = ["StudentInvoice", "OMRTest"]
        expect(ElegantImport::Model.first).to eq model("StudentInvoice")
      end
    end

    context "when there's a single class configured" do
      it "should fetch the configured class" do
        ElegantImport.import_classes = ["OMRTest"]
        expect(ElegantImport::Model.first).to eq model("OMRTest")
      end
    end
    
    context "when there are no configured classes" do
      it "should return nothing" do
        ElegantImport.import_classes = []
        expect(ElegantImport::Model.first).to be_nil
      end
    end
  end
  
  describe ".find" do
    it "should find a model by its class name" do
      ElegantImport.import_classes = ["StudentInvoice", "OMRTest"]
      expect(ElegantImport::Model.find("StudentInvoice")).to eq model("StudentInvoice")
      expect(ElegantImport::Model.find("OMRTest")).to eq model("OMRTest")
    end

    it "should find a model by its parameterized name" do
      ElegantImport.import_classes = ["StudentInvoice", "OMRTest"]
      expect(ElegantImport::Model.find("student_invoice")).to eq model("StudentInvoice")
      expect(ElegantImport::Model.find("omr_test")).to eq model("OMRTest")
    end
  end

  def model(class_name)
    ElegantImport::Model.new(class_name: class_name)
  end

end