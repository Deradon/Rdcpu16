require 'dcpu16/word'
require "observer"

module DCPU16
  class Memory < Array
    include Observable

    SIZE = 0x10000
    DEFAULT_VALUE = 0x0

    def initialize(default = [])
      super(SIZE, DEFAULT_VALUE)
      default.each_with_index { |word, offset| write(offset, word) }
    end

    def read(offset)
      # HACK: so we can just pass a Fixnum or a Register
      offset = offset.value if offset.respond_to? :value

      DCPU16::Word.new(self[offset], self, offset)
    end

    def write(offset, value)
      # HACK: so we can just pass a Fixnum or a Register
      offset = offset.value if offset.respond_to? :value

      self[offset] = value
      changed
      notify_observers(offset, value)
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
  end
end

