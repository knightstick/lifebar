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
  create(:task, name: task_name, interval_type: interval)
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
  case time_ago
  when /(\d+) days? ago/
    days = $1.to_i
    create(:task, :completed, name: task_name, interval_type: interval, completed_at: days.days.ago)
  when /(\d+) hours? ago/
    hours = $1.to_i
    create(:task, :completed, name: task_name, interval_type: interval, completed_at: hours.hours.ago)
  end
end

Given('I have a task {string} with {string} interval that was never completed') do |task_name, interval|
  create(:task, name: task_name, interval_type: interval, last_completed_at: nil)
end

Then('I should see {string} with status {string}') do |task_name, status|
  within("[data-task-name='#{task_name}']") do
    expect(page).to have_content(status)
  end
end

Then('I should see green status color for {string}') do |task_name|
  within("[data-task-name='#{task_name}']") do
    expect(page).to have_css('.status-green')
  end
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
Given('I have a task {string} that was completed {int} days ago') do |task_name, days_ago|
  create(:task, :weekly, :completed, name: task_name, completed_at: days_ago.days.ago)
end

When('I visit the tasks page') do
  visit tasks_path
end

When('I click {string} next to {string}') do |button_text, task_name|
  within("[data-task-name='#{task_name}']") do
    click_link_or_button button_text
  end
end

Then('I should be redirected to the tasks page') do
  expect(current_path).to eq(tasks_path)
end

Then('I should see {string} with a green status') do |task_name|
  within("[data-task-name='#{task_name}']") do
    expect(page).to have_css('.status-green')
  end
end

Then('the task should have an updated completion timestamp') do
  # This step verifies that the task's last_completed_at was updated
  # We'll check this by ensuring the task shows as recently completed
  task = Task.find_by(name: "Water plants")
  expect(task.last_completed_at).to be_within(1.minute).of(Time.current)

  # Also verify that a TaskCompletion record was created
  expect(task.task_completions.count).to be > 0
  latest_completion = task.task_completions.order(:completed_at).last
  expect(latest_completion.completed_at).to be_within(1.minute).of(Time.current)
end

Given('I have a daily task called {string}') do |task_name|
  create(:task, name: task_name, interval_type: 'daily')
end

Given('the task {string} was completed {int} hours ago') do |task_name, hours_ago|
  task = Task.find_by(name: task_name)
  task.mark_completed!(hours_ago.hours.ago)
end

Given('the task {string} was completed {int} days ago') do |task_name, days_ago|
  task = Task.find_by(name: task_name)
  task.mark_completed!(days_ago.days.ago)
end

Then('I should see a status bar for {string}') do |task_name|
  within("[data-task-name='#{task_name}']") do
    expect(page).to have_css('.status-bar')
    expect(page).to have_css('.status-bar-fill')
  end
end

Then('the status bar should be green') do
  expect(page).to have_css('.status-bar-fill.bg-green-500, .status-bar-fill.bg-green-400')
end

Then('the status bar should be yellow') do
  expect(page).to have_css('.status-bar-fill.bg-yellow-400')
end

Then('the status bar should be red') do
  expect(page).to have_css('.status-bar-fill.bg-red-500')
end

Then('the status bar should be less than 25% filled') do
  fill_element = page.find('.status-bar-fill')
  width_style = fill_element[:style]
  match = width_style.match(/width:\s*([\d\.e\-\+]+)%/)
  expect(match).not_to be_nil, "Could not find width percentage in style: #{width_style}"
  width_value = match[1].to_f
  expect(width_value).to be < 25
end

Then('the status bar should be approximately 50% filled') do
  fill_element = page.find('.status-bar-fill')
  width_style = fill_element[:style]
  match = width_style.match(/width:\s*([\d\.e\-\+]+)%/)
  expect(match).not_to be_nil, "Could not find width percentage in style: #{width_style}"
  width_value = match[1].to_f
  expect(width_value).to be_between(45, 55)
end

Then('the status bar should be 100% filled') do
  fill_element = page.find('.status-bar-fill')
  width_style = fill_element[:style]
  match = width_style.match(/width:\s*([\d\.e\-\+]+)%/)
  expect(match).not_to be_nil, "Could not find width percentage in style: #{width_style}"
  width_value = match[1].to_f
  expect(width_value).to eq(100)
end
