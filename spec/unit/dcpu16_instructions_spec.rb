require 'spec_helper.rb'

describe DCPU16::Instructions do
  subject { DCPU16::CPU.new }
  let(:a) { 0x01 }
  let(:b) { 0x02 }


  describe "#set" do
    it "sets a to b" do
      subject.set(a, b).should == b
    end
    it "take 1 cycle, plus the cost of a and b" do
      expect { subject.set(a, b) }.to change{subject.cycle}.by(1)
    end
  end


  describe "#add" do
    it "sets a to a+b" do
      subject.add(2, 3).should == 5
    end
    context "with overflow" do
      it "sets O to 0x0001" do
        subject.add(0xFFFE, 2)
        subject.O.value.should == 0x0001
      end
    end
    context "without overflow" do
      it "sets O to 0x0" do
        subject.add(0xFFFE, 1)
        subject.O.value.should == 0x0
      end
    end
    it "take 2 cycles, plus the cost of a and b" do
      expect { subject.add(a, b) }.to change{subject.cycle}.by(2)
    end
  end


  describe "#sub" do
    it "sets a to a-b" do
      subject.sub(3, 2).should == 1
    end
    context "with underflow" do
      it "set O to 0xffff" do
        subject.sub(2, 3)
        subject.O.value.should == 0xffff
      end
    end
    context "without underflow" do
      it "set O to 0x0" do
        subject.sub(2, 2)
        subject.O.value.should == 0x0
      end
    end
    it "take 2 cycles, plus the cost of a and b" do
      expect { subject.sub(a, b) }.to change{subject.cycle}.by(2)
    end
  end


  describe "#mul" do
    it "sets a to a*b" do
      subject.mul(2, 3).should == 6
    end
    it "sets O to ((a*b)>>16)&0xffff" do
      subject.mul(256, 256)
      subject.O.value.should == ((256*256)>>16) & 0xFFFF
    end
    it "take 2 cycles, plus the cost of a and b" do
      expect { subject.mul(a, b) }.to change{subject.cycle}.by(2)
    end
  end


  describe "#div" do
    it "sets a to a/b" do
      subject.div(9, 3).should == 3
      subject.div(8, 3).should == 2
    end
    context "when b != 0" do
      it "sets O to ((a<<16)/b)&0xffff" do
        subject.div(1, 2)
        subject.O.value.should == ((1 << 16)/2) & 0xFFFF
      end
    end
    context "when b == 0" do
      it "sets a and O to 0" do
        subject.div(3, 0).should == 0
        subject.O.value.should == 0
      end
    end
    it "take 3 cycles, plus the cost of a and b" do
      expect { subject.div(a, b) }.to change{subject.cycle}.by(3)
    end
  end


  describe "#mod" do
    context "when b != 0" do
      it "sets a to a % b" do
        subject.mod(3, 2).should == 1
      end
    end
    context "when b == 0" do
      it "sets a to 0" do
        subject.mod(3, 0).should == 0
      end
    end
    it "take 3 cycles, plus the cost of a and b" do
      expect { subject.mod(a, b) }.to change{subject.cycle}.by(3)
    end
  end


  describe "#shl" do
    it "sets a to a<<b" do
      subject.shl(4, 2).should == 16
    end
    it "sets O to ((a<<b)>>16)&0xffff" do
      subject.shl(1, 17)
      subject.O.value.should == ((1 << 17) >> 16)&0xffff
    end
    it "take 2 cycles, plus the cost of a and b" do
      expect { subject.shl(a, b) }.to change{subject.cycle}.by(2)
    end
  end


  describe "#shr" do
    it "sets a to a>>b" do
      subject.shr(4, 2).should == 1
    end
    it "sets O to ((a<<16)>>b)&0xffff" do
      subject.shr(2, 2)
      subject.O.value.should == ((2 << 16) >> 2) & 0xffff
    end
    it "take 2 cycles, plus the cost of a and b" do
      expect { subject.shr(a, b) }.to change{subject.cycle}.by(2)
    end
  end


  describe "#and" do
    it "sets a to a&b" do
      subject.and(1, 2).should == 0
      subject.and(1, 3).should == 1
    end
    it "take 1 cycles, plus the cost of a and b" do
      expect { subject.and(a, b) }.to change{subject.cycle}.by(1)
    end
  end


  describe "#bor" do
    it "sets a to a|b" do
      subject.bor(1, 2).should == 3
    end
    it "take 1 cycles, plus the cost of a and b" do
      expect { subject.bor(a, b) }.to change{subject.cycle}.by(1)
    end
  end


  describe "#xor" do
    it "sets a to a^b" do
      subject.xor(1, 3).should == 2
    end
    it "take 1 cycles, plus the cost of a and b" do
      expect { subject.xor(a, b) }.to change{subject.cycle}.by(1)
    end
  end


  describe "#ife" do
    it "performs next instruction only if a==b" do
      subject.ife(1, 1)
      subject.skip.should be_false
      subject.ife(1, 2)
      subject.skip.should be_true
    end
    context "if test passes" do
      it "take 2 cycles, plus the cost of a and b" do
        expect { subject.ife(2, 2) }.to change{subject.cycle}.by(2)
      end
    end
    context "if test fails" do
      it "take 3 cycles, plus the cost of a and b" do
        expect { subject.ife(2, 3) }.to change{subject.cycle}.by(3)
      end
    end
  end


  describe "#ifn" do
    it "performs next instruction only if a!=b" do
      subject.ifn(1, 1)
      subject.skip.should be_true
      subject.ifn(1, 2)
      subject.skip.should be_false
    end
    context "if test passes" do
      it "take 2 cycles, plus the cost of a and b" do
        expect { subject.ifn(1, 2) }.to change{subject.cycle}.by(2)
      end
    end
    context "if test fails" do
      it "take 3 cycles, plus the cost of a and b" do
        expect { subject.ifn(2, 2) }.to change{subject.cycle}.by(3)
      end
    end
  end


  describe "#ifg" do
    it "performs next instruction only if a > b" do
      subject.ifg(1, 2)
      subject.skip.should be_true
      subject.ifg(2, 1)
      subject.skip.should be_false
    end
    context "if test passes" do
      it "take 2 cycles, plus the cost of a and b" do
        expect { subject.ifg(3, 2) }.to change{subject.cycle}.by(2)
      end
    end
    context "if test fails" do
      it "take 3 cycles, plus the cost of a and b" do
        expect { subject.ifg(2, 3) }.to change{subject.cycle}.by(3)
      end
    end
  end


  describe "#ifb" do
    it "performs next instruction only if (a&b)!=0" do
      subject.ifb(1, 3)
      subject.skip.should be_false
      subject.ifb(1, 2)
      subject.skip.should be_true
    end
    context "if test passes" do
      it "take 2 cycles, plus the cost of a and b" do
        expect { subject.ifb(1, 3) }.to change{subject.cycle}.by(2)
      end
    end
    context "if test fails" do
      it "take 3 cycles, plus the cost of a and b" do
        expect { subject.ifb(1, 2) }.to change{subject.cycle}.by(3)
      end
    end
  end
end

