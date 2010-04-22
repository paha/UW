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

require 'digest/md5'

# Authnetication server class
class AuthServer
  class << self
    
    attr_accessor :username, :salt, :passwd_salty
    
    def get_username( session, data )
      @username = session.gets.chomp
      unless data[@username]
        puts "NOT AUTHORIZED. Unknown username \"#{@username}\". Closing session with #{session.peeraddr[2]} #{Time.now}"
        session.puts "NOT AUTHORIZED"
        session.close
        return 'failed'
      end
      return @username
    end
    
    def make_salt( session )
      @salt = Digest::MD5.hexdigest( @username + Time.now.strftime('%M%S') + rand(300).to_s )
      session.puts @salt
    end
    
    def get_salty_passwd ( session )
      @passwd_salty = session.gets.chomp
      if @passwd_salty.length != 32
        session.puts "NOT AUTHORIZED"
        puts "NOT AUTHORIZED. Unexpected salty passwd hash for #{@username}. #{Time.now}"
        session.close
      end
    end
    
    def check_passwd( session, data )
      if @passwd_salty == Digest::MD5.hexdigest( @salt + data[@username] )
        session.puts "AUTHORIZED"
        puts "AUTHORIZED \"#{@username}\". Closing session. #{Time.now}"
      else
        session.puts "NOT AUTHORIZED"
        puts "NOT AUTHORIZED \"#{@username}\". password mismatch. Closing session. #{Time.now}"
      end
      session.close
    end
  
  end
end
