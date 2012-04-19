module DCPU16
  class Assembler
    class Line < Struct.new(:raw_label, :op, :args)
      # TODO: refactor
      def label
        return @label if @label || raw_label.nil?

        @label = raw_label.downcase
        @label = @label[1, @label.length] if @label.start_with?(":")

        return @label
      end
    end
  end
end

