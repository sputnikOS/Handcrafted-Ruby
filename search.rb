require 'optparse'
require 'httparty'
require 'colorize'
require 'socket'
require 'timeout'

HOME=File.expand_path(File.dirname(__FILE__))
RESULTS = HOME + '/results/'

# enter api key below
api_key = '' 
base_url = 'https://api.shodan.io/'

class Shodan
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
    search = 'shodan/host/search?'
    search_query = '&query='
    query = base_url + search + api_key + search_query
    puts "=================== \nEnter search input:".colorize(:white)
    input = gets.chomp
    begin
      search = HTTParty.get(query + input)
      puts "Searching results for #{input}"
      results = JSON.parse(search.body)
      results['matches'].each{ |host|
        org = host['org']
        hostname = "Host" + ": #{host['hostnames']}"
        ip = "IP" + ": #{host['ip_str']}"
        port = "Port" + ": #{host['port']}"
        protocol = "Protocol" + ": #{host['transport']}"
        data = "Data" + ": #{host['data']}"
        begin
          Timeout.timeout(5) do
            begin
              s = TCPSocket.new(host['ip_str'], host['port'])
              s.close
              puts "Port is open!"
            rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
              puts "Port is closed!"
            end
          end
        rescue Timeout::Error
        end
        puts org
        puts hostname
        puts ip
        puts port
        puts protocol
        puts data
        puts "===================== \n"
      }
    end
  end
end

Shodan.new.banner
# info(api_key, base_url)
Shodan.new.search(api_key, base_url)

