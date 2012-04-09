# WIP
module DCPU16
  class Assembler
    attr_reader :input
    def initialize(text)
      @input = text
    end

    def dump
      raise "TODO #{caller.first}"
      lines = []
      @input.each_line do |line|
        empty   = (line =~ /^\s*$/)
        comment = (line =~ /^\s*;+.*$/)

        next if empty || comment

        line.gsub!(/^\s*([^;]*).*$/) { $1 } # Strip some spaces

        regex = /^(:\w*)?\s*(\w*)\s*([^,\s]*),?\s?([^\s]*).*$/
        match = line.match(regex)

        line = { :label => match[1],
                 :op    => match[2],
                 :a => match[3],
                 :b => match[4] }
        puts line
        lines << line
      end
    end
  end
end

