module DCPU16
  module Instructions
    # sets a to b
    def set(a, b)
      @cycle += 1
      b
    end

    # sets a to a+b, sets O to 0x0001 if there's an overflow, 0x0 otherwise
    def add(a, b)
      @cycle += 2
      (a + b > 0xFFFF) ? @O.write(0x0001) : @O.write(0x0)
      a + b
    end

    # sets a to a-b, sets O to 0xffff if there's an underflow, 0x0 otherwise
    def sub(a, b)
      @cycle += 2
      (b > a) ? @O.write(0xffff) : @O.write(0x0)
      a - b
    end

    # sets a to a*b, sets O to
    def mul(a, b)
      @cycle += 2
      @O.write( ( (a * b) >> 16) & 0xffff )
      a * b
    end

    # sets a to a/b, sets O to ((a<<16)/b)&0xffff. if b==0, sets a and O to 0 instead.
    def div(a, b)
      @cycle += 3
      if b == 0
        @O.write(0)
        return 0
      else
        @O.write( ( (a << 16) / b) & 0xffff )
        return (a / b)
      end
    end

    # sets a to a%b. if b==0, sets a to 0 instead.
    def mod(a, b)
      @cycle += 3
      (b == 0) ? 0 : a % b
    end

    # sets a to a<<b, sets O to ((a<<b)>>16)&0xffff
    def shl(a, b)
      @cycle += 2
      @O.write( ( (a << b) >> 16 ) & 0xffff )
      a << b
    end

    # sets a to a>>b, sets O to ((a<<16)>>b)&0xffff
    def shr(a, b)
      @cycle += 2
      @O.write( ( (a << 16) >> b) & 0xffff )
      a >> b
    end

    # sets a to a & b
    def and(a, b)
      @cycle += 1
      a & b
    end

    # sets a to a | b
    def bor(a, b)
      @cycle += 1
      a | b
    end

    # sets a to a ^ b
    def xor(a, b)
      @cycle += 1
      a ^ b
    end

    # performs next instruction only if a == b
    def ife(a, b)
      @cycle += 2
      @skip = !(a == b)
      @cycle += 1 unless a == b

      return nil
    end

    # performs next instruction only if a != b
    def ifn(a, b)
      @cycle += 2
      @skip = !(a != b)
      @cycle += 1 unless a != b

      return nil
    end

    # performs next instruction only if a > b
    def ifg(a, b)
      @cycle += 2
      @skip = !(a > b)
      @cycle += 1 unless a > b

      return nil
    end

    # performs next instruction only if (a & b) != 0
    def ifb(a, b)
      @cycle += 2
      @skip = !((a & b) != 0)
      @cycle += 1 unless (a & b) != 0

      return nil
    end


    class Reserved < StandardError; end

    ### NON - Basic ###
    def reserved(a)
      raise Reserved
    end

    # JSR a - pushes the address of the next instruction to the stack, then sets PC to a
    def jsr(a)
      @cycle += 2

      # pushes the address of the next instruction to the stack
      @SP -= 1
      @memory.write(@SP, @PC.read)

      @PC.write(a)
      return nil
    end
  end
end

