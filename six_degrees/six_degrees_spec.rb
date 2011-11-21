require 'ruby-debug'
require './six_degrees'

# remove user if zero connections
#

describe SixDegrees do
  describe ".levels(params)" do
    it 'works with filename param' do
      result =<<EOS
alberta
bob, christie
duncan, emily
farid

bob
alberta, christie, duncan
emily, farid

christie
alberta, bob, emily
duncan
farid

duncan
bob, emily, farid
alberta, christie

emily
christie, duncan
alberta, bob, farid

farid
duncan
bob, emily
alberta, christie
EOS
      SixDegrees.levels(:filename => 'sample_input.txt').should == result
    end

    it 'works with text' do
      text =<<EOS
alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books."
bob: "They impress us ever with the conviction that one nature wrote and the same reads." /cc @alberta
alberta: hey @christie. what will we be reading at the book club meeting tonight?
christie: 'Every day, men and women, conversing, beholding and beholden.' /cc @alberta, @bob
bob: @duncan, @christie so I see it is Emerson tonight
duncan: We'll also discuss Emerson's friendship with Walt Whitman /cc @bob
alberta: @duncan, hope you're bringing those peanut butter chocolate cookies again :D
emily: Unfortunately, I won't be able to make it this time /cc @duncan
duncan: @emily, oh what a pity. I'll fill you in next week.
christie: @emily, "Books are the best of things, well used; abused, among the worst." -- Emerson
emily: Ain't that the truth ... /cc @christie
duncan: hey @farid, can you pick up some of those cookies on your way home?
farid: @duncan, might have to work late tonight, but I'll try and get away if I can
EOS
      result =<<EOS
alberta
bob, christie
duncan, emily
farid

bob
alberta, christie, duncan
emily, farid

christie
alberta, bob, emily
duncan
farid

duncan
bob, emily, farid
alberta, christie

emily
christie, duncan
alberta, bob, farid

farid
duncan
bob, emily
alberta, christie
EOS
      SixDegrees.levels(:text => text).should == result
    end
  end

  describe ".connect" do
    it 'raises error if no text specified' do
      expect do
        SixDegrees.connect()
      end.should raise_error
    end

    it 'works with text param' do
      text =<<EOS
alberta: @bob "It is remarkable, the character of the pleasure we derive from the best books."
bob: "They impress us ever with the conviction that one nature wrote and the same reads." /cc @alberta
alberta: hey @christie. what will we be reading at the book club meeting tonight?
christie: 'Every day, men and women, conversing, beholding and beholden.' /cc @alberta, @bob
bob: @duncan, @christie so I see it is Emerson tonight
duncan: We'll also discuss Emerson's friendship with Walt Whitman /cc @bob
alberta: @duncan, hope you're bringing those peanut butter chocolate cookies again :D
emily: Unfortunately, I won't be able to make it this time /cc @duncan
duncan: @emily, oh what a pity. I'll fill you in next week.
christie: @emily, "Books are the best of things, well used; abused, among the worst." -- Emerson
emily: Ain't that the truth ... /cc @christie
duncan: hey @farid, can you pick up some of those cookies on your way home?
farid: @duncan, might have to work late tonight, but I'll try and get away if I can
EOS
      result = { 'alberta'  => ['bob', 'christie', 'duncan'], 
                 'bob'      => ['alberta', 'christie', 'duncan'], 
                 'christie' => ['alberta', 'bob', 'emily'], 
                 'duncan'   => ['bob', 'emily', 'farid'], 
                 'emily'    => ['christie', 'duncan'], 
                 'farid'    => ['duncan'] }
      SixDegrees.connect(text).should == result
    end

    it 'mentioned names are sorted' do
      text =<<EOS
alberta: @christie @bob what up
bob: hello @alberta
christie: @alberta hi
EOS
      result = {"alberta"=>["bob", "christie"], "christie"=>["alberta"], "bob"=>["alberta"]}
      SixDegrees.connect(text).should == result
    end

    it 'does not insert dupe names' do
      text =<<EOS
alberta: @christie @bob what up
alberta: @christie @bob what up
bob: hello @alberta
christie: @alberta hi
EOS
      result = {"alberta"=>["bob", "christie"], "christie"=>["alberta"], "bob"=>["alberta"]}
      SixDegrees.connect(text).should == result
    end

    it 'ignore tweets with no mentioned users' do
      text =<<EOS
alberta: @christie @bob what up
bob: hello
christie: @alberta hi
EOS
      result = {"alberta"=>["bob", "christie"], "christie"=>["alberta"] }
      SixDegrees.connect(text).should == result
    end
  end

  describe ".remove_noise" do
    it 'only direct connections remain' do
      input  = { 'alberta'  => ['bob', 'christie', 'duncan'], 
                 'bob'      => ['alberta', 'christie', 'duncan'], 
                 'christie' => ['alberta', 'bob', 'emily'], 
                 'duncan'   => ['bob', 'emily', 'farid'], 
                 'emily'    => ['christie', 'duncan'], 
                 'farid'    => ['duncan'] }

      result = { 'alberta'  => ['bob', 'christie'], 
                 'bob'      => ['alberta', 'christie', 'duncan'], 
                 'christie' => ['alberta', 'bob', 'emily'], 
                 'duncan'   => ['bob', 'emily', 'farid'], 
                 'emily'    => ['christie', 'duncan'], 
                 'farid'    => ['duncan'] }
      SixDegrees.remove_noise(input).should == result
    end

    it 'only direct connections remain' do
      input  = { 'alberta'  => ['christie'], 
                 'bob'      => ['alberta', 'christie'],
                 'christie' => ['alberta'] }

      result = { 'alberta'  => ['christie'], 
                 'christie' => ['alberta'] }
      SixDegrees.remove_noise(input).should == result
    end

    it 'remove if mentioned only one way' do
        input  = { 'alberta'  => ['bob', 'christie'], 
                   'bob'      => ['alberta'] }

        result = { 'alberta'  => ['bob'], 
                   'bob' => ['alberta'] }
        SixDegrees.remove_noise(input).should == result
    end

    it 'remove author if never mentioned' do
        input  = { 'alberta'  => ['bob'], 
                   'bob'      => ['alberta'],
                   'duncan'   => ['farid'] }

        result = { 'alberta'  => ['bob'], 
                   'bob' => ['alberta'] }
        SixDegrees.remove_noise(input).should == result
    end
  end
end
