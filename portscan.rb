#!/usr/bin/env ruby

require 'socket'
require 'timeout'

begin
    Timeout.timeout(5) do
      begin
        s = TCPSocket.new('60.226.85.156', 8080)
        s.close
        puts "Port is open!"
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        puts "Port is closed!"
      end
    end
  rescue Timeout::Error
end