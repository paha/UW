#!/usr/bin/env ruby

###
# Student: Pavel Snagovsky
#

###
# week5, in class exercise 
#

require 'thread'
require 'resolv'

class LogResolver
  
  def initialize( infile, outfile, max_threads = 10 )
    @outfile = File.open( outfile, 'w' )
    @max_threads = max_threads.to_i
    @resolved = {}
    @infile = infile
    @queue = Queue.new
  end
  
  def resolve!
    get_ips
    resolve_ips
    write_data
  end
  
  def get_ips
    File.open( @infile ).each_line do |line|
      ip = line.split(' ').first
      @resolved[ ip ] = 1
    end
    @resolved.each_key { |i| @queue << i } # collect uniq IPs
  end
  
  def resolve_ips
    threads = []
    @max_threads.times do
      threads << Thread.new do
        while ip = @queue.pop
          # puts "Resolving #{ip}, threads running: #{Thread.list.size}"
          
          # call resolve_name unless it was resolved
          resolve_name( ip ) if @resolved[ ip ] == 1
        end
      end     
    end
    threads.each { |t| t.join } 
  end
  
  def resolve_name( ip )  
    begin
     host = Resolv.getname( ip )
    rescue Resolv::ResolvError
     host = ip
    end
    @resolved[ ip ] = host       
  end
  
  def write_data
    File.open( @infile ).each_line do |line|
      pieces = line.split(' ')
      ip = pieces.shift
      pieces.unshift @resolved[ ip ]
      @outfile.puts pieces.join(' ')
    end
  end

end

if __FILE__ == $0
  unless ARGV[0] and ARGV[1]
    $stderr.puts "Usage: #{$0} <input> <output> [<num threads>]"
    exit 1
  end
  
  ARGV[2] ||= 10

  LogResolver.new( ARGV[0], ARGV[1], ARGV[2] ).resolve!
end
