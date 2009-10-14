module Wrench
  class Command < LazyArray
    attr_accessor :argv, :status, :stderr, :stdin, :stdout

    def initialize(*argv)
      super()
      @argv, @status = argv, nil
      @stdin, @stderr, @stdout = PushPipe.new, PullPipe.new, PullPipe.new

      load_with { exec }
    end

    def bind(pout, perr, pin)
      @stdout.attach(@pout = pout)
      @stderr.attach(@perr = perr)
      @stdin.attach(@pin = pin)

      unless @upstream.nil?
        Wrench::Pipe.join(@upstream.stdout, @stdin)
        @upstream.open
      end
    end

    def cleanup
      @t.join if @t.alive? unless @t.nil?
    end

    def command
      argv * ' '
    end

    def exec
      open { run }
    end

    def open
      @status = Open4.popen4(command) do |pid, pin, pout, perr|
        bind(pout, perr, pin)
        yield if block_given?
      end

      cleanup
    end

    def run(io = @stdout)
      @t = Thread.new do
        loop do
          case io.wait
          when IO   then push(*io.read)
          when nil  then break
          end
        end
      end
    end
  end
end
