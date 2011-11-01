require 'ruby-debug'

class Spelling
  def closest_match(c, o1, o2)
    check = c.split('')
    option1 = o1.split('')
    option2 = o2.split('')

    # loop through all ranges of combos
    c = check.each_index.map{ |i| check.combination(i).to_a.uniq }[1..-1]
    option1 = option1.each_index.map{ |i| option1.combination(i).to_a.uniq }[1..-1]
    option2 = option2.each_index.map{ |i| option2.combination(i).to_a.uniq }[1..-1]

    # find longest substring
    longest_option1 = 0
    longest_option2 = 0

    c.each_index do |i|
      break if c[i].nil? or option1[i].nil?
      longest_option1 = i unless (c[i] & option1[i]).empty?
    end

    c.each_index do |i|
      break if c[i].nil? or option2[i].nil?
      longest_option2 = i unless (c[i] & option2[i]).empty?
    end

    # return the longest
    if longest_option1 > longest_option2
      o1
    else
      o2
    end
  end
end
