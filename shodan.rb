require 'shodan'
require 'json'
require 'curb'
require 'colorize'
require 'fileutils'
require 'optparse'
require 'resolv'

# HOME=File.expand_path(File.dirname(__FILE__))
# RESULTS = HOME + '/results/'

class ShodanAPI
  attr_accessor :key
  attr_accessor :api
  attr_accessor :host

  # Initialize API via API Key
  # Enter your API Key for variable @api_key
  def initialize

    @url = 'http://www.shodanhq.com/api/'
    @host = '216.58.194.142'
    @key =  'bnjjf87YSnQGrO4IagIrClllc8LJcWqt'
    # @api = Shodan::Shodan.new(api_key)
  end


  # Display API information
  def info
    url = @url + 'info?key=' + @key
    begin
      c = Curl::Easy.perform(url)
      results = JSON.parse(c.body_str)
      puts "Shodan API Key Confirmed" + "!"
      puts "API Key" + ": #{@key}"
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

  def host
    url = @url + 'host?ip=' + @host + '&key=' + @key
    begin
      c = Curl::Easy.perform(url)
      results = JSON.parse(c.body_str)
      return results['matches']
    rescue => e
      puts "Problem running Host Search" + "!"
      puts "\t=> #{e}"
      return nil
    end
  end

  def count(string)
    url = @url + 'count?q=' + string + '&key=' + @key
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

  # Search Shodan for devices using a search query
  # Returns results hash or nil
  def search(string, filters={})
    prem_filters =  [ 'city', 'country', 'geo', 'net', 'before', 'after', 'org', 'isp', 'title', 'html' ]
    cheap_filters = [ 'hostname', 'os', 'port' ]
    url = @url + 'search?q=' + string
    if not filters.empty?
      filters.each do |k, v|
        if cheap_filters.include?(k)
          url += ' ' + k + ":\"#{v}\""
        end
        if prem_filters.include?(k)
          if @unlocks.to_i > 1
            url += ' ' + k + ":\"#{v}\""
            @unlocks = @unlocks.to_i - 1 # Remove an unlock for use of filter
          else
            puts "Not Enough Unlocks Left to run Premium Filter Search".light_red + "!".white
            puts "Try removing '#{k}' filter and trying again".light_red + "....".white
            return nil
          end
        end
      end
    end
    url += '&key=' + @key
    begin
      c = Curl::Easy.perform(url)
      results = JSON.parse(c.body_str)
      return results
    rescue => e
      puts "Problem running Shodan Search".light_red + "!".white
      puts "\t=> #{e}".white
      return nil
    end
  end
  #
  # def api_call
  #   ip = '216.58.194.142'
  #   host = api.host(ip)
  #   puts host.to_s
  # end
end

ShodanAPI.new.search(string)


