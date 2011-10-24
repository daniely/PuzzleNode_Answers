require './turtle'

describe Turtle do
  describe "#d" do
    it 'blah' do
      t = Turtle.new(9)
      t.draw
    end
  end
end

#describe "run turtle with file of instructions" do
  #it 'creates drawing' do
    #file = './samples/simple.logo'

    #File.open(file, 'r') do |f|
      ## first 2 lines are for the size
      #self.size = f.gets.chop.to_i
      #f.gets

      #self.canvas = []
      #self.canvas = Array.new(size){ ['.'] * size }

      #mid = self.size / 2
      #position(mid, mid)
      #position(1, 2)

      #while instructions = f.gets do
        ##self.canvas << instructions.chop
      #end

      ## output canvas
      #self.canvas.each do |a|
        #p a.join(' ')
      #end
    #end
  #end
#end
