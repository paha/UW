#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky 
# Homework Week: 3
#
###
# Description:
#
# Creating DSL
# Authentication server class
# 

require 'yaml'
require 'socket'
require 'digest/md5'

port = 24842
# AuthServer.new( port )

# Authnetication server class
class AuthServer
  class << self
    
    attr_accessor :username, :salt, :passwd_salty
    
    # def initialize( port )
    #   @data = YAML::load( File.read( File.dirname(__FILE__) + '/passwd' ))
    #   auth_server = TCPServer.new(port)
    #   loop do
    #     puts "\nReady to accept new connections. Listening on port: #{port}. #{Time.now}"
    #     session = auth_server.accept
    #     puts "--- #{session.peeraddr[2]} connected. #{Time.now}"
    #     user = get_username( session )
    #     next if user == false
    #     puts "--- Received \"#{username}\" for username. #{Time.now}"
    #     send_salt( session )
    #     puts "--- Sent salt to the client. #{Time.now}"
    #     get_salty_passwd( session )
    #     puts "--- Recieved salty password from the client. #{Time.now}"
    #     check_passwd( session )
    #   end
    # end
    
    def get_username( session )
      # temp *****
      @data = YAML::load( File.read( File.dirname(__FILE__) + '/passwd' ))
      # *****
      @username = session.gets.chomp
      unless @data[@username]
        puts "NOT AUTHORIZED. Unknown username \"#{@username}\". Closing session with #{session.peeraddr[2]} #{Time.now}"
        session.puts "NOT AUTHORIZED"
        session.close
        return false
      end
      return @username
    end
    
    def send_salt( session )
      @salt = Digest::MD5.hexdigest( @username + Time.now.strftime('%M%S') + rand(300).to_s )
      session.puts @salt
    end
    
    def get_salty_passwd ( session )
      @passwd_salty = session.gets.chomp
      if @passwd_salty.length != 32
        session.puts "NOT AUTHORIZED"
        session.close
        puts "NOT AUTHORIZED. Unexpected salty passwd hash for #{@username}. #{Time.now}"
        return false
      end
    end
    
    def check_passwd( session )
      if @passwd_salty == Digest::MD5.hexdigest( @salt + @data[@username] )
        session.puts "AUTHORIZED"
        puts "AUTHORIZED \"#{@username}\". Closing session. #{Time.now}"
        result = true
      else
        session.puts "NOT AUTHORIZED"
        puts "NOT AUTHORIZED \"#{@username}\". password mismatch. Closing session. #{Time.now}"
        result = false
      end
      session.close
      return result
    end
  
  end
end

