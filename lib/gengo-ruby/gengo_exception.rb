module Gengo
  # Base Exception class and such.
  class Gengo::Exception < ::StandardError
    attr_accessor :opstat, :code, :msg

    # Pretty self explanatory stuff here...
    def initialize(opstat, code, msg)
      @opstat = opstat
      @code = code
      @msg = msg
      super(msg)
    end

    def inspect
      "Gengo::Exception(opstat=%s, code=%d, msg=%s)" % [opstat, code, msg]
    end
  end
end
