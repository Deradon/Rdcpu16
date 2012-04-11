module DCPU16
  class Debugger
    attr_reader :cpu, :screen
    def initialize(dump = [])
      @cpu    = DCPU16::CPU.new(dump)
      @screen = DCPU16::Screen.new(@cpu.memory)

      @cpu.add_observer(self)
    end

    def run
      clear_screen
      begin
        @cpu.run
      rescue DCPU16::Instructions::Reserved => e
        puts @cpu.to_s
      end
    end

    # Observer
    def update(cpu)
      #cpu
    end

    # Clears screen for output
    def clear_screen
      print @screen.to_s
    end
  end
end

