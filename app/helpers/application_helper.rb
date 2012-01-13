module ApplicationHelper
  def number_to_ordinal(num)
    num = num.to_i
    if (10...20)===num
      "#{num}th"
    else
      g = %w{ th st nd rd th th th th th th }
      a = num.to_s
      c=a[-1..-1].to_i
      a + g[c]
    end
  end
end
