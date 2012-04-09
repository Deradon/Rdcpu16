require 'spec_helper.rb'

describe DCPU16::Memory do
  its(:length) { should == 0x10000 }

  describe "#read" do
    specify { subject.read(0).should be_a_kind_of(DCPU16::Word) }
  end


  specify "#write" do
    subject.write(0x1000, 42)
    subject.read(0x1000).value.should == 42
  end
end

