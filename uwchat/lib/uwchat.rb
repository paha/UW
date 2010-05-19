module Uwchat
  
  STUDENT = "Pavel Snagovsky"
  VERSION = '0.2.0'
  
end

require 'uwchat/uwchat_common'
require 'uwchat/server'
require 'uwchat/server_auth'
require 'uwchat/server_cmd'
require 'uwchat/client'
require 'uwchat/client_auth'

# Commands:
Dir[ File.dirname(__FILE__) + '/uwchat/commands/*.rb' ].each {|cmd| require cmd }