require 'spec_helper'

describe "show selected model details", :type => :feature do

  before do
    visit '/import'
  end

  it "shows me all the models in the nav bar" do
    within(".navbar-nav:first") do
      expect(page).to have_link 'Student'
      expect(page).to have_link 'School'
    end
  end

  it "shows only the first model as an active link" do
    within(".navbar-nav:first") do
      expect(find('li.active')).to have_link 'Student'
      expect(find('li.active')).to_not have_link 'School'
    end
  end

  it "shows the selected model's attributes" do
    within("#attributes_body") do
      expect(page).to have_content 'name: string'
      expect(page).to have_content 'date_of_birth: date'
      expect(page).to have_content 'school_id: integer'
    end
  end

  it "shows the selected model name" do
    within(".page-header") do
      expect(page).to have_content 'Student'
      expect(page).to have_content 'Bulk import student data'
    end
  end

  it "should allow selecting a different model" do
    click_link "School"
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
