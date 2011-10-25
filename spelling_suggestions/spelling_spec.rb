require './spelling'

describe "simple case" do
  it 'finds longest substring' do
    a = "nom"
    b = "numm"
    s = Spelling.new
    s.longest(a, b).should == 'nm'
  end
end
