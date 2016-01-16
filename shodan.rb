require 'shodan'
require 'json'
require 'curb'

HOME=File.expand_path(File.dirname(__FILE__))
RESULTS = HOME + '/results/'


class ShodanAPI
  attr_accessor :api_key
  attr_accessor :api

  # Initialize API via API Key
  def initialize
    @api_key = 'bnjjf87YSnQGrO4IagIrClllc8LJcWqt'
    @api = Shodan::Shodan.new(api_key)
    @url = "http://www.shodanhq.com/api/"
  end

  def connect
    url = @url + 'info?key='
    begin
      c = Curl::Easy.perform(url)
    end
  end

  # Display API information
  def info
    url = @url + 'info?key=' + @api_key
    begin
      c = Curl::Easy.perform(url)
      results = JSON.parse(c.body_str)
      puts "Shodan API Key Confirmed" + "!"
      puts "API Key" + ": #{@api_key}"
      puts "Plan Type" + ": #{results['plan']}"
      puts "Unlocks Remaining" + ": #{results['unlocked_left']}"
      puts "HTTPS Enabled" + ": #{results['https']}"
      puts "Telnet Enabled" + ": #{results['telnet']}"
      return true
    rescue => e
      puts "Problem with Connection to Shodan API" + "!"
      puts "\t=> #{e}"
      return false
    end
  end

  def api_call
    ip = '104.236.19.250'
    host = api.host(ip)
    puts host.to_s
  end
end

ShodanAPI.new.info
# ShodanAPI.new.api_call

