require 'rubygems'
require 'selenium-webdriver'
require 'sauce_whisk'
require 'test-unit'


class BlogTests < Test::Unit::TestCase
    def setup
        caps = Selenium::WebDriver::Remote::Capabilities.new
        caps["browserName"] = "#{ENV['browserName']}"
        caps["version"] = "#{ENV['version']}"
        caps["platform"] = "#{ENV['platform']}"
        caps["name"] = @method_name

        url = "http://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com:80/wd/hub".strip
        @driver = Selenium::WebDriver.for(:remote, :url => url, :desired_capabilities => caps)
    end

    def test_post
        # navigate to the saucelabs page 
        @driver.get "https://saucelabs.com" 

        title = @driver.title()
        assert_equal(title, "Sauce Labs: Selenium Testing, Mobile Testing, JS Unit Testing and More")
    end

    def teardown
        sessionid = @driver.session_id
        @driver.quit

        if @_result.passed?
          SauceWhisk::Jobs.pass_job sessionid
        else
          SauceWhisk::Jobs.fail_job sessionid
        end
    end
end