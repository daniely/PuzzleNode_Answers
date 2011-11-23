module Stacker
  class Interpreter
    attr_accessor :stack, :if_level, :in_times, :buffer

    def initialize
      self.stack = [] 
      self.if_level = 0
      self.in_times = false
      self.buffer = []
    end

    def execute(c)
      if self.in_times && c != '/TIMES'
        push_to(c, self.buffer)
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
      elsif c == 'THEN'
        self.if_level -= 1

        self.stack << c and return unless self.if_level == 0

        # process if statement
        stmnt = self.stack.slice!(self.stack.index('IF')..-1)

        condition = execute(self.stack.pop).pop

        if condition.match(/true/)
          conditional_cmd = parse_if(stmnt)
        else
          conditional_cmd = parse_else(stmnt)
        end

        conditional_cmd.each { |cmd| execute(cmd) }
      elsif c == 'TIMES'
        # save num times to execute
        push_to(self.stack.pop, self.buffer)
        self.in_times = true
      elsif c == '/TIMES'
        self.in_times = false

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
      elsif c == 'IF'
        self.if_level += 1
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
          else_cmd = cmd.slice(result.count+1..-1)
          return else_cmd.map{ |a| a.class == Symbol ? ":#{a.to_s}" : a.to_s }
        end

        result << c
      end
      
      raise "missing THEN in IF ELSE THEN"
    end
  end
end
