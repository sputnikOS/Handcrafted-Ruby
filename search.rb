require 'shodan'
require 'curb'


api_key = ''
base_url = 'https://api.shodan.io/'

# Gets and displays api key information
def info(api_key, base_url)
  api_info = 'api-info?key='
  ip_info = 'tools/myip?key='
  url = base_url + api_info + api_key
  userIP = base_url + ip_info + api_key
  begin
    a = Curl::Easy.perform(userIP)
    puts "User IP Address is #{a.body_str}"
    c = Curl::Easy.perform(url)
    results = JSON.parse(c.body_str)
    puts "Shodan API Key Confirmed" + "!"
    puts "API Key" + ": #{api_key}"
    puts "Plan Type" + ": #{results['plan']}"
    puts "Unlocks Remaining" + ": #{results['unlocked_left']}"
    puts "HTTPS Enabled" + ": #{results['https']}"
    puts "Telnet Enabled" + ": #{results['telnet']}"
    return true
  end
end

def search(api_key)
  puts "=================="
  puts "Enter search input:"
  input = gets.chomp
  api = Shodan::Shodan.new(api_key)
  puts "Searching results for #{input}"
  result = api.search(input)
  result['matches'].each{ |host|
    puts host['org']
    puts host['hostnames']
    puts host['ip_str']
    puts host['port']
    puts host['transport']
    # puts host['data']
    puts "===================== \n"
  }
end

info(api_key, base_url)
search(api_key)

