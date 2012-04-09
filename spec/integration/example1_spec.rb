require 'spec_helper.rb'

describe DCPU16::CPU do
  describe "quick example by notch" do
    let(:dump) do
      [ 0x7c01, 0x0030, 0x7de1, 0x1000, 0x0020, 0x7803, 0x1000, 0xc00d,
        0x7dc1, 0x001a, 0xa861, 0x7c01, 0x2000, 0x2161, 0x2000, 0x8463,
        0x806d, 0x7dc1, 0x000d, 0x9031, 0x7c10, 0x0018, 0x7dc1, 0x001a,
        #0x9037, 0x61c1, 0x7dc1, 0x001a, 0x0000, 0x0000, 0x0000, 0x0000 ]
        0x9037, 0x61c1, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000 ]
    end

    subject { DCPU16::CPU.new(dump) }

    # Just double-check that memory is loaded
    specify { subject.memory.read(0x0).value.should == 0x7c01 }
#    specify { subject.memory.read(0x1b).value.should == 0x001a }

    specify do
      begin
        subject.run.should raise_error(RuntimeError, /Reserved/)
      rescue
      end

      subject.cycle.should == 104
      subject.A.value.should == 0x2000
      subject.X.value.should == 0x40
    end
  end
end

