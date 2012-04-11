require 'spec_helper.rb'

describe DCPU16::Assembler do
  let(:asm) { File.open(File.join('spec', 'fixtures', 'example.dasm16')).read }
  subject { DCPU16::Assembler.new(asm) }

  its(:input) { should == asm }
  its(:dump) { should be_a_kind_of(Array) }
  specify do
#    puts subject.dump
    puts subject.dump.first.bytes.length
  end
end

