module Stacker
  class Interpreter
    attr_accessor :stack

    def initialize
      self.stack = [] 
    end

    def execute(c)
      self.stack = [5]
    end
  end
end
