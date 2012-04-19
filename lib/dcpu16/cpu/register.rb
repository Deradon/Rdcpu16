module DCPU16
  class CPU
    class Register
      attr_reader :value

      def initialize(value = 0x0, name = nil)
        @default_value = value
        @name = name
        reset
      end

      def value
        warn "[Register #{self}] No Value defined" unless @value
        @value
      end
      alias_method :read, :value

      def +(value)
        @value += value
        @value &= 0xFFFF
        self
      end

      def -(value)
        @value -= value
        @value &= 0xFFFF
        self
      end

      def write(value)
        @value = value & 0xFFFF
      end

      def reset
        @value = @default_value
      end

      def inspect
        { :name => @name, :value => @value, :default_value => @default_value }
      end

      def to_s
        vh = ""
        dh =
        "name: #{@name}\tvalue: 0x%04x(#{@value})\tdefault: 0x%04x#{@default_value}" % [@value, @default_value]
      end
    end
  end
end

