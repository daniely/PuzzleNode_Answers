require 'ruby-debug'

class Turtle
  attr_accessor :file, :size, :position, :canvas
  MARK = 'X'

  def initialize(file)
    self.file = file

    File.open(file, 'r') do |f|
      # first 2 lines are for the size
      self.size = f.gets.chop.to_i
      f.gets

      self.canvas = []
      self.canvas = Array.new(size){ ['.'] * size }

      mid = self.size / 2
      position(mid, mid)
      position(1, 2)

      while instructions = f.gets do
        #self.canvas << instructions.chop
      end

      # output canvas
      self.canvas.each do |a|
        p a.join(' ')
      end
    end
  end

  def position(x, y)
    self.canvas[y][x] = MARK
  end
end
