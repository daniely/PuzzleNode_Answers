class Spelling
  def longest(a, b)
    a = a.split('')
    b = b.split('')

    a_combo = a.combination(2).to_a.uniq
    b_combo = b.combination(2).to_a.uniq

    (a_combo & b_combo).join
  end
end
