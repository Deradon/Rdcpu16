module DCPU16
  class Register
    attr_reader :value

    def initialize(value = 0x0)
      @default_value = value
      reset
    end

    def value
      warn "[Register #{self}] No Value defined" unless @value
      @value
    end
    alias_method :read, :value

    def +(value)
      @value += value
      self
    end

    def -(value)
      @value -= value
      self
    end

    def write(value)
      @value = value
    end

    def reset
      @value = @default_value
    end
  end
end

