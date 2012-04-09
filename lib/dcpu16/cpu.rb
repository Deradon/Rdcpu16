require 'dcpu16/support/debug'

require 'dcpu16/cpu/instructions'

require 'dcpu16/instruction'
require 'dcpu16/literal'
require 'dcpu16/memory'
require 'dcpu16/operand'
require 'dcpu16/register'

module DCPU16
  class CPU
    include DCPU16::Debug
    include DCPU16::Instructions

    RAM_SIZE  = 0x10000
    REGISTERS = [:A, :B, :C, :X, :Y, :Z, :I, :J]
    REGISTERS_COUNT = REGISTERS.length
    # CLOCK_CYCLE = 100000

    attr_accessor :cycle, :memory, :registers

    # program counter (PC), stack pointer (SP), overflow (O)
    attr_accessor :PC, :SP, :O

    # HACK: actually used to determine if we need to skip next instruction
    attr_accessor :skip

    # attr_reader :clock_cycle

    def initialize(memory = [])
      @cycle      = 0
      @memory     = DCPU16::Memory.new(memory)
      @registers  = Array.new(REGISTERS_COUNT) { DCPU16::Register.new }
      @PC = DCPU16::Register.new(0x0)
      @SP = DCPU16::Register.new(0xFFFF)
      @O  = DCPU16::Register.new(0x0)

      @debug = true
      @skip  = false
    end

    # Define alias_methods for Registers: A(), B(), ...
    REGISTERS.each_with_index { |k, v| define_method(k) { registers[v] } }

    def run
      step while true
    end

    # Resets the CPU and its sub-systems (registers, memory, ...)
    def reset
      @cycle = 0
      @memory.reset
      @registers.each { |r| r.reset }
      @PC.reset
      @SP.reset
      @O.reset
    end

    # DOC
    def last_instruction
      @instruction
    end

    # Perform a single step
    # TODO: Refacor if/else/if/else ...
    def step
      @instruction = Instruction.new(@memory.read(@PC))
      @PC += 1

      op  = @instruction.op
      a   = get_operand(@instruction.a)
      b   = get_operand(@instruction.b) if @instruction.b

      if @skip
        @skip = false
      else
        if b
          result = self.send(op, a.value, b.value)
        else
          result = self.send(op, a.value)
        end
        a.write(result) if result
      end
    end

    # TODO: May be removed
    def get_operand(value)
      DCPU16::Operand.new(self, value)
    end
  end
end

