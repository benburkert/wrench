require 'forwardable'
require 'io/wait'
require 'io/nonblock'

require 'extlib'
require 'popen4'

module Wrench
  VERSION = '0.0.1'
end

dir = File.dirname(__FILE__) / :wrench

require dir / :core_ext / :io
require dir / :core_ext / :object

require dir / :pipe / :pipe
require dir / :pipe / :pull_pipe
