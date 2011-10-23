require 'ruby-debug'

class Robots
  def directions(scenario)
    directions = "GO WEST"
    n_lasers, belt, s_lasers = scenario
    clicks = belt.split('').count
    pos = belt.index('X')

    n_fire_at, s_fire_at = find_fire_at(belt)

    n_damage_at = find_damage_at(n_lasers, n_fire_at, clicks)
    s_damage_at = find_damage_at(s_lasers, s_fire_at, clicks)

    west_damage = n_damage_at[0..pos].count(1) + s_damage_at[0..pos].count(1)
    east_damage = n_damage_at[pos..clicks].count(1) + s_damage_at[pos..clicks].count(1)

    directions = "GO EAST" if west_damage > east_damage

    directions
  end

  def find_damage_at(lasers, fire_at, clicks)
    lasers = lasers.split('').map{ |l| l == '|' ? 1 : 0 }
    # bitwise AND to find when lasers will fire
    damage_at = lasers.join.to_i(2) & fire_at.join.to_i(2)
    damage_at = damage_at.to_s(2).split('').map{ |n| n.to_i }
    # left pad with zeros
    (clicks - damage_at.count).times { damage_at.insert(0, 0) }

    damage_at
  end

  def find_fire_at(p)
    toggle = 1
    toggle = 0 if p.index('X').even?

    north_fire = Array.new(p.size).each_with_index.map { |a, i| a = (i + toggle).even? ? 1 : 0 }
    [north_fire, north_fire.reverse]
  end
end
