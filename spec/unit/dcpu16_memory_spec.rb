require 'spec_helper.rb'

describe DCPU16::Memory do
  its(:length) { should == 0x10000 }
  specify { subject.read(0).value.should == 0 }

  describe "#write" do
    pending
  end
end

#describe DCPU16::Memory::Word do
#  let(:memory) { DCPU16::Memory.new }

#  specify do
#    DCPU16::Memory::Word.new(2, memory, 0).should be_a_kind_of(DCPU16::Memory::Word)
#  end
#end

