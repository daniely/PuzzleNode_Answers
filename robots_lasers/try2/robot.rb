require 'ruby-debug'

STDIN.read.split("\n\n").each do |scenario|
  n, p, s= scenario.split("\n")

  north = n.split('')
  south = s.split('')
  position = p.index('X')
  toggle = position.even?

  north.map!.each_with_index{ |v, i| v = (i.even? ^ !toggle) && (v == '|') }
  south.map!.each_with_index{ |v, i| v = (i.even? ^ toggle) && (v == '|') }

  west = north[0..position].count(true) + south[0..position].count(true)
  east = north[position..-1].count(true) + south[position..-1].count(true)

  if west > east
    puts "GO EAST"
  else
    puts "GO WEST"
  end
end
