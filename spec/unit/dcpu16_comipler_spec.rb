require 'spec_helper.rb'

describe DCPU16::Compiler do
  let(:asm) { File.open(File.join('spec', 'fixtures', 'example.asm')).read }
  subject { DCPU16::Compiler.new(asm) }

  its(:input) { should == asm }
  its(:dump) { should be_a_kind_of(Array) }
end

