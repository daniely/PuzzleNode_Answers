require './robots'

describe "Robot and Lasers Puzzle" do
  context "given best path is west" do
    it 'tell robot go west' do
      scenario = ["#|#|#|##", "---X----", "###||###"]
      r = Robots.new
      r.directions(scenario).should == "GO WEST"
    end
  end

  context "given best path is east" do
    it 'tell robot go east' do
      scenario = ["##|#|#|#", "----X---", "###||###"]
      r = Robots.new
      r.directions(scenario).should == "GO EAST"
    end
  end

  context "given a short sample file with 3 scenarios" do
    it 'gives multiple directions' do
      out_text = ''
      File.open('./samples/sample-output.txt', 'r') do |outfile|
        out_text = outfile.read
      end
      input = File.readlines('./samples/sample-input.txt')
      input.map!{ |i| i.sub("\n",'') }.reject!{ |i| i.empty? }

      r = Robots.new
      directions = []

      input.each_slice(3) do |scenario|
        directions << "#{r.directions(scenario)}\n"
      end

      directions.join.should == out_text
    end
  end

  context "given a large sample file with many scenarios" do
    it 'create solution output file' do
      input = File.readlines('./samples/input.txt')
      input.map!{ |i| i.sub("\n",'') }.reject!{ |i| i.empty? }

      r = Robots.new
      directions = []

      input.each_slice(3) do |scenario|
        directions << "#{r.directions(scenario)}\n"
      end

      # uncomment to create another output solution file
      #File.open('./samples/output.txt', 'w') do |o|
        #o.write directions.join
      #end

      pending "don't have anything to test. just using this to create output solution file"
    end
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
