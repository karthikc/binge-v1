require 'spec_helper'

describe "show import error messages", :type => :feature do

  before do
    visit '/import'
  end

  it "shows an error message when no file is selected" do
    click_button "Submit"
    expect(page).to have_content "Data file can't be blank"
  end

  it "shows an error message when the file is blank" do
    attach_file "dataset[data_file]", File.join(Rails.root, "spec", "fixtures", "empty.csv")
    click_button "Submit"
    expect(page).to have_content "The file should have atleast one data row"
  end

end
