module Wrench
  class Pipe < IO
    extend Forwardable

    attr_accessor :in, :out, :upstream

    alias_method :_in, :in

    # :binmode, :fcntl, :fileno, :fsync, :ioctl, :isatty,
    # :pid, :pos, :pos=, :reopen, :rewind, :seek, :stat, :sync, :sysseek,
    # :tell, :to_io, :tty?

    IN =   %w[ < << close closed? close_read flush print printf
               putc puts syswrite write write_nonblock ]

    OUT =  %w[ close_write eof eof? getc gets lineno lineno=
               nonblock nonblock= nonblock? _read
               read_nonblock readchar readline readlines
               readpartial ready? sysread ungetc wait ]

    def_delegators :_in, *IN
    def_delegators :out, *OUT

    def self.join(upstream, downstream)
      Thread.new do
        loop do
          case upstream.wait
          when IO   then upstream >> downstream
          when nil  then break
          end
        end
        downstream.close
      end
    end

    def initialize
      @out, @in = IO.pipe
      @out.nonblock = true
      @in.sync = true
    end
  end
end
