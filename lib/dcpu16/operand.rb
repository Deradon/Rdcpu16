# TODO: Test && Refacoring
module DCPU16
  module Operand
    class NotFound < StandardError; end

    def get_operand(value)
      if (0x00..0x07).include?(value)     # register (A, B, C, X, Y, Z, I or J, in that order)
        @registers[value]
      elsif (0x08..0x0f).include?(value)  # [register]
        register = @registers[value - 0x08]
        @memory[register]
      elsif (0x10..0x17).include?(value)
        @cycle += 1
        offset = @memory[@PC].value + @registers[value - 0x10].value
        @memory[offset].tap { @PC += 1 }
      elsif value == 0x18                 # POP / [@SP++]
        @memory[@SP].tap { @SP += 1 }
      elsif value == 0x19                 # PEEK / [@SP]
        @memory[@SP]
      elsif value == 0x1a                 # PUSH / [--@SP]
        @SP -= 1
        @memory[@SP]
      elsif value == 0x1b                 # @SP
        @SP
      elsif value == 0x1c                 # @PC
        @PC
      elsif value == 0x1d                 # O
        @O
      elsif value == 0x1e                 # [next word]
        @cycle += 1
        @memory[@memory[@PC]].tap { @PC += 1 }
      elsif value == 0x1f                 # next word (literal)
        @cycle += 1
        @memory[@PC].tap { @PC += 1 }
      elsif (0x20..0x3f).include?(value)  # literal value 0x00-0x1f (literal)
        DCPU16::Literal.new(value - 0x20)
      else
        raise NotFound
      end
    end
  end
end

