#!/usr/bin/env ruby

begin
  require 'dcpu16'
rescue LoadError
  $LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))
  require 'dcpu16'
end

if ARGV.length == 1
  filename = ARGV[0]
  if filename.end_with?(".o")
    dump = File.open(filename, "rb").read.unpack("S>*")
  else
    require 'tempfile'
    file = File.open(filename)
    assembler = DCPU16::Assembler.new(file.read)
    tmp_file = Tempfile.new("obj")
    assembler.write(tmp_file.path)
    dump = tmp_file.read.unpack("S>*")
  end
  debugger = DCPU16::Debugger.new(dump)
  debugger.run
elsif ARGV.length == 2
  file = File.open(ARGV[0])
  assembler = DCPU16::Assembler.new(file.read)
  assembler.write(ARGV[1])
else
  puts "Usage: dcpu16 <input> <output>"
  exit
end

