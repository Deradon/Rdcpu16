require 'dcpu16/assembler/constants'
require 'dcpu16/assembler/instruction'
require 'dcpu16/assembler/line'


module DCPU16
  class Assembler
    attr_reader :input

    def initialize(text)
      @input = text
      assemble
    end

    # Assemble the given input.
    def assemble
      location = 0
      @labels  = {}
      @body    = []

      lines.each do |line|
        # Set label location
        @labels[line.label] = location if line.label

        # Skip when no op
        next if line.op.empty?

        op = Instruction.create(line.op, line.args, location)
        @body << op
        location += op.size
      end

      # Apply labels
      begin
        @body.each { |op| op.apply_labels(@labels) }
      rescue Exception => e
        puts @labels.inspect
        raise e
      end
    end

    # Returns assembled bytes
    def bytes
      @body.map { |op| op.bytes }.join
    end

    def to_s
      @body.join("\n")
    end

    def lines
      @lines ||= read_lines
    end

    # Write bytes to file
    def write(filename)
      File.open(filename, "w") { |file| file.write(bytes) }
    end



    private

    def read_lines
      @lines = []
      @input.each_line do |line|
        empty   = (line =~ RE_LINE_EMPTY)
        comment = (line =~ RE_LINE_COMMENT)

        next if empty || comment

        line.gsub!(RE_LINE_CLEAN) { $1 }

        match = line.match(RE_LINE)
        label = match[1]
        op    = match[2]
        args  = match[3]
        args  = args.scan( RE_ARGS ).flatten.compact

        line = Line.new(label, op, args)
        @lines << line
      end

      return @lines
    end
  end
end

