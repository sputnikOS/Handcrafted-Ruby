require 'shodan'
require 'curb'


api_key = ''

# Gets and displays api key information
def info(api_key)
  url = "https://api.shodan.io/api-info?key=#{api_key}"
  begin
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
  puts "Enter search input"
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

info(api_key)
search(api_key)

