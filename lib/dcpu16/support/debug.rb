# Just a simple Debugger class
module DCPU16
  module Debug
    # Debug-mode turned on?
    def debug?
      @debug ||= false
    end

    private
    # Debug-Wrapper
    def debug(msg = nil, &block)
      return unless debug?

      puts "\n[DEBUG] - #{caller.first}"
      msg.each { |m| puts(m) } if msg.is_a?(Array)

      if msg.is_a?(Hash)
        msg.each do |k, v|
          puts "[#{k.to_s}]"

          if v.is_a?(Array)
            v.each {|m| puts(m) }
          else
            puts v
          end
        end
      elsif (msg.is_a?(String) || msg.is_a?(Symbol))
        puts msg.to_s
      end

      yield if block_given?
      puts "\n"
    end

    # DCPU16::CPU
    def debug_state
      debug do
        puts "Cycle:\t#{@cycle}"
        puts "PC:\t#{@PC}"
        puts "SP:\t#{@SP}"
        puts "O:\t#{@O}"
        puts "R:\t#{@registers}"
      end
    end
  end
end

