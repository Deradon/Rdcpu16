require 'observer'

# Text VRAM starts at 0x8000 and is word-based (16bits per address cell)
# like other memory and is in the same address space as the rest of the processor uses.

# The low 8 bits determine the character shown.

# The high 8 bits determine the color;
# the highest 4 are the foreground and the lowest 4 are the background.

# The color nibbles use (from LSB to MSB) blue, green, red, highlight.
# (Normal 16color from PCs, though probably with darkyellow instead of brown)

# The screen appears to be 32 characters by 12 lines, with a character cell of 4x8 pixels,
# suggesting possible graphics modes of 128x96 pixels at that resolution.

# require 'dcpu16'; cpu = DCPU16::CPU.new; screen = DCPU16::Screen.new(cpu.memory); cpu.memory.write(0x8000, 0x30)


# TODO: OUTPUT
# require 'dcpu16'; debugger = DCPU16::Debugger.new
module DCPU16
  class Screen
    include Observable

    X_OFFSET = 2
    Y_OFFSET = 2

    attr_reader :width, :height, :memory_offset, :chars

    def initialize(memory, options = {})
      @memory = memory
      @width  = options[:width]  || 32
      @height = options[:height] || 12
      @memory_offset = options[:memory_offset] || 0x8000

      @x_offset = options[:x_offset] || X_OFFSET
      @y_offset = options[:y_offset] || Y_OFFSET


      # Initial Screen dump
      @chars  = []
      @height.times do |h|
        @width.times do |w|
          offset = h * @width + w
          value = @memory.read(@memory_offset + 2*offset).value
          @chars[offset] = Char.new(value, w + @x_offset, h + @y_offset)
        end
      end

      @memory.add_observer(self)
#      print self
    end

    def size
      @size ||= @width * @height
    end

    def memory_offset_end
      @memory_offset_end ||= 0x82FE#@memory_offset + size*2 - 2
    end

    def to_s
      return @to_s if @to_s

      @to_s =  "\e[?1049h\e[17;1H"
      @to_s << @chars.join
      @to_s << frame
    end

    # Use a fancy border around console
    def frame
      return @frame if @frame

      chars = []
      # 4 corners
      chars << Char.new(0x23, @x_offset - 1, @y_offset - 1)               # TopLeft
      chars << Char.new(0x23, @x_offset + @width, @y_offset - 1)          # TopRight
      chars << Char.new(0x23, @x_offset - 1, @y_offset + @height)         # BottomLeft
      chars << Char.new(0x23, @x_offset + @width, @y_offset  + @height)   # BottomRight

      # horiz
      @width.times { |x| chars << Char.new(0x2d, x + @x_offset, @y_offset - 1) }
      @width.times { |x| chars << Char.new(0x2d, x + @x_offset, @y_offset + @height) }

      # vertical
      @height.times { |y| chars << Char.new(0x7c, @x_offset - 1, y + @y_offset) }
      @height.times { |y| chars << Char.new(0x7c, @x_offset + @width, y + @y_offset) }
      @frame = ""
      @frame << chars.join
    end

    # Callback from observed memory
    def update(offset, value)
      return unless (memory_offset..memory_offset_end).include?(offset)
      @to_s = nil

      diff = (offset - @memory_offset) / 2
      h    = diff / @width
      w    = diff % @width
      @chars[diff] = Char.new(value, w + @x_offset, h + @y_offset)
      print @chars[diff]
      changed
      notify_observers(self)
      print @chars[diff]
    end
  end

  # DOC
  # Inspired by: https://github.com/judofyr/rcpu/blob/master/lib/rcpu/libraries.rb
  class Char
    attr_reader :output
    def initialize(value, x, y)
      @char     = (value & 0x007F).chr
#      @bg_color = (value >> 8) & 0x0F
#      @fg_color = value >> 12

      args = []
      args << (value >> 15)
      if value > 0x7F
        args << color_to_ansi(value >> 12) + 30
        args << color_to_ansi(value >> 8)  + 40
      end

      @char = " " if @char.ord.zero?
      @color = "\e[#{args*';'}m"
      @output = "\e7\e[#{y};#{x}H#{@color}#{@char}\e8"
    end

    def to_s
      @output
    end

    def color_to_ansi(bit)
      ((bit & 1) << 2) | (bit & 2) | ((bit & 4) >> 2)
    end
  end
end



#The high 8 bits determine the color; the highest 4 are the foreground and the lowest 4 are the background

#args = []
#args << (value >> 15)
#if value > 0x7F
#  args << color_to_ansi(value >> 12) + 30
#  args << color_to_ansi(value >> 8)  + 40
#end

#char = " " if char.ord.zero?

#color = "\e[#{args*';'}m"
#print "\e7\e[#{rows+1};#{cols+1}H#{color}#{char}\e8"

