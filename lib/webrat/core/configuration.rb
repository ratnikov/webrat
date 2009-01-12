require "webrat/core_extensions/deprecate"

module Webrat

  # Configures Webrat. If this is not done, Webrat will be created
  # with all of the default settings.
  def self.configure(configuration = Webrat::Configuration.new)
    yield configuration if block_given?
    @@configuration = configuration
  end

  def self.configuration # :nodoc:
    @@configuration ||= Webrat::Configuration.new
  end

  # Webrat can be configured using the Webrat.configure method. For example:
  #
  #   Webrat.configure do |config|
  #     config.parse_with_nokogiri = false
  #   end
  class Configuration

    # Should XHTML be parsed with Nokogiri? Defaults to true, except on JRuby. When false, Hpricot and REXML are used
    attr_writer :parse_with_nokogiri

    # Webrat's mode, set automatically when requiring webrat/rails, webrat/merb, etc.
    attr_accessor :mode # :nodoc:

    # Save and open pages with error status codes (500-599) in a browser? Defualts to true.
    attr_writer :open_error_files

    # Which rails environment should the selenium tests be run in? Defaults to selenium.
    attr_accessor :application_environment
    webrat_deprecate :selenium_environment, :application_environment

    # Which port is the application running on for selenium testing? Defaults to 3001.
    attr_accessor :application_port
    webrat_deprecate :selenium_port, :application_port

    # Which server the application is running on for selenium testing? Defaults to localhost
    attr_accessor :application_address

    # Which server Selenium server is running on. Defaults to nil(server starts in webrat process and runs locally)
    attr_accessor :selenium_server_address

    # Which server Selenium port is running on. Defaults to 4444
    attr_accessor :selenium_server_port

    def initialize # :nodoc:
      self.open_error_files = true
      self.parse_with_nokogiri = !Webrat.on_java?
      self.application_environment = :selenium
      self.application_port = 3001
      self.application_address = "localhost"
      self.selenium_server_port = 4444
    end

    def parse_with_nokogiri? #:nodoc:
      @parse_with_nokogiri ? true : false
    end

    def open_error_files? #:nodoc:
      @open_error_files ? true : false
    end

    # Allows setting of webrat's mode, valid modes are:
    # :rails, :selenium, :rack, :sinatra, :mechanize, :merb
    def mode=(mode)
      @mode = mode
      require("webrat/#{mode}")
    end

  end

end