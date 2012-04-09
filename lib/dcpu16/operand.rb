# TODO: Test && Refacoring
module DCPU16
  class Operand
    class NotFound < StandardError; end

    def self.new(cpu, value)
      if (0x00..0x07).include?(value)
        # register (A, B, C, X, Y, Z, I or J, in that order)
        return cpu.registers[value]
      elsif (0x08..0x0f).include?(value)
        # [register]
        register = cpu.registers[value - DCPU16::CPU::REGISTERS_COUNT]
        return cpu.memory.read(register)
      elsif (0x10..0x17).include?(value)
        cpu.cycle += 1
        offset = cpu.memory.read(cpu.PC).value
        cpu.PC += 1
        return cpu.memory.read(offset + cpu.registers[value - 0x10].read)
      elsif value == 0x18
        # POP / [SP++]
        r = cpu.memory.read(cpu.SP)
        cpu.SP += 1
        return r
      elsif value == 0x19
        # PEEK / [SP]
        return cpu.memory.read(cpu.SP)
      elsif value == 0x1a
        # PUSH / [--SP]
        cpu.SP -= 1
        cpu.memory.read(cpu.SP)
      elsif value == 0x1b
        # SP
        return cpu.SP
      elsif value == 0x1c
        # PC
        return cpu.PC
      elsif value == 0x1d
        # O
        return cpu.O
      elsif value == 0x1e
        # [next word]
        cpu.cycle += 1
        offset = cpu.memory.read(cpu.PC)
        cpu.PC += 1
        return cpu.memory.read(offset)
      elsif value == 0x1f
        # next word (literal)
        cpu.cycle += 1
        r = cpu.memory.read(cpu.PC)
        cpu.PC += 1
        return r
      elsif (0x20..0x3f).include?(value)
        # literal value 0x00-0x1f (literal)
        DCPU16::Literal.new(value - 0x20)
      else
        raise NotFound
      end
    end
  end
end

