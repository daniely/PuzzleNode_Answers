describe "command line attempt" do
  it 'runs from the command line' do
    #system('cat ./samples/sample-input.txt | ruby robot.rb > ./samples/sample-output.txt')
  end

  it 'outputs to console' do
    system('cat ./samples/sample-input.txt | ruby robot.rb')
  end
end

describe "find lasers that will fire on north side" do
  it "end up with '#|#|#|##'" do
    n = "#|#|#|##"
    p = "---X----"
    s = "###||###"

    north = n.split('')
    south = s.split('')
    position = p.index('X')
    toggle = position.even?

    north.map!.each_with_index{ |v, i| v = (i.even? ^ !toggle) && (v == '|') }
    south.map!.each_with_index{ |v, i| v = (i.even? ^ toggle) && (v == '|') }

    west = north[0..position].count(true) + south[0..position].count(true)
    east = north[position..-1].count(true) + south[position..-1].count(true)
    p west
    p east
  end
end
