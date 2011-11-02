require 'ruby-debug'

class Spelling

  def closest_match(c, o1, o2)
    a = longest(c, o1)
    b = longest(c, o2)

    if longest(c, o1) > longest(c, o2)
      o1
    else
      o2
    end
  end

  # find leftmost matching pair
  def leftmost(c, a)
    matches = []

    # x = "a b c d f"
    # y = "b b a d c"
    # matches are
    # [0,2]a, [1,1]b, [2,4]c ...
    c.each_with_index do |x, xi|
      a.each_with_index do |y, yi|
        if x == y
          matches << [xi, yi]
        end
      end
    end

    l_pair = matches.sort{ |x,y| x.max <=> y.max }.first

    x = c[l_pair.first..-1]
    y = a[l_pair.last..-1]
    x.shift
    y.shift

    [c[l_pair.first], x, y]
  end

  private

  def longest(c, a)
    check = c.split('')
    against = a.split('')

    result = []

    while true do
      check_first = check.shift
      against_first = against.shift

      if (check.empty? || against.empty?)
        return result.join
      elsif check_first == against_first
        result << check_first
      else
        # find leftmost match
        r, check, against = leftmost(check, against)
        result << r
      end
    end
  end
end
