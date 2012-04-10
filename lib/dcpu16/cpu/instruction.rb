# Instructions are 1-3 words long and are fully defined by the first word.
# In a basic instruction, the lower four bits of the first word of the instruction are the opcode,
# and the remaining twelve bits are split into two six bit values, called a and b.
# a is always handled by the processor before b, and is the lower six bits.

# In bits (with the least significant being last),
# a basic instruction has the format: bbbbbbaaaaaaoooo

# bbbb bbaa aaaa oooo
# 0000 0000 0000 1111 -> 0x000f
# 0000 0011 1111 0000 -> 0x03f0
# 1111 1100 0000 0000 -> 0xfc00

# Non-basic opcodes always have their lower four bits unset, have one value and a six bit opcode.
# In binary, they have the format: aaaaaaoooooo0000

# aaaa aaoo oooo 0000
# 0000 0011 1111 0000 -> 0x03f0
# 1111 1100 0000 0000 -> 0xfc00

module DCPU16
  class CPU
    class Instruction
      INSTRUCTIONS = [
        :reserved,
        :set, :add, :sub, :mul, :div, :mod,
        :shl, :shr,
        :and, :bor, :xor,
        :ife, :ifn, :ifg, :ifb
      ]

      NON_BASIC_INSTRUCTIONS = [
        :reserved,
        :jsr
      ]

      attr_reader :opcode, :a, :b, :word

      def initialize(word = nil)
        @word   = word.value
        @opcode = @word & 0x000F

        if @opcode == 0x0
          @non_basic = true
          @opcode = (@word >> 4) & 0x3f
          @a      = @word >> 10
        else
          @a = (@word >> 4) & 0x3f
          @b = @word >> 10
        end
      end

      def op
        @non_basic ? NON_BASIC_INSTRUCTIONS[@opcode] : INSTRUCTIONS[@opcode]
      end
    end
  end
end

