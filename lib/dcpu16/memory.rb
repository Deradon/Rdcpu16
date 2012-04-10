require 'dcpu16/memory/word'
require "observer"

module DCPU16
  class Memory# < Array
    include Observable

    SIZE = 0x10000
    DEFAULT_VALUE = 0x0

    def initialize(default = [])
      @memory = Array.new(SIZE, DEFAULT_VALUE)
      default.each_with_index { |word, offset| write(offset, word) }
    end

    def inspect
      self.to_s
    end

    def read(offset)
      # HACK: so we can just pass a Fixnum or a Register
      offset = offset.value if offset.respond_to? :value

      Word.new(@memory[offset], self, offset)
    end

    def write(offset, value)
      # HACK: so we can just pass a Fixnum or a Register
      offset = offset.value if offset.respond_to? :value

      @memory[offset] = value

      # Notify observers
      changed
      notify_observers(offset, value)
    end

    def reset
    end

    def length
      @memory.length
    end

    def [](key)
      read(key)
    end

    def []=(key, value)
      write(key, value)
    end
  end
end

