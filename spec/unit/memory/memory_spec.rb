require 'spec_helper.rb'
require 'unit/support/memory_observer'

describe DCPU16::Memory do
  its(:length) { should == 0x10000 }

  describe "#read" do
    specify { subject.read(0).should be_a_kind_of(DCPU16::Memory::Word) }
  end


  specify "#write" do
    subject.write(0x1000, 42)
    subject.read(0x1000).value.should == 42
  end

  describe "Observable" do
    let(:observer) { DCPU16::MemoryObserver.new }
    specify do
      subject.add_observer(observer)
      expect { subject.write(0x9000, 42) }.to change{observer.offset}.to(0x9000)
      expect { subject.write(0x9000, 41) }.to change{observer.value}.to(41)
    end
  end
end

