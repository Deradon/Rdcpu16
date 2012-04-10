require 'spec_helper.rb'
require 'unit/support/sample_observer'

describe DCPU16::CPU do
  # Initialize with non failing memory dump
  subject { DCPU16::CPU.new( Array.new(10000, 0x01) ) }

  describe "Register" do
    its(:registers) { subject.length == 8 }
    its(:registers) { subject[0] == be_kind_of(DCPU16::CPU::Register) }

    its(:PC) { should be_kind_of(DCPU16::CPU::Register) }
    its(:SP) { should be_kind_of(DCPU16::CPU::Register) }
    its(:O)  { should be_kind_of(DCPU16::CPU::Register) }
  end

  its(:cycle) { should == 0 }
  its(:memory) { should be_kind_of(DCPU16::Memory) }


  describe "#reset" do
    it "resets its #cycle" do
      subject.cycle = 2
      subject.reset
      subject.cycle.should == 0
    end
    it "resets its #memory" do
      subject.memory.should_receive(:reset)
      subject.reset
    end
    it "resets its #registers" do
      subject.registers.each { |register| register.should_receive(:reset) }
      subject.reset
    end
  end

  describe "Observable" do
    let(:observer) { DCPU16::SampleObserver.new }
    specify do
      subject.add_observer(observer)
      expect { subject.step }.to change{observer.cycle}.by(1)
    end
  end
end

