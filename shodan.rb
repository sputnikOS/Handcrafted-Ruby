require 'shodan'
require 'json'
require 'curb'

HOME=File.expand_path(File.dirname(__FILE__))
RESULTS = HOME + '/results/'


class ShodanAPI
  attr_accessor :api_key
  attr_accessor :api

  # Initialize API via API Key
  # Enter your API Key for variable @api_key
  def initialize
    @api_key = ''
    @api = Shodan::Shodan.new(api_key)
    @url = "http://www.shodanhq.com/api/"
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

  def host(ip)
    url = @url + 'host?ip=' + ip + '&key=' + @api_key
    begin
      c = Curl::Easy.perform(url)
      results = JSON.parse(c.body_str)
      return results
    rescue => e
      puts "Problem running Host Search" + "!"
      puts "\t=> #{e}"
      return nil
    end
  end

  def count(string)
    url = @url + 'count?q=' + string + '&key=' + @api_key
    begin
      c = Curl::Easy.perform(url)
      results = JSON.parse(c.body_str)
      return results['total']
    rescue => e
      puts "Problem grabbing results count" + "!"
      puts "\t=> #{e}"
      return nil
    end
  end

  def api_call
    ip = '192.81.213.48'
    host = api.host(ip)
    puts host.to_s
  end
end

ShodanAPI.new.info
ShodanAPI.new.api_call


