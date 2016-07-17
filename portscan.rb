#!/usr/bin/env ruby

require 'socket'
require 'timeout'

begin
  Timeout.timeout(5) do
    begin
      s = TCPSocket.new('192.81.213.48', 80)
      s.close
      puts "Port is open!"
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      puts "Port is closed!"
    end
  end
rescue Timeout::Error
end