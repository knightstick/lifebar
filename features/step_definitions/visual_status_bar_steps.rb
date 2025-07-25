require 'chronic'

Given('I have created the following tasks:') do |table|
  table.hashes.each do |row|
    last_completed_at = row['last_completed_at'].present? ? Chronic.parse(row['last_completed_at']) : nil
    interval_parts = row['interval'].split
    interval_value = interval_parts.first.to_i
    interval_type = interval_parts.last.sub(/s$/, '') # remove pluralization

    task_attributes = { name: row['name'], last_completed_at: last_completed_at }

    if interval_type == 'day'
      task_attributes[:interval_type] = 'daily'
    elsif interval_type == 'week'
      task_attributes[:interval_type] = 'weekly'
    elsif interval_type == 'month'
      task_attributes[:interval_type] = 'monthly'
      task_attributes[:interval_value] = interval_value
    else
      # Handle custom intervals or other cases if necessary
    end

    Task.create!(task_attributes)
  end
end

When('I visit the dashboard') do
  visit tasks_path
end

Then('I should see a visual status bar for each task') do
  expect(page).to have_css('.status-bar', count: Task.count)
end

Then('the {string} status bar should reflect a partial completion percentage') do |task_name|
  task = Task.find_by!(name: task_name)
  percentage = task.completion_percentage
  expect(percentage).to be > 0
  expect(percentage).to be < 80 # Give it some leeway
end

Then('the {string} status bar should reflect an overdue state') do |task_name|
  task = Task.find_by!(name: task_name)
  expect(task.completion_percentage).to eq(0)
end

Then('the {string} status bar should reflect a recently completed state') do |task_name|
  task = Task.find_by!(name: task_name)
  expect(task.completion_percentage).to be > 95
end
