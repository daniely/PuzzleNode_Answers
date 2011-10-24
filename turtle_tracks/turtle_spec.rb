require './turtle'

describe Turtle do
  let(:t3) { Turtle.new(3) }
  let(:t5) { Turtle.new(5) }

  describe "#new" do
    it 'create canvas with turtle in middle' do
      output =<<-EOS
. . .
. X .
. . .
EOS
      t3.draw.should == output
    end
  end

  describe ".clear" do
    it 'clears canvas while keeping size' do
      output =<<-EOS
. . .
. . .
. . .
EOS
      t3.clear
      t3.draw.should == output
    end
  end

  describe ".execute(FD 1)" do
    it 'draw while moving north one click' do
      output =<<-EOS
. X .
. X .
. . .
EOS
      t3.execute("FD 1")
      t3.draw.should == output
    end
  end

  describe ".execute(BK 1)" do
    it 'draw while moving south one click' do
      output =<<-EOS
. . .
. X .
. X .
EOS
      t3.execute("BK 1")
      t3.draw.should == output
    end
  end

  describe ".execute(FD 2)" do
    it 'draw while moving north two click' do
      output =<<-EOS
. . X . .
. . X . .
. . X . .
. . . . .
. . . . .
EOS
      t5.execute("FD 2")
      t5.draw.should == output
    end
  end

  describe ".execute(RT 180); .execute(FD 2)" do
    it 'draw while moving south two click' do
      output =<<-EOS
. . . . .
. . . . .
. . X . .
. . X . .
. . X . .
EOS
      t5.execute("RT 180")
      t5.execute("FD 2")
      t5.draw.should == output
    end
  end

  describe ".execute(RT 180); .execute(FD 1)" do
    it 'draw while moving south one click' do
      output =<<-EOS
. . .
. X .
. X .
EOS
      t3.execute("RT 180")
      t3.execute("FD 1")
      t3.draw.should == output
    end
  end

  describe ".execute(REPEAT 2 [ RT 90 FD 2 ]" do
    it 'can repeat instructions' do
      output =<<-EOS
. . . . .
. . . . .
. . X X X
. . . . X
. . . . X
EOS
      t5.execute("REPEAT 2 [ RT 90 FD 2 ]")
      t5.draw.should == output
    end
  end

  describe ".direction=" do
    it 'can not go above 360' do
      t3.direction = 270 + 90
      t3.direction.should == 0
    end

    it 'can not go below 0' do
      t3.direction = -90
      t3.direction.should == 270
    end
  end
end

#describe "run turtle with file of instructions" do
  #it 'creates drawing' do
    #file = './samples/complex.logo'

    #File.open(file, 'r') do |f|
      ## first 2 lines are for the size
      #size = f.gets.chop.to_i
      #f.gets

      #t = Turtle.new(size)

      #while instructions = f.gets do
        #t.execute(instructions)
      #end

      ##puts t.draw
      #File.open('./samples/complex_output.txt', 'w') do |o|
        #o.write t.draw
      #end
    #end
  #end
#end
