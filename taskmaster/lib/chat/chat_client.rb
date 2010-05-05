#!/usr/bin/env ruby

###
# Student: Pavel Snagovsky 
# Homework Week: 5
#
###
# Chat client
# 

require 'socket'

class ChatClient

  def initialize( host, port )
    begin
      @session = TCPSocket.new( host, port )
    rescue
      puts "Failed to connect to #{host}:#{port}"
      exit 1
    end
    puts "Connecting to #{host}. To exit the client: \'exit\'"
    chat
  end
  
  def chat
    incoming = Thread.new do
      while msg = @session.gets
        puts msg
      end
    end
     
    outgoing = Thread.new do
      while msg = gets.chomp
        exit 0 if msg =~ /disconnect|exit|^quit/
        begin
          @session.puts( msg )
        rescue
          puts "Failed to communicate to the Chat server. Exiting."
          exit 1
        end
      end
    end
    
    incoming.join
    outgoing.join
  end

end

if __FILE__ == $0
  ARGV[0] ||= 'localhost'
  ARGV[1] ||= 36963
  ChatClient.new( ARGV[0], ARGV[1] ).chat
end