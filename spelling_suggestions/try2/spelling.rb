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

  private

  def longest(c, a)
    check = c.split('')
    against = a.split('')

    result = []

    check.each do |ch|
      while(match_letter = against.shift) do
        if match_letter == ch
          result << ch
          break
        end
      end
    end

    result.join
  end
end
