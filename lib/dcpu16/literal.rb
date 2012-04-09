# Ruby, Y U NO INHERIT FROM INTEGER?
module DCPU16
  class Literal
    def initialize(value)
      @value = value
    end

    def value
      @value
    end
    alias_method :read, :value

    # If any instruction tries to assign a literal value, the assignment fails silently
    def write(value)
      # pass
    end
  end
end

