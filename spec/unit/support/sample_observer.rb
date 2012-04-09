module DCPU16
  class SampleObserver
    attr_reader :cycle

    def initialize
      @cycle = 0
    end

    def update(cpu)
      @cycle = cpu.cycle
    end
  end
end

