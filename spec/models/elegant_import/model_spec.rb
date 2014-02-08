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
  
  it "can fetch all configured classes" do
    ElegantImport.import_classes = ["StudentInvoice", "OMRTest"]
    expect(ElegantImport::Model.all).to eq [model("StudentInvoice"), model("OMRTest")]
  end

  it "can fetch the first configured class" do
    ElegantImport.import_classes = ["StudentInvoice", "OMRTest"]
    expect(ElegantImport::Model.first).to eq model("StudentInvoice")

    ElegantImport.import_classes = ["OMRTest", "StudentInvoice"]
    expect(ElegantImport::Model.first).to eq model("OMRTest")
  end
  
  describe ".find" do
    it "can find a model by its class name" do
      ElegantImport.import_classes = ["StudentInvoice", "OMRTest"]
      expect(ElegantImport::Model.find("StudentInvoice")).to eq model("StudentInvoice")
      expect(ElegantImport::Model.find("OMRTest")).to eq model("OMRTest")
    end

    it "can find a model by its parameterized name" do
      ElegantImport.import_classes = ["StudentInvoice", "OMRTest"]
      expect(ElegantImport::Model.find("student_invoice")).to eq model("StudentInvoice")
      expect(ElegantImport::Model.find("omr_test")).to eq model("OMRTest")
    end
  end

  def model(class_name)
    ElegantImport::Model.new(class_name: class_name)
  end

end