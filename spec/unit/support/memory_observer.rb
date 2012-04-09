module DCPU16
  class MemoryObserver
    attr_reader :offset, :value

    def initialize
    end

    def update(offset, value)
      @offset = offset
      @value  = value
    end
  end
end

