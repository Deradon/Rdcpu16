require 'spec_helper.rb'

describe DCPU16::Instructions do
  let(:cpu) { DCPU16::CPU.new }
  subject { DCPU16::CPU.new } # HACK

  context "when value is between 0x00 and 0x07" do
    specify { DCPU16::Operand.new(cpu, 0x0).should == cpu.A }
    specify { DCPU16::Operand.new(cpu, 0x1).should == cpu.B }
    specify { DCPU16::Operand.new(cpu, 0x2).should == cpu.C }
    specify { DCPU16::Operand.new(cpu, 0x3).should == cpu.X }
    specify { DCPU16::Operand.new(cpu, 0x4).should == cpu.Y }
    specify { DCPU16::Operand.new(cpu, 0x5).should == cpu.Z }
    specify { DCPU16::Operand.new(cpu, 0x6).should == cpu.I }
    specify { DCPU16::Operand.new(cpu, 0x7).should == cpu.J }
  end

  context "when value is between 0x08 and 0x17" do
    before(:all) do
      cpu.memory.write(0x1000, 0x2a)
      cpu.registers.each { |r| r.write(0x1000) }
    end

    specify { DCPU16::Operand.new(cpu, 0x8).value.should == 0x2a }
    specify { DCPU16::Operand.new(cpu, 0xF).value.should == 0x2a }
  end


  context "when value is between 0x10 and 0x17" do
    pending
  end

  context "when value is 0x18" do
    pending
  end

  context "when value is 0x19" do
    pending
  end

  context "when value is 0x1A" do
    pending
  end

  context "when value is 0x1B" do
    pending
  end

  context "when value is 0x1C" do
    pending
  end

  context "when value is 0x1D" do
    pending
  end

  context "when value is 0x1E" do
    pending
  end

  context "when value is 0x1F" do
    pending
  end

  context "when value is between 0x20 and 0x3f" do
    specify { DCPU16::Operand.new(cpu, 0x20).should be_a_kind_of(DCPU16::Literal) }
    specify { DCPU16::Operand.new(cpu, 0x20).value.should == 0x0 }
    specify { DCPU16::Operand.new(cpu, 0x3f).value.should == 0x1f }
  end

  context "when value is > 0x3f" do
    specify do
      expect {
        DCPU16::Operand.new(cpu, 0x40)
      }.to raise_error(DCPU16::Operand::NotFound)
    end
  end
end

