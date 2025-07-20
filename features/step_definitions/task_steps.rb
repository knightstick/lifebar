When('I click {string}') do |button_text|
  click_link_or_button button_text
end

When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

When('I select {string} from {string}') do |option, field|
  select option, from: field
end

Then('I should see {string} in my task list') do |task_name|
  expect(page).to have_content(task_name)
end
