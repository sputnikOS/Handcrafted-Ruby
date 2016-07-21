require 'optparse'
require 'httparty'


api_key = 'bnjjf87YSnQGrO4IagIrClllc8LJcWqt'
base_url = 'https://api.shodan.io/'

# Gets and displays api key information
def info(api_key, base_url)
  api_url = 'api-info?key='
  ip_url = 'tools/myip?key='
  url = base_url + api_url + api_key
  userIP = base_url + ip_url + api_key
  begin
    a = HTTParty.get(userIP)
    puts "User IP Address is #{a.body}"
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
  begin
    puts "==================="
    puts "Enter search input:"
    input = gets.chomp
    query = base_url + 'shodan/host/search?key=' + api_key + '&query=' + input
    search = HTTParty.get(query)
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

info(api_key, base_url)
search(api_key, base_url)

