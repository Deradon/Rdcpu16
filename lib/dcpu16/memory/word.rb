module DCPU16
  class Memory
    class Word
      def initialize(value, memory = nil, offset = nil)
        @value  = value
        @memory = memory
        @offset = offset
      end

      def value
        @value
      end
      alias_method :read, :value

      def write(value)
        value &= 0xFFFF
        @value = value
        @memory.write(@offset, value)
      end
    end
  end
end

