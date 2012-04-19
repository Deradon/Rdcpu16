module DCPU16
  class Debugger
    attr_reader :cpu, :screen
    def initialize(dump = [], options = {})
      @cpu    = DCPU16::CPU.new(dump)
      @screen = DCPU16::Screen.new(@cpu.memory)
      @update_every = options[:update_every] || 100000
      @step_mode    = false || options[:step_mode]

      @cpu.add_observer(self)
    end

    def run
      at_exit do
        print @screen
        puts @cpu.to_s
      end

      begin
        if @step_mode
          @update_every = nil
          while a = $stdin.gets
            a = a.to_i
            a = (@last_step_count || 1) if a < 1
            @last_step_count = a

            @cpu.step(a)
            print @screen
            print @cpu.to_s
          end
        else
          clear_screen
          @cpu.run
        end
      rescue DCPU16::Instructions::Reserved => e
        print @cpu.to_s
      end
    end

    # Observer
    def update(cpu)
      @counter ||= 0
      if @update_every && @counter > @update_every
        @counter = 0
        clear_screen
        print @cpu.to_s
      end
      @counter += 1
    end

    # Clears screen for output
    def clear_screen
      print @screen.to_s
    end
  end
end

