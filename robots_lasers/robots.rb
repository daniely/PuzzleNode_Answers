require 'ruby-debug'

class Robots
  def directions(scenario)
    directions = "GO WEST"
    north, belt, south = scenario
    clicks = belt.split('').count
    pos = belt.index('X')

    n_fire_at, s_fire_at = find_fire_at(belt)

    # north damage
    n_lasers = north.split('').map{ |n| n == '|' ? 1 : 0 }
    # bitwise AND to find when robot will take damage
    n_damage = n_lasers.join.to_i(2) & n_fire_at.join.to_i(2)
    n_damage = n_damage.to_s(2).split('').map{ |n| n.to_i }
    # left pad with zeros
    (clicks - n_damage.count).times { n_damage.insert(0, 0) }

    # south damage
    s_lasers = south.split('').map{ |s| s == '|' ? 1 : 0 }
    # bitwise AND to find when robot will take damage
    s_damage = s_lasers.join.to_i(2) & s_fire_at.join.to_i(2)
    s_damage = s_damage.to_s(2).split('').map{ |s| s.to_i }
    # left pad with zeros
    (clicks - s_damage.count).times { s_damage.insert(0, 0) }

    west_damage = n_damage[0..pos].count(1) + s_damage[0..pos].count(1)
    east_damage = n_damage[pos..clicks].count(1) + s_damage[pos..clicks].count(1)

    directions = "GO EAST" if west_damage > east_damage

    directions
  end

  def find_fire_at(p)
    toggle = 1
    toggle = 0 if p.index('X').even?

    north_fire = Array.new(p.size).each_with_index.map { |a, i| a = (i + toggle).even? ? 1 : 0 }
    [north_fire, north_fire.reverse]
  end
end
