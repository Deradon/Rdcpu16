require "observer"
require 'dcpu16/support/debug'

require 'dcpu16/cpu/instruction'
require 'dcpu16/cpu/instructions'
require 'dcpu16/cpu/operand'
require 'dcpu16/cpu/register'


module DCPU16
  class CPU
    include DCPU16::Debug
    include DCPU16::Operand
    include DCPU16::Instructions
    include Observable

    RAM_SIZE  = 0x10000
    REGISTERS = [:A, :B, :C, :X, :Y, :Z, :I, :J]
    REGISTERS_COUNT = REGISTERS.length
    CLOCK_CYCLE = 100000 # cycles per second

    attr_accessor :cycle, :memory, :registers

    # program counter (PC), stack pointer (SP), overflow (O)
    attr_accessor :PC, :SP, :O

    # HACK: actually used to determine if we need to skip next instruction
    attr_accessor :skip

    attr_accessor :clock_cycle

    def initialize(memory = [])
      @cycle      = 0
      @memory     = DCPU16::Memory.new(memory)
      @registers  = Array.new(REGISTERS_COUNT) { Register.new }
      @PC = Register.new(0x0)
      @SP = Register.new(0xFFFF)
      @O  = Register.new(0x0)

      @clock_cycle = CLOCK_CYCLE
      @debug = true
      @skip  = false
    end

    # Define alias_methods for Registers: A(), B(), ...
    REGISTERS.each_with_index { |k, v| define_method(k) { registers[v] } }

    # Run in endless loop
    def run
      @started_at = Time.now
      max_cycles = 1

      while true do
        if @cycle < max_cycles
          step
        else
          diff = Time.now - @started_at
          max_cycles = (diff * @clock_cycle)
        end
      end
    end

    # Current clock_cycle
    def hz
      diff = Time.now - (@started_at || Time.now)
      diff = 1 if diff == 0
      @cycle / diff
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
    # TODO: Refacor if/else/if/else ... hacky mess here
    def step
      @instruction = Instruction.new(@memory.read(@PC))
      @PC += 1

      op  = @instruction.op
      a   = get_operand(@instruction.a)
      b   = get_operand(@instruction.b) if @instruction.b

      if @skip
        @skip = false
      else
        if b # Basic Instruction
          result = self.send(op, a.value, b.value)
        else # Non-Basic Instruction
          result = self.send(op, a.value)
        end
        a.write(result) if result
      end

      # Notify observers
      changed
      notify_observers(self)
    end

    def to_s
      <<EOF
###########
### CPU ###

* Cycle: #{cycle}
# Clock: #{clock_cycle}
*    HZ: #{hz}
*  Last: #{last_instruction.inspect}
*  Reg.: #{registers.inspect}
EOF
    end

  end
end

