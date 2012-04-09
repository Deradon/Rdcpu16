require 'spec_helper.rb'

describe DCPU16::CPU do
  describe "Register" do
    its(:registers) { subject.length == 8 }
    its(:registers) { subject[0] == be_kind_of(DCPU16::Register) }

    its(:PC) { should be_kind_of(DCPU16::Register) }
    its(:SP) { should be_kind_of(DCPU16::Register) }
    its(:O)  { should be_kind_of(DCPU16::Register) }
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
end

