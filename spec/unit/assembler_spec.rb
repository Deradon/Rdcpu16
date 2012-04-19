require 'spec_helper.rb'

describe DCPU16::Assembler do
  let(:asm) { File.open(File.join('spec', 'fixtures', 'example.dasm16')).read }
  subject { DCPU16::Assembler.new(asm) }

  its(:input) { should == asm }
  its(:lines) { should be_a_kind_of(Array) }
  specify do
#    subject.lines
    subject.assemble
    #assert false
  end
end

