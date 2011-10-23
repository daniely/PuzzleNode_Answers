require './robots'

describe "Robot and Lasers Puzzle" do
  it 'create directions for robots' do
    scenario = ["#|#|#|##", "---X----", "###||###"]
    r = Robots.new
    r.directions(scenario).should == "GO WEST"
  end
end

describe Robots do
  let(:r) { Robots.new }

  describe "#find_fire_at" do
    it 'sets north/south fire array starting with odd' do
      p = "-X------"
      r.find_fire_at(p).should == [[0, 1, 0, 1, 0, 1, 0, 1], [1, 0, 1, 0, 1, 0, 1, 0]]
    end

    it 'sets north/south fire array starting with even' do
      p = "X-------"
      r.find_fire_at(p).should == [[1, 0, 1, 0, 1, 0, 1, 0], [0, 1, 0, 1, 0, 1, 0, 1]]
    end
  end
end
