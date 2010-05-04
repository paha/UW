#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'log_parser'
require 'benchmark'
include Benchmark

INFILE  = 'httpd-access.log'
OUTFILE = 'resolv.log'
TIMES   = 30

steps = [1, 2, 3, 5, 10, 15, 20, 25, 50, 75, 100, 150, 200]

steps.each do |threads|
  Benchmark.benchmark(" "*8 + CAPTION, 7, FMTSTR, "       >avg:") do|b|
    run = b.report("%3i threads:" % threads) do
      TIMES.times { LogResolver.new( INFILE, OUTFILE, threads).resolve! }
    end
    [ run/TIMES ]
  end
  puts "\n"
end
