require 'shodan'


api_key = ' '


api = Shodan::Shodan.new(api_key)

result = api.search("netgear")
result['matches'].each{ |host|
  puts host['org']
  puts host['hostnames']
  puts host['ip_str']
  puts host['port']
  puts host['transport']
  puts host['data']
  puts "===================== \n"
}