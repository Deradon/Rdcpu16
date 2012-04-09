require 'spec_helper.rb'

describe DCPU16::Instruction do
  context "when initialized with 0x00" do
    let(:word) { DCPU16::Memory::Word.new(0x00) }
    subject { DCPU16::Instruction.new(word) }
    its(:opcode) { should == 0 }
    its(:a) { should == 0 }
    its(:b) { should be_nil }
  end

  context "when initialized with 0x0001" do
    let(:word) { DCPU16::Memory::Word.new(0x0001) }
    subject { DCPU16::Instruction.new(word) }
    its(:opcode) { should == 1 }
    its(:a) { should == 0 }
    its(:b) { should == 0 }
  end

  context "when initialized with 0xa861" do
    let(:word) { DCPU16::Memory::Word.new(0xa861) }
    subject { DCPU16::Instruction.new(word) }
    its(:opcode) { should == 1 }
    its(:a) { should == 0x6 }
    its(:b) { should == 0xa + 0x20 } # Literal value (offset += 0x20)
  end
end

