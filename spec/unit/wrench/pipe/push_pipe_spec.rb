require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Wrench::PushPipe do
  it 'should be chainable' do
    p1 = Wrench::PushPipe.new
    p2 = Wrench::PushPipe.new(p1)
    p3 = Wrench::PushPipe.new(p2)

    p3 << 'blah'
    p1.read.should == 'blah'
  end

  it 'should write through' do
    p1 = Wrench::PushPipe.new
    p2 = Wrench::PushPipe.new(p1)
    p3 = Wrench::PushPipe.new(p2)

    p3 << 'blarg'
    p1.out.should be_ready
    p1.read.should == 'blarg'
  end

  describe '#attach' do
    it 'should set the downstream IO' do
      pushr, io = Wrench::PushPipe.new, StringIO.new
      lambda { pushr.attach(io) }.should change { pushr.downstream }.to(io)
    end
  end

  describe "#close" do
    it 'should close the downstream IO' do
      p1, down = Wrench::PushPipe.new, Wrench::Pipe.new
      p1.attach(down)
      lambda { p1.close }.should change { down.closed? }.to(true)
    end
  end
end
