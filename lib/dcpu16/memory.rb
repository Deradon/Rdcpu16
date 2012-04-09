module DCPU16
  class Memory < Array
    SIZE = 0x10000
    DEFAULT_VALUE = 0x0

    def initialize(default = [])
      super(SIZE, DEFAULT_VALUE)
      default.each_with_index { |word, offset| write(offset, word) }
    end

    def read(offset)
      # HACK: so we can just pass a Fixnum or a Register
      offset = offset.value if offset.respond_to? :value

      Word.new(self[offset], self, offset)
    end

    def write(offset, value)
      # HACK: so we can just pass a Fixnum or a Register
      offset = offset.value if offset.respond_to? :value

      self[offset] = value
    end

    def reset
    end

    private
    def [](key)
      super(key)
    end

    def []=(key, value)
      super(key, value)
    end

    # DOC
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
        @value = value
        @memory.write(@offset, value)
      end
    end
  end
end

