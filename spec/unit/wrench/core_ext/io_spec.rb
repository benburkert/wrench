require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe IO do
  describe '.coerce' do
    describe 'with an IO' do
      it 'should yield the IO' do
        io = StringIO.new
        IO.coerce(io) {|i| i.should == io }
      end
    end

    describe 'with a String and no mode' do
      it 'should yield a read only File' do
        path = Tempfile.new('').path
        IO.coerce(path) do |f|
          lambda { f << 'foo' }.should raise_error(IOError)
          lambda { f.read }.should_not raise_error(IOError)
        end
      end
    end

    describe 'with a String and a mode' do
      it 'should yield a File opened with the mode' do
        path = Tempfile.new('').path
        IO.coerce(path, 'r') do |f|
          lambda { f << 'foo' }.should raise_error(IOError)
          lambda { f.read }.should_not raise_error(IOError)
        end

        IO.coerce(path, 'a') do |f|
          lambda { f << 'foo' }.should_not raise_error(IOError)
          lambda { f.read }.should raise_error(IOError)
        end

        IO.coerce(path, 'w') do |f|
          lambda { f << 'foo' }.should_not raise_error(IOError)
          lambda { f.read }.should raise_error(IOError)
        end

        IO.coerce(path, 'r+') do |f|
          lambda { f << 'foo' }.should_not raise_error(IOError)
          lambda { f.read }.should_not raise_error(IOError)
        end
      end
    end
  end

  describe '#>>' do
    it 'should append self to the target' do
      tempfile = Tempfile.new('')
      tempfile.open do |f|
        f << 'hello '
      end

      o, i = IO.pipe
      i << 'world'
      o >> tempfile.path

      tempfile.open do |f|
        f.read.chomp.should == 'hello world'
      end
    end
  end

  describe '#>' do
    it 'should write self to the target' do
      tempfile = Tempfile.new('')

      tempfile.open do |f|
        f << 'hello '
      end

      o, i = IO.pipe
      i << 'world'
      o > tempfile.path

      tempfile.open do |f|
        f.read.chomp.should == 'world'
      end
    end
  end

  describe '#<' do
    it 'should write the target to self' do
      path = Tempfile.new('').path

      File.open(path, 'w') do |f|
        f << 'foo bar'
      end

      o, i = IO.pipe
      i < path

      o.read.should == 'foo bar'
    end
  end

  describe '#read' do
    describe 'without a length' do
      it 'should be a non blocking read' do
        o, i = IO.pipe
        i << 'foo'
        o.read.should == 'foo'
      end

      describe 'but with a buffer' do
        it 'should be a nonblocking read' do
          buff, o, i = '', *IO.pipe
          i << 'foo'
          lambda { o.read(buff) }.should change { buff.dup }.from('').to('foo')
        end
      end
    end

    describe 'with a length' do
      it 'should be a blocking read' do
        o, i = IO.pipe
        i << '123'

        t = Thread.new { Thread.pass; i << '456' }

        lambda { o.read(6).should == '123456' }.should change { t.alive? }.from(true).to(false)
      end

      describe 'and a buffer' do
        it 'should be a blocking read' do
          buff, o, i = '', *IO.pipe
          i << '123'

          t = Thread.new { Thread.pass; i << '456' }

          lambda { o.read(6, buff) }.should change { buff.dup }.from('').to('123456')
        end
      end
    end
  end
end
