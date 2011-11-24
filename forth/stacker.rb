module Stacker
  class Interpreter
    attr_accessor :stack, :if_level, :capture_times, :buffer, :capture_if

    def initialize
      self.stack = [] 
      self.if_level = 0
      self.capture_times = false
      self.buffer = []
      self.capture_if = false
    end

    def execute(c)
      if self.capture_if
        if c == 'THEN'
          self.if_level -= 1

          self.buffer << c 
          return unless self.if_level == 0

          condition = self.buffer.shift

          if condition.match(/true/)
            conditional_cmd = parse_if(self.buffer)
          else
            conditional_cmd = parse_else(self.buffer)
          end

          self.capture_if = false
          self.buffer = []
          conditional_cmd.each { |cmd| execute(cmd) }
        else
          self.if_level += 1 if c == 'IF'
          push_to(c, self.buffer)
        end
      elsif c == 'IF'
        self.if_level += 1

        if self.if_level == 1
          # save conditional (true/false)
          push_to(self.stack.pop, self.buffer)
          push_to(c, self.buffer)
          self.capture_if = true
        end
      elsif c == 'ADD'
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << op2 + op1
      elsif c == 'SUBTRACT'
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << op2 - op1
      elsif c == 'MULTIPLY'
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << op2 * op1
      elsif c == 'DIVIDE'
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << op2 / op1
      elsif c == 'MOD'
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << op2 % op1
      elsif c == '<'
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << (op2 < op1).to_s.to_sym
      elsif c == '>'
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << (op2 > op1).to_s.to_sym
      elsif c == '='
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << (op2 == op1).to_s.to_sym
      elsif c == 'TIMES'
        debugger
        # save num times to execute
        push_to(self.stack.pop, self.buffer)
        self.capture_times = true
      elsif c == '/TIMES'
        self.capture_times = false

        repeat = self.buffer.shift
        self.buffer = self.stack + self.buffer * repeat
        self.stack.clear

        self.buffer.each do |cmd| 
          execute(cmd)
        end
        self.buffer.clear
      else
        push_to(c, self.stack)
      end
    end

    def push_to(c, target)
      c = c.to_s

      if c[0] == ':'
        c = c[1..-1].to_sym
      elsif c.match(/\d/)
        c = c.to_i 
      end

      target << c
    end

    def parse_if(cmd)
      result = []
      if_count = 0

      cmd.each do |c|
        if_count += 1 if c == 'IF'
        if_count -= 1 if c == 'ELSE'

        if c == 'ELSE' && if_count == 0
          result.shift
          return result.map{ |a| a.class == Symbol ? ":#{a.to_s}" : a.to_s }
        end

        result << c
      end

      raise "missing ELSE in IF ELSE THEN"
    end

    def parse_else(cmd)
      result = []
      if_count = 0

      cmd.each do |c|
        if_count += 1 if c == 'IF'
        if_count -= 1 if c == 'ELSE'

        if c == 'ELSE' && if_count == 0
          else_cmd = cmd.slice(result.count+1..cmd.rindex('THEN')-1)
          return else_cmd.map{ |a| a.class == Symbol ? ":#{a.to_s}" : a.to_s }
        end

        result << c
      end
      
      raise "missing THEN in IF ELSE THEN"
    end
  end
end
