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
      if capture_procedure
        run_capture_procedure(c)
      elsif capture_if
        run_capture_if(c)
      elsif procedures.has_key?(c)
        procedures[c].each { |cmd| execute(cmd) }
      elsif capture_times
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
          procedures[procedure_name] << c
        else
          self.capture_procedure = false
        end
      end

      def run_capture_if(c)
        if c == 'THEN'
          self.if_level -= 1

          if_buffer << c 
          return unless if_level == 0

          condition = if_buffer.shift

          if condition.match(/true/)
            conditional_cmd = parse_if(if_buffer)
          else
            conditional_cmd = parse_else(if_buffer)
          end

          self.capture_if = false
          self.if_buffer = []
          conditional_cmd.each { |cmd| execute(cmd) }
        else
          self.if_level += 1 if c == 'IF'
          push(c, if_buffer)
        end
      end

      def run_capture_times(c)
        if c == '/TIMES'
          self.capture_times = false

          repeat = times_buffer.shift
          self.times_buffer = stack + times_buffer * repeat
          stack.clear

          times_buffer.each do |cmd| 
            execute(cmd)
          end
          times_buffer.clear
        else
          push(c, times_buffer)
        end
      end

      def run_procedure(c)
        self.capture_procedure = true
        self.procedure_name = c[/PROCEDURE (.+)/, 1]
        procedures[procedure_name] = []
      end

      def run_if(c)
        self.if_level += 1

        if if_level == 1
          # save conditional (true/false)
          push(stack.pop, if_buffer)
          push(c, if_buffer)
          self.capture_if = true
        end
      end

      def run_add
        op1 = stack.pop
        op2 = stack.pop

        stack << op2 + op1
      end

      def run_subtract
        op1 = stack.pop
        op2 = stack.pop

        stack << op2 - op1
      end

      def run_multiply
        op1 = stack.pop
        op2 = stack.pop

        stack << op2 * op1
      end

      def run_divide
        op1 = stack.pop
        op2 = stack.pop

        stack << op2 / op1
      end

      def run_mod
        op1 = stack.pop
        op2 = stack.pop

        stack << op2 % op1
      end

      def run_greater_than
        op1 = stack.pop
        op2 = stack.pop

        stack << (op2 < op1).to_s.to_sym
      end

      def run_less_than
        op1 = stack.pop
        op2 = stack.pop

        stack << (op2 > op1).to_s.to_sym
      end

      def run_equals
        op1 = stack.pop
        op2 = stack.pop

        stack << (op2 == op1).to_s.to_sym
      end

      def run_times
        # save num times to execute
        push(stack.pop, times_buffer)
        self.capture_times = true
      end

      def run_dup
        push(stack.last)
      end

      def run_swap
        stack[-1], stack[-2] = stack[-2], stack[-1]
      end

      def run_drop
        stack.pop
      end

      def run_rot
        move_item = stack.delete_at(-3)
        # ok to directly add to stack since item was just on the stack moments ago
        stack.push(move_item)
      end

      def push(c, target=stack)
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
