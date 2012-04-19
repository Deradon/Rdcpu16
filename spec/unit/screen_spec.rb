require 'spec_helper'
require 'unit/support/screen_observer'

describe DCPU16::Screen do
  let(:memory) { DCPU16::Memory.new }
  subject { DCPU16::Screen.new(memory) }

  describe "initialize" do
    specify { expect { DCPU16::Screen.new }.to raise_error(ArgumentError) }
    specify { expect { DCPU16::Screen.new(memory) }.to_not raise_error }
    its(:width) { should == 32 }
    its(:height) { should == 12 }
    its(:memory_offset) { should == 0x8000 }
    its(:chars) { subject.length.should == 32*12 } # width * height + newlines

    context "when called with options" do
      let(:options) { {:width => 40, :height => 200, :memory_offset => 0x9000} }
      subject { DCPU16::Screen.new(memory, options) }

      its(:width) { should == 40 }
      its(:height) { should == 200 }
      its(:memory_offset) { should == 0x9000 }
      its(:chars) { subject.length.should == 40 * 200 }
    end
  end

  describe "#to_s" do
    context "in initial state" do
      pending
#      let(:expected) { String.new(" "*32 + "\n") * 12 }
#      its(:to_s) { should == expected }
    end
  end

  describe "observable" do
    let(:observer) { DCPU16::ScreenObserver.new }
    before(:all) { subject.add_observer(observer) }

    specify { subject.should_receive(:update).tap { memory.write(0x8000, 40) } }
    context "memory outside of screen changed" do
      specify { observer.should_not_receive(:update).tap { memory.write(0x7FFF, 40) } }
      specify { observer.should_not_receive(:update).tap { memory.write(0x8000 + 0x300, 40) } }
    end
    context "memory of screen changed" do
      pending "Disabled Observer right now!"
#      specify { observer.should_receive(:update).tap { memory.write(0x8000, 40) } }
#      specify { observer.should_receive(:update).tap { memory.write(0x82FE, 40) } }
    end
  end
end

