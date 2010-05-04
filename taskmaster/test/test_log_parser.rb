require 'test/unit'
require 'rubygems'
require 'mocha'

require 'logParser/log_parser'

class TestLogParser < Test::Unit::TestCase
  DATA = File.read( 'test/test_data' )

  def setup
    @input = mock('infile')
    @output = mock('outfile')
  
    File.expects( :open ).with( 'output', 'w' ).returns( @output )
  
    @resolver = LogResolver.new( 'input', 'output' )
  end
  
  def test_resolve!
    data_lines = DATA.split("\n")
    
    @input.expects( :each_line ).multiple_yields( *data_lines )
    File.expects( :open ).returns( @input )
  
    data_lines.each do |line|
      components = line.split(' ')
      ip = components.shift
  
      hostname = "sdkfjh#{ip}"
      Resolv.expects( :getname ).with( ip ).returns( hostname )
      components.unshift hostname
  
      @output.expects( :puts ).with( components.join(" ") )
    end
  
    @resolver.resolve!
  end
  
  def test_name_resolution
    expected = 'www.speakeasy.net'
    actual = @resolver.resolve_name( '69.17.117.156' )
    assert_equal expected, actual
  end
  # 
  # def test_resolv_error
  #   data_line = DATA.split("\n").first
  #   @input.expects( :each_line ).yields( data_line )
  #   Resolv.stubs( :getname ).raises( Resolv::ResolvError )
  #   @output.expects( :puts ).with( data_line )
  # 
  #   @resolver.resolve!
  # end

end