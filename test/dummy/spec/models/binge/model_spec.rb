require 'spec_helper'

class StudentInvoice
end

module Binge
  describe Model do

    before(:each) do
      @exisitng_import_classes = Binge.import_classes
    end

    after(:each) do
      Binge.import_classes = @exisitng_import_classes
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

    describe "#columns" do
      it "fetches all its important columns" do
        student_columns = model("Student").columns.collect(&:name)
        expect(student_columns).to eq ["name", "date_of_birth", "school_id"]

        school_columns = model("School").columns.collect(&:name)
        expect(school_columns).to eq ["name", "city"]
      end
    end

    describe "#column_names" do
      it "fetches all important column names" do
        student_columns_names = model("Student").column_names
        expect(student_columns_names).to eq ["name", "date_of_birth", "school_id"]

        school_columns_names = model("School").column_names
        expect(school_columns_names).to eq ["name", "city"]
      end
    end

    describe "#create" do
      context "with valid attributes" do
        it "saves associated model" do
          valid_attributes = { name: 'Baldwin Boys High School', city: 'Bangalore' }
          school = model("School").create(valid_attributes)
          expect(school).to be_an_instance_of School
          expect(school.persisted?).to eq true
        end
      end

      context "with invalid attributes" do
        it "doesn't saves associated model" do
          invalid_attributes = { name: '', city: 'Bangalore' }
          school = model("School").create(invalid_attributes)
          expect(school).to be_an_instance_of School
          expect(school.persisted?).to eq false
        end
      end
    end

    describe ".all" do
      it "should fetch all configured classes" do
        Binge.import_classes = ["StudentInvoice", "OMRTest"]
        expect(Model.all).to eq [model("StudentInvoice"), model("OMRTest")]
      end
    end

    describe ".first" do
      context "when there are multiple classes configured" do
        it "should fetch the first configured class" do
          Binge.import_classes = ["StudentInvoice", "OMRTest"]
          expect(Model.first).to eq model("StudentInvoice")
        end
      end

      context "when there's a single class configured" do
        it "should fetch the configured class" do
          Binge.import_classes = ["OMRTest"]
          expect(Model.first).to eq model("OMRTest")
        end
      end

      context "when there are no configured classes" do
        it "should return nothing" do
          Binge.import_classes = []
          expect(Model.first).to be_nil
        end
      end
    end

    describe ".find" do
      before do
        Binge.import_classes = ["StudentInvoice", "OMRTest"]
      end

      it "should find a model by its class name" do
        expect(Model.find("StudentInvoice")).to eq model("StudentInvoice")
        expect(Model.find("OMRTest")).to eq model("OMRTest")
      end

      it "should find a model by its parameterized name" do
        expect(Model.find("student_invoice")).to eq model("StudentInvoice")
        expect(Model.find("omr_test")).to eq model("OMRTest")
      end
    end

    def model(class_name)
      Model.new(class_name: class_name)
    end

  end
end
