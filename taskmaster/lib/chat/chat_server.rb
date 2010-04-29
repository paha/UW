#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky 
# Homework Week: 5
#
###
# Description:
# Chat server
# 

require 'gserver'
require 'socket'

class ChatServer < GServer
  # attr_reader :maxConnections
  
  def initialize( port = 36963, maxConnections = 10, *args )
    # new(port, host = DEFAULT_HOST, maxConnections = 4, stdlog = $stderr, audit = false, debug = false)
    super( port, "", maxConnections, *args)
    # @maxConnections = maxConnections
    # or mac connections could be taken ike Gserver.macConnections it is an attribute of Gserver
    @clients = []
    @avaliable_ids = (1..maxConnections).to_a
  end
  
  def serve( io )
    client = "user" + @avaliable_ids.shift
    io.puts "Welcome to chat server, your username is #{client}"
    @clients << client
    sleep 2
    puts io.connections
    sleep 2
    io.close
    
    # while true
      
    # end    
  end
  
  def process_input( input )
    # case 
  end
  
  def pinf_clients
  end
  
  def send_msg
  end
  
end

if __FILE__ == $0
  ChatServer.new
end