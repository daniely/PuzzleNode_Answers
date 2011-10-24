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

    if c == 'FD'
      value.to_i.times do
        if self.direction == 0
          self.y -= 1
          mark
        elsif self.direction == 180
          self.y += 1
          mark
        end
      end
    elsif c == 'RT'
      self.direction += value.to_i
    end
  end

  def mark
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
