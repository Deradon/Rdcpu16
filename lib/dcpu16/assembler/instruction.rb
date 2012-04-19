module DCPU16
  class Assembler

    BASIC_INSTRUCTIONS = {
      :SET => 0x1,
      :ADD => 0x2,
      :SUB => 0x3,
      :MUL => 0x4,
      :DIV => 0x5,
      :MOD => 0x6,
      :SHL => 0x7,
      :SHR => 0x8,
      :AND => 0x9,
      :BOR => 0xa,
      :XOR => 0xb,
      :IFE => 0xc,
      :IFN => 0xd,
      :IFG => 0xe,
      :IFB => 0xf
    }

    NON_BASIC_INSTRUCTIONS = {
      :JSR => 0x01
    }

    INSTRUCTIONS = BASIC_INSTRUCTIONS.merge(NON_BASIC_INSTRUCTIONS)
    # INDIRECT: [x+y] =>

  # + 0x00-0x07: register (A, B, C, X, Y, Z, I or J, in that order)             SET A               0x0001
  # I 0x08-0x0f: [register]                                                     SET [A]             0x????
  # I 0x10-0x17: [next word + register]                                         SET [A+0x1000]      0x???? 0x????
  # +      0x18: POP / [SP++]
  # +      0x19: PEEK / [SP]
  # +      0x1a: PUSH / [--SP]
  # +      0x1b: SP
  # +      0x1c: PC
  # +      0x1d: O
  # I      0x1e: [next word]                                                    SET [0x1000]        0x???? 0x????
  # V      0x1f: next word (literal)                                            SET 0x1000          0x???? 0x????
  # V 0x20-0x3f: literal value 0x00-0x1f (literal)                              SET 0x????          0x????
    class Instruction; end;

    # BasicInstruction like: SET, ADD, ...
    class BasicInstruction < Instruction
      def initialize(op, a, b, location)
        super(op, location)
        @a = value(a)
        @b = value(b)
      end

      def word
        @op_value + (@a << 4) + (@b << 10)
      end
    end

    # NonBasicInstruction like: JSR
    class NonBasicInstruction < Instruction
      def initialize(op, a, location)
        super(op, location)
        @a = value(a)
      end



      def word
        (@op_value << 4) + (@a << 10)
      end
    end

    # DatInstruction: dat "foobar"
    class DatInstruction < Instruction
      def initialize(op, args, location)
        super(op, location)

        args.each do |arg|
          # TODO: shitty string detection here, refactor please
          re_string = /^"([^"]*)"|'([^']*)'$/
          match = arg.match(re_string)
          if match
            s = match[1] || match[2]
            s.each_byte { |b| @words << b } # Add chars
          else
            @words << dehex(arg) # No string given, assume value/label here
          end
        end
      end

      def words
        @words
      end

      def size
        @words.size
      end
    end




    class Instruction #< Struct.new(:op, :args, :location)
      RE_INDIRECT = /^\[([^+]+)\+?([^+]+)?\]$/
      RE_HEX = /^0[xX][0-9a-fA-F]{1,4}$/
      RE_INT = /^\d{1,5}$/
      LITERALS = (0x00..0x1f)

      attr_accessor :a, :b, :location, :op

      class << self
        def instruction_type(op)
          return :basic     if BASIC_INSTRUCTIONS[op]
          return :non_basic if NON_BASIC_INSTRUCTIONS[op]
          return op
        end

        # InstructionFactory
        def create(op, args, location)
          @op = op.upcase.intern

          case instruction_type(@op)
          when :basic
            BasicInstruction.new(@op, args[0], args[1], location)
          when :non_basic
            NonBasicInstruction.new(@op, args[0], location)
          when :DAT
            DatInstruction.new(@op, args, location)
          else
            raise "Instruction not found: #{@op}"
          end
        end
      end


      def initialize(op, location)
        @words    = []
        @op       = op
        @location = location
        @op_value = INSTRUCTIONS[@op]
      end


      def add_word(value)
        raise "NilValue" unless value
        @words << value
      end

      def value(operand)
        operand = operand.to_s

        register = REGISTER[operand.upcase.intern]
        return register if register

        # Is a indirect: [A], [0x8000], [0x8000 + A], [0x30]
        indirect = operand.match(RE_INDIRECT)
        if indirect
          if indirect[2]
            # hacky implementation
            r = REGISTER[indirect[2].upcase.intern]
            i = 1
            if !r
              r = REGISTER[indirect[1].upcase.intern]
              i = 2
            end
            raise "Something went wrong (yeah, its a stupid message right here) [#{operand}]" unless r
            add_word(dehex(indirect[i]))

            # 0x10-0x17: [next word + register]
            return (r + 0x10)
          else
            r = REGISTER[indirect[1].upcase.intern]
            if r
              # 0x08-0x0f: [register]
              return (r + 0x08)
            else
              # 0x1e:      [next word]
              add_word(dehex(indirect[1]))
              return 0x1e
            end
          end
        end

        value = dehex(operand)
        if (0x00..0x1f).include?(value)
          # 0x20-0x3f: literal value 0x00-0x1f (literal)
          return (value + 0x20)
        else
          # 0x1f: next word (literal) || next word (label)
          add_word(value)
          return 0x1f
        end
      end

      def word
        raise "Must be implemented by #{self.class.name}!"
      end

      # Returns size of Instruction in bytes
      def size
        @words.size + 1
      end

      # Add Labels to values
      def apply_labels(labels = {})
        @words.map! { |word| labels[word] || dehex(word, :raise => true) }
      end

      def words
        [word] + @words
      end

      def bytes
        words.map { |w| [w].pack('n') }.join("")
      end

      def to_s(options = {:line_number => false})
        raw = words.map{|w| hex(w)}.join(" ")
        options[:line_number] ? "#{location.to_s(16)}:\t#{raw}" : raw
      end

      # Convert string to hex or dec value; if none of them return input
      # Raise error if option enabled and no hex/dec value
      def dehex(v, options = {:raise => false})
        v = v.to_s
        return v.hex  if v.match(RE_HEX)
        return v.to_i if v.match(RE_INT)
        raise "'#{v}' is no Hex or Int (label not found?) [#{@words.inspect}]\n" if options[:raise]
        return v.downcase
      end

      def hex(w)
        "%04x" % w
      end
    end
  end
end

