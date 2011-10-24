require 'ruby-debug'

class Turtle
  attr_accessor :size, :x, :y, :canvas, :direction
  MARK = 'X'

  def initialize(size=9)
    self.size = size
    self.canvas = Array.new(size){ ['.'] * size }

    # start turtle in middle of canvas
    mid = self.size / 2
    self.x = mid
    self.y = mid

    self.direction = 0
    mark
  end

  def direction=(value)
    value -= 360 if value >= 360
    value += 360 if value < 0
    @direction = value
  end

  def execute(command)
    c, value = command.split
    value = value.to_i

    if c == 'REPEAT'
      m = command.match(/\[(.+)\]/)
      command_pairs = m[1].split

      value.times do
        command_pairs.each_slice(2) do |c|
          execute(c.join(' '))
        end
      end
    elsif c == 'FD' || c == 'BK'
      self.direction += 180 if c == 'BK'

      value.times do
        if self.direction == 0
          self.y -= 1
          mark
        elsif self.direction == 45
          self.x += 1
          self.y -= 1
          mark
        elsif self.direction == 90
          self.x += 1
          mark
        elsif self.direction == 135
          self.x += 1
          self.y += 1
          mark
        elsif self.direction == 180
          self.y += 1
          mark
        elsif self.direction == 225
          self.x -= 1
          self.y += 1
          mark
        elsif self.direction == 270
          self.x -= 1
          mark
        elsif self.direction == 315
          self.x -= 1
          self.y -= 1
          mark
        end
      end
    elsif c == 'RT'
      self.direction += value
    end
  end

  def mark
    unless (0..self.size-1).include?(self.x) && (0..self.size-1).include?(self.y)
      raise "Out of bounds: attempting to reach x=#{self.x} y=#{self.y} but allowable range=[0..#{self.size-1}]" 
    end

    self.canvas[self.y][self.x] = MARK
  end

  def clear
    self.canvas.map!{ |y| y.map{ |x| x = '.' } }
  end

  def draw
    output = self.canvas.map{ |a| a.join(' ') }.join("\n") << "\n"
    output
  end
end
