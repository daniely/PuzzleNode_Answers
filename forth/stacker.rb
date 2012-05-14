module Stacker
  class Interpreter
    attr_accessor :stack, :if_level, :capture_if, :if_buffer, :capture_times, :times_buffer, :capture_procedure, :procedures, :procedure_name

    def initialize
      self.stack             = [] 
      self.if_level          = 0
      self.capture_if        = false
      self.if_buffer         = []
      self.capture_times     = false
      self.times_buffer      = []
      self.capture_procedure = false
      self.procedures        = {}
      self.procedure_name    = ''
    end

    def execute(c)
      if self.capture_procedure
        run_capture_procedure(c)
      elsif self.capture_if
        run_capture_if(c)
      elsif self.procedures.has_key?(c)
        self.procedures[c].each { |cmd| execute(cmd) }
      elsif self.capture_times
        run_capture_times(c)
      elsif c =~ /PROCEDURE/
        run_procedure(c)
      elsif c == 'IF'
        run_if(c)
      elsif c == 'ADD'
        run_add
      elsif c == 'SUBTRACT'
        run_subtract
      elsif c == 'MULTIPLY'
        run_multiply
      elsif c == 'DIVIDE'
        run_divide
      elsif c == 'MOD'
        run_mod
      elsif c == '<'
        run_greater_than
      elsif c == '>'
        run_less_than
      elsif c == '='
        run_equals
      elsif c == 'TIMES'
        run_times
      elsif c == 'DUP'
        run_dup
      elsif c == 'SWAP'
        run_swap
      elsif c == 'DROP'
        run_drop
      elsif c == 'ROT'
        run_rot
      else
        push(c)
      end
    end

    private

      def run_capture_procedure(c)
        unless c == '/PROCEDURE'
          self.procedures[self.procedure_name] << c
        else
          self.capture_procedure = false
        end
      end

      def run_capture_if(c)
        if c == 'THEN'
          self.if_level -= 1

          self.if_buffer << c 
          return unless self.if_level == 0

          condition = self.if_buffer.shift

          if condition.match(/true/)
            conditional_cmd = parse_if(self.if_buffer)
          else
            conditional_cmd = parse_else(self.if_buffer)
          end

          self.capture_if = false
          self.if_buffer = []
          conditional_cmd.each { |cmd| execute(cmd) }
        else
          self.if_level += 1 if c == 'IF'
          push(c, self.if_buffer)
        end
      end

      def run_capture_times(c)
        if c == '/TIMES'
          self.capture_times = false

          repeat = self.times_buffer.shift
          self.times_buffer = self.stack + self.times_buffer * repeat
          self.stack.clear

          self.times_buffer.each do |cmd| 
            execute(cmd)
          end
          self.times_buffer.clear
        else
          push(c, self.times_buffer)
        end
      end

      def run_procedure(c)
        self.capture_procedure = true
        self.procedure_name = c[/PROCEDURE (.+)/, 1]
        self.procedures[self.procedure_name] = []
      end

      def run_if(c)
        self.if_level += 1

        if self.if_level == 1
          # save conditional (true/false)
          push(self.stack.pop, self.if_buffer)
          push(c, self.if_buffer)
          self.capture_if = true
        end
      end

      def run_add
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << op2 + op1
      end

      def run_subtract
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << op2 - op1
      end

      def run_multiply
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << op2 * op1
      end

      def run_divide
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << op2 / op1
      end

      def run_mod
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << op2 % op1
      end

      def run_greater_than
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << (op2 < op1).to_s.to_sym
      end

      def run_less_than
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << (op2 > op1).to_s.to_sym
      end

      def run_equals
        op1 = self.stack.pop
        op2 = self.stack.pop

        self.stack << (op2 == op1).to_s.to_sym
      end

      def run_times
        # save num times to execute
        push(self.stack.pop, self.times_buffer)
        self.capture_times = true
      end

      def run_dup
        push(self.stack.last)
      end

      def run_swap
        self.stack[-1], self.stack[-2] = self.stack[-2], self.stack[-1]
      end

      def run_drop
        self.stack.pop
      end

      def run_rot
        move_item = self.stack.delete_at(-3)
        # ok to directly add to stack since item was just on the stack moments ago
        self.stack.push(move_item)
      end

      def push(c, target=self.stack)
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
