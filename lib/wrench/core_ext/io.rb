class IO

  def self.coerce(target, mode = 'r')
    case target
    when IO then yield target if block_given?
    when String
      File.open(target, mode) do |f|
        yield f if block_given?
      end
    end
  end

  def >>(target)
    IO.coerce(target, 'a') do |io|
      io << read while ready?
    end
  end

  def >(target)
    IO.coerce(target, 'w') do |io|
      io << read while ready?
    end
  end

  def <(target)
    IO.coerce(target, 'r') do |io|
      self << io.read while io.ready?
    end
  end

  alias_method :_read, :read
  def read(length = ready?, buffer = nil)
    length, buffer = ready?, length if length.is_a? String
    _read(length, buffer) unless length.nil?
  end
end
