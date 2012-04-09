require 'spec_helper.rb'

describe DCPU16::Word do
  let(:memory) { DCPU16::Memory.new }
  subject { DCPU16::Word.new(2, memory, 0) }

  specify { subject.should be_a_kind_of(DCPU16::Word) }
  its(:value) { should == 2 }
  its(:read)  { should == 2 }

  describe "#write" do
    before { subject.write(42) }
    its(:value) { should == 42 }
    specify { memory.read(0).value.should == 42 }
  end
end

