require 'optparse'
require 'httparty'
require 'colorize'
require 'socket'
require 'timeout'
require 'nokogiri'

HOME=File.expand_path(File.dirname(__FILE__))
RESULTS = HOME + '/results/'

api_key = ''
base_url = 'https://api.shodan.io/'
exploit_url = 'https://exploits.shodan.io/api/search?query='

def banner
  if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
    system('cls')
  else
    system('clear')
  end
  puts "\n=================== \n    Shogun Scanner\n=================== \n".colorize(:yellow)
end

class Shodan

  def info(api_key, base_url)
    api_url = 'api-info?'
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

  def exploit(api_key, exploit_url)
    puts "=================== \nEnter search input:".colorize(:white)
    input = gets.chomp
    query = exploit_url + input + '&' + api_key
    begin
      search = HTTParty.get(query)
      puts "Retrieving results for #{input} ..."
      results = JSON.parse(search.body)
      results['matches'].each { |exploit|
        source = "Source".colorize(:yellow) + ": #{exploit['source']}"
        id = "ID".colorize(:yellow) + ": #{exploit['_id']}"
        description = "Description".colorize(:yellow) + ": #{exploit['description']}"
        type = "Type".colorize(:yellow) + ": #{exploit['type']}"
        rank = "Rank".colorize(:yellow) + ": #{exploit['rank']}"
        code = "Code".colorize(:yellow) + ": #{exploit['code']}"
        cve = "CVE".colorize(:yellow) + ": #{exploit['cve']}"
        author = "Author".colorize(:yellow) + ": #{exploit['author']}"

        puts source
        puts type
        puts cve
        puts rank
        puts author
        puts id
        puts description
        puts code
        puts "===================== \n".colorize(:yellow)
      }
    end
  end

  def scan(base_url, api_key)
    puts "=================== \nEnter IP address:".colorize(:white)
    input = gets.chomp
    query = base_url + 'shodan/host/' + input + '?' + api_key
    begin
      scan = HTTParty.get(query)
      puts "Scanning #{input} ..."
      results = JSON.parse(scan.body)
      results['data'].each { |host|
        title = "Title".colorize(:yellow) + ": #{host['title']}" unless host['title'].nil?
        version = "Version".colorize(:yellow) + ": #{host['version']}" unless host['version'].nil?
        transport = "Protocol".colorize(:yellow) + ": #{host['transport']}" unless host['transport'].nil?
        port = "Port".colorize(:yellow) + ": #{host['port']}" unless host['port'].nil?
        product = "Product".colorize(:yellow) + ": #{host['product']}" unless host['product'].nil?
        city = "City".colorize(:yellow) + ": #{host['location']['city']}" unless host['location']['city'].nil?

        puts title unless title.nil?
        puts version unless version.nil?
        puts city unless city.nil?
        puts transport unless transport.nil?
        puts port unless port.nil?
        puts product unless product.nil?
        puts "===================== \n".colorize(:yellow)
      }
    end
  end
end

banner
# Shodan.new.info(api_key, base_url)
# Shodan.new.search(api_key, base_url)
# Shodan.new.exploit(api_key, exploit_url)
Shodan.new.scan(base_url, api_key)
