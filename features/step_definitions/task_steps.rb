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

Given('I have created a task {string} with {string} interval') do |task_name, interval|
  Task.create!(name: task_name, interval_type: interval)
end

Given('I visit the tasks dashboard') do
  visit tasks_path
end

Then('I should see the creation date for each task') do
  Task.all.each do |task|
    expect(page).to have_content(task.created_at.strftime("%B %d, %Y"))
  end
end

Then('I should see {string} link') do |link_text|
  expect(page).to have_link(link_text)
end

Then('I should be on the tasks dashboard') do
  expect(current_path).to eq(tasks_path)
end

Then('I should be on the new task page') do
  expect(current_path).to eq(new_task_path)
end

Then('I should see my task list') do
  expect(page).to have_content("My Tasks")
end

Then('I should see {string} as the interval for {string}') do |interval, task_name|
  within(:xpath, "//div[contains(@class, 'bg-white') and contains(., '#{task_name}')]") do
    expect(page).to have_content(interval)
  end
end
