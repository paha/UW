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
      raise "Failed to connect to #{host}:#{port}"
    end
    puts "Connected to ChatServer on #{host}. To exit the client: \'exit\'"
  end
  
  def chat
    incoming = Thread.new do
      while msg = @session.gets
        puts msg
      end
    end
     
    outgoing = Thread.new do
      while msg = $stdin.gets.chomp
        exit 0 if msg =~ /disconnect|exit|^quit/
        begin
          @session.puts( msg )
        rescue
          raise "Failed to communicate to the Chat server. Exiting."
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
