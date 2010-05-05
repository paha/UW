#!/usr/bin/env ruby

###
# Student: Pavel Snagovsky 
# Homework Week: 5
#
###
# Chat server
#

require 'gserver'
# require 'thread'

class ChatServer < GServer
  
  def initialize( *args )
    super( *args )
    @id = 0
    @clients = {}
  end
  
  def serve( client )
    new_user = "user#{@id}"
    @clients[ new_user ] = client
    @id += 1
    puts "-- New connection from #{client.peeraddr[2]}. Assigned #{new_user}"
    client.print( "Welcome. Assigned nick - #{new_user}.\nEnter: /help for Help.\n" )
    while msg = client.gets
      nick = @clients.invert[ client ]
      puts "-- Msg from #{nick} >> #{msg.chomp}"
      begin
        if msg =~ /^\//
          process_command( nick, msg )
        else
          process_input( nick, msg )
        end
      rescue Exception => e
        puts e.message
      end
      # break if client.closed?
    end
  end 
  
  def process_input( sender, msg )
    @clients.each do |nick, session|
      if session.closed?
        @clients.delete( nick )
        next
      end
      next if sender == nick
      session.puts( "#{sender} >> #{msg}")
    end
  end
  
  def process_command( sender, msg )
    case msg
    when /quit$|QUIT$/
      @clients[ sender ].close      
      server_msg = "User #{sender} has quit the chat."
    when /nick|NICK/
      new_nick = msg.split(' ').last
      @clients[ new_nick ] = @clients.delete( sender )
      server_msg = "User #{sender} is now known as #{new_nick}."
    when /help$|HELP/
      help_msg = "Supported commands: /help; /quit; /nick <new_nick>"
      @clients[ sender ].puts( help_msg )
      server_msg = "Help requested."
      for_server = "from #{sender}"
    else
      server_msg = "Unsupported command called."
      for_server = "#{sender} called #{msg}"
    end
    puts "-- #{server_msg} #{for_server}"
    process_input( "ChatServer", server_msg)
  end
  
end

if __FILE__ == $0
  server = ChatServer.new( 36963, 'localhost', 4, $stderr, true, false)
  server.start
  server.join
end