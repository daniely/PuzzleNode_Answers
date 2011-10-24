require './turtle'

describe Turtle do
  before(:all) do
    #override stdout
    #$stdout = String.IO.new
  end

  describe "#new" do
    it 'create canvas with turtle in middle' do
      output =<<-EOS
. . .
. X .
. . .
EOS
      t = Turtle.new(3)
      t.draw.should == output
    end
  end
end
