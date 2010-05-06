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
  
  attr_reader :id
  
  def initialize( *args )
    super( *args )
    @id = 0
    @clients = {}
  end
  
  def serve( io )
    new_client( io )
    while msg = io.gets
      nick = @clients.invert[ io ]
      server_log "Msg from #{nick} >> #{msg.chomp}"
      begin
        if msg =~ /^\//
          process_command( nick, msg )
        else
          process_msg( nick, msg )
        end
      rescue Exception => e
        puts e.message
        raise
      end
    end
  end 
  
  # Broadcasting message to all clients
  def process_msg( sender, msg )
    @clients.each do |nick, io|
      if io.closed?
        client_left( nick )
        next
      end
      next if sender == nick
      io.puts( "#{sender} >> #{msg}")
    end
  end
  
  # Handle incomming commands
  def process_command( sender, msg )
    case msg
    when /quit$/
      @clients[ sender ].close
      @clients.delete( sender )    
      server_msg = "User #{sender} has quit the chat."
    when /nick$/
      new_nick = msg.split(' ').last
      unless @clients.has_key?( new_nick )
        @clients[ new_nick ] = @clients.delete( sender )
        server_msg = "User #{sender} is now known as #{new_nick}."
      else
        server_msg = "Nick #{new_nick} is taken."
        for_server = "Requested by #{sender}"
      end
    when /help$/
      help_msg = "Supported commands: /help; /quit; /nick <new_nick>"
      @clients[ sender ].puts( help_msg )
      server_msg = "Help requested."
      for_server = "from #{sender}"
    else
      server_msg = "Unsupported command called."
      for_server = "#{sender} called #{msg}"
    end
    server_log( "#{server_msg} #{for_server}" )
    # TODO: broadcast only selected messages
    process_msg( "ChatServer", server_msg)
  end
  
  # Take care of incoming clients
  def new_client( io )
    new_user = "user#{@id}"
    @clients[ new_user ] = io
    @id += 1
    server_log "New connection from #{io.peeraddr[2]}. Assigned #{new_user}"
    io.puts "Welcome. Assigned nick - #{new_user}.\nEnter: /help for Help."
  end
  
  # Remove a client (at this point connection is closed)
  def client_left( nick )
    @clients.delete( nick )
    server_msg = "#{nick} left the Server."
    server_log( server_msg )
    process_msg( "ChatServer", server_msg )
  end
  
  # TODO: move to module
  def server_log( log_msg )
    puts "[#{Time.now}] ChatServer: #{log_msg}"
  end
  
end

if __FILE__ == $0
  server = ChatServer.new( 36963, 'localhost', 4, $stderr, true, false)
  server.start
  server.join
end