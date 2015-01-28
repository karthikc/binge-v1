require 'spec_helper'

describe 'show import results', :type => :feature do

  before do
    visit '/import/school'
    attach_file 'dataset[data_file]', File.join(Rails.root, 'spec', 'fixtures', '2_valid_1_invalid_school.csv')
  end

  it 'shows total, successful and failed rows count' do
    click_button('Submit')

    within('#import-summary') do
      within('#total-rows') do
        expect(page).to have_content 'Total rows'
        expect(page).to have_content '3'
      end

      within('#successful-rows') do
        expect(page).to have_content 'Imported rows'
        expect(page).to have_content '2'
      end

      within('#failed-rows') do
        expect(page).to have_content 'Failed rows'
        expect(page).to have_content '1'
      end
    end
  end

  it 'show basic error report', :js => true do
    page.find('input[type="submit"]').click

    # Synchronizes your view to your database state before exiting test,
    # Therefore makes sure no threads remain unfinished before your teardown.
    page.should_not have_content "dude, you forgot to expect / assert anything."

    within('#error-report') do
      within(".errors-heading .panel-title") do
        expect(page).to have_content 'Errors'
      end

      # error report headers
      within('table thead tr') do
        expect(page.find(:xpath, './/th[1]')).to have_content 'Row Number'
        expect(page.find(:xpath, './/th[2]')).to have_content 'Name'
        expect(page.find(:xpath, './/th[3]')).to have_content 'City'
      end

      # failed rows
      within('table tbody tr') do
        cell_with_error = page.find(:xpath, './/td[2]')

        expect(page.find(:xpath, './/td[1]')).to have_content '3'
        expect(cell_with_error).to have_content 'NULL'
        expect(page.find(:xpath, './/td[3]')).to have_content 'Los Angeles'

        # trigger error cell hover event
        cell_with_error.hover
        expect(cell_with_error.find('.tooltip-inner')).to have_content "can't be blank"
      end
    end
  end
end
