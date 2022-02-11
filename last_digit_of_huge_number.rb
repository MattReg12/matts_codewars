=begin
3 Kyu
For a given list [x1, x2, x3, ..., xn] compute the last (decimal) digit of x1 ^ (x2 ^ (x3 ^ (... ^ xn))).

E. g.,

last_digit({3, 4, 2}, 3) == 1
because 3 ^ (4 ^ 2) = 3 ^ 16 = 43046721.

Beware: powers grow incredibly fast. For example, 9 ^ (9 ^ 9) has more than 369 millions of digits. lastDigit has to deal with such numbers efficiently.

Corner cases: we assume that 0 ^ 0 = 1 and that lastDigit of an empty list equals to 1.

This kata generalizes Last digit of a large number; you may find useful to solve it beforehand.
=end

def last_digit(lst)
  return 1 if lst.empty?
  return lst[-1].digits.first if lst.size == 1
  list = lst.map { |number| number.to_s.size > 3 ? number.to_s[-2..-1].to_i : number }
  until list.size <= 2
    list[-2] = (list[-2] ** list.last).divmod(1000).last
    list.pop
  end
  list[1] = 4 if lst[1].positive? && lst[1].digits.first.zero?
  x = list.last.divmod(4).last.zero? && list.last > 0 ? list.first ** 4 : list.first ** list.last.divmod(4).last
  x.to_s[-1].to_i
end

