require 'capybara/rails'
require 'capybara/cucumber'
require 'selenium-webdriver'

# Configure different drivers for different environments
if ENV['CI']
  # In CI, use selenium with firefox (more reliable in containers)
  Capybara.javascript_driver = :selenium_headless
else
  # Locally, use Chrome headless for better debugging
  Capybara.register_driver :headless_chrome do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--disable-gpu')
    options.add_argument('--disable-web-security')
    options.add_argument('--window-size=1400,1400')

    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end

  Capybara.javascript_driver = :headless_chrome
end

# Increase wait time for JavaScript tests
Capybara.default_max_wait_time = 10

# Configure server settings for JavaScript tests
Capybara.server_host = '127.0.0.1'
Capybara.server_port = 9887 + ENV['TEST_ENV_NUMBER'].to_i
