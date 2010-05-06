###
# Student: Pavel Snagovsky
# Homework Week: 5
#

###
# log parser tests
#

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
  
    @resolver = LogResolver.new( 'input', 'output', 1 )

    @data_lines = DATA.split("\n")
    @test_ips = {}
    @data_lines.each do |line|
      @test_ips[ line.split(' ').first ] = 1
    end

    @test_queue = Queue.new
    @test_ips.each_key { |i| @test_queue << i }
  end

  def test_geting_ips
    @input.expects( :each_line ).multiple_yields( *@data_lines)
    File.expects( :open ).with( 'input' ).returns( @input )

    @resolver.get_ips
    
    expected = @resolver.instance_variable_get( :@resolved ).size
    assert_equal expected, @test_ips.size
  end

  def test_resolve_ips
    # instead of what was done above, we use pre-made data
    @resolver.instance_variable_set( :@queue, @test_queue )
    @resolver.instance_variable_set( :@resolved, @test_ips )

    thread = mock( 'thread' )
    thread.expects( :join )
    Thread.expects( :new ).returns( thread )

    assert @resolver.resolve_ips
  end

  def test_unresolvable_and_error
    unresolvable_ip = '10.10.10.10'
    
    Resolv.expects( :getname ).raises( Resolv::ResolvError )
    
    expected = @resolver.resolve_name( unresolvable_ip )

    assert_equal expected, unresolvable_ip
  end
  
  def test_name_resolution
    expected = 'www.speakeasy.net'
    actual = @resolver.resolve_name( '69.17.117.156' )

    assert_equal expected, actual
  end

  def test_writing_data
    @resolver.instance_variable_set( :@resolved, @test_ips )

    @output.stubs( :puts )
    @input.expects( :each_line ).multiple_yields( *@data_lines)
    File.expects( :open ).with( 'input' ).returns( @input )

    @resolver.write_data    
  end

  def test_resolve!
    # for write_data()
    @output.stubs( :puts )
    File.expects( :open ).with( 'input' ).returns( @input )
  
    # for resolve_ips()
    thread = mock( 'thread' )
    thread.expects( :join )
    Thread.expects( :new ).returns( thread )
    
    # for get_ips()
    @input.stubs( :each_line ).multiple_yields( *@data_lines)
    File.expects( :open ).with( 'input' ).returns( @input )

    @resolver.resolve!
  end
  
end
