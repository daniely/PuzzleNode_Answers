require 'ruby-debug'

class Turtle
  attr_accessor :size, :position, :canvas
  MARK = 'X'

  def initialize(size)
    self.size = size
    self.canvas = Array.new(size){ ['.'] * size }
    mid = self.size / 2
    # start turtle in middle of canvas
    position(mid, mid)
  end

  def position(x, y)
    self.canvas[y][x] = MARK
  end

  def draw
    output = self.canvas.map{ |a| a.join(' ') }.join("\n") << "\n"
    output
  end
end
