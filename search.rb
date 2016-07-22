require 'optparse'
require 'httparty'
require 'colorize'

HOME=File.expand_path(File.dirname(__FILE__))
RESULTS = HOME + '/results/'

api_key = ' '
base_url = 'https://api.shodan.io/'

  def banner
    if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
      system('cls')
    else
      system('clear')
    end
    puts "  Bigfoot Scanner".colorize(:yellow)
  end

  # Gets and displays api key information
  def info(api_key, base_url)
    api_url = 'api-info?key='
    ip_url = 'tools/myip?key='
    url = base_url + api_url + api_key
    userIP = base_url + ip_url + api_key
    begin
      a = HTTParty.get(userIP)
      puts "User IP Address is #{a.body.delete('" "')}"
      c = HTTParty.get(url)
      results = JSON.parse(c.body)
      puts "Shodan API Key Confirmed" + "!"
      puts "API Key" + ": #{api_key}"
      puts "Plan Type" + ": #{results['plan']}"
      puts "Unlocks Remaining" + ": #{results['unlocked_left']}"
      puts "HTTPS Enabled" + ": #{results['https']}"
      puts "Telnet Enabled" + ": #{results['telnet']}"
      return true
    end
  end

  # Performs a search based on user input
  def search(api_key, base_url)
    query = base_url + 'shodan/host/search?key=' + api_key + '&query='
    puts "=================== \nEnter search input:".colorize(:white)
    input = gets.chomp
    begin
      search = HTTParty.get(query + input)
      puts "Searching results for #{input}"
      results = JSON.parse(search.body)
      results['matches'].each{ |host|
        puts host['org']
        puts host['hostnames']
        puts host['ip_str']
        puts host['port']
        puts host['transport']
        # puts host['data']
        puts "===================== \n"
      }
    end
  end

banner
# info(api_key, base_url)
search(api_key, base_url)

