require 'spec_helper'

describe "succesful import", :type => :feature do

  before do
    visit '/import/school'
  end

  it "shows the number of rows imported" do
    attach_file "dataset[data_file]", File.join(Rails.root, "spec", "fixtures", "3_valid_schools.csv")
    click_button "Submit"

    within(".navbar-nav:first") do
      expect(find('li.active')).to_not have_link 'Student'
      expect(find('li.active')).to have_link 'School'
    end

    within("#attributes_body") do
      expect(page).to have_content 'name: string'
      expect(page).to have_content 'city: string'
    end

    within(".page-header") do
      expect(page).to have_content 'School'
      expect(page).to have_content 'Bulk import school data'
    end
  end
end
