require './spelling'

describe "simple case" do
  #it 'finds longest substring' do
    #check   = "numm"
    #option1 = "nom"
    #option2 = "numb"

    #s = Spelling.new
    #s.closest_match(check, option1, option2).should == option2
  #end

  #it 'finds longest substring' do
    #check   = "remimance"
    #option1 = "remembrance"
    #option2 = "reminiscence"

    #s = Spelling.new
    #s.closest_match(check, option1, option2).should == option1
  #end

  it 'finds longest substring' do
    check   = "nenhundertennunndneunzig"
    option1 = "neunhunderteinundneunzig"
    option2 = "einhundertneunundneunzig"
    s = Spelling.new
    s.closest_match(check, option1, option2).should == option1
  end
end

#describe "from files" do
  #it 'run on sample files' do
    #word_groups = []

    #File.open('./samples/INPUT.txt', 'r') do |f|
      #word_groups = f.read.split("\n\n")
      #word_groups = word_groups[1..-1]
    #end

    #s = Spelling.new
    #word_groups.each do |word_group|
      #words = word_group.split("\n")
      #p s.closest_match(words[0], words[1], words[2])
    #end
  #end
#end
