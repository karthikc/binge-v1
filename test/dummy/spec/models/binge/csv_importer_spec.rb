require 'spec_helper'

module Binge
  describe CsvImporter do

    describe "#initialize" do
      before do
        base = double()
        base.stub(class_name: 'Dataset')
        @csv_importer = CsvImporter.new(base)
      end

      it "sets @base instance variable" do
        base = @csv_importer.instance_variable_get(:@base)
        expect(base.class_name).to eq 'Dataset'
      end

      it "sets @rows_with_errors instance variable" do
        rows_with_errors = @csv_importer.instance_variable_get(:@rows_with_errors)
        expect(rows_with_errors).to eq []
      end
    end

  end
end
