require "test/unit"
require "rubygems"
require "mocha"

require "uwchat"

class TestUwchatServerCommand < Test::Unit::TestCase

  def test_ancestory
    puts "ServerCommand ansestors --> #{Uwchat::ServerCommand.ancestors}"
  end
  
  
end
