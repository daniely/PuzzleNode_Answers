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

    start_search_from = 0
    result = []

    check.each do |ch|
      leftover = against[start_search_from..-1]
      break if start_search_from == against.length
      start_search_from += 1

      leftover.each do |lo|
        if lo == ch
          result << ch
          break
        end
      end
    end

    result.join
  end
end
