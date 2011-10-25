describe "command line attempt" do
  it 'runs from the command line' do
    #system('cat ./samples/sample-input.txt | ruby robot.rb > ./samples/sample-output.txt')
  end

  it 'outputs to console' do
    system('cat ./samples/sample-input.txt | ruby robot.rb')
  end
end
