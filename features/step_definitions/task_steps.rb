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
  within("[data-task-name='#{task_name}']") do
    expect(page).to have_content(interval)
  end
end

Given('the current time is {string}') do |time_string|
  travel_to Time.parse(time_string)
end

Given('I have a task {string} with {string} interval completed {string}') do |task_name, interval, time_ago|
  task = Task.create!(name: task_name, interval_type: interval)
  case time_ago
  when /(\d+) days? ago/
    days = $1.to_i
    task.update!(last_completed_at: days.days.ago)
  when /(\d+) hours? ago/
    hours = $1.to_i
    task.update!(last_completed_at: hours.hours.ago)
  end
end

Given('I have a task {string} with {string} interval that was never completed') do |task_name, interval|
  Task.create!(name: task_name, interval_type: interval, last_completed_at: nil)
end

Then('I should see {string} with status {string}') do |task_name, status|
  puts "DEBUG: Looking for task '#{task_name}' with status '#{status}'"
  puts "DEBUG: Page has content: #{page.has_content?(task_name)}"
  puts "DEBUG: Page has data-task-name: #{page.has_css?("[data-task-name='#{task_name}']")}"
  within("[data-task-name='#{task_name}']") do
    expect(page).to have_content(status)
  end
end

Then('I should see green status color for {string}') do |task_name|
  task_element = page.find("[data-task-name='#{task_name}']")
  puts "DEBUG: Raw HTML for #{task_name}:"
  puts task_element['innerHTML']
  puts "DEBUG: Looking for .status-green class within task element"
  expect(task_element).to have_css('.status-green')
end

Then('I should see yellow status color for {string}') do |task_name|
  within("[data-task-name='#{task_name}']") do
    expect(page).to have_css('.status-yellow')
  end
end

Then('I should see red status color for {string}') do |task_name|
  within("[data-task-name='#{task_name}']") do
    expect(page).to have_css('.status-red')
  end
end
