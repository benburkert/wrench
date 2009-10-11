require 'extlib'
require 'io/wait'
require 'io/nonblock'

module Wrench
  VERSION = '0.0.1'
end

dir = File.dirname(__FILE__) / :wrench

require dir / :core_ext / :io
