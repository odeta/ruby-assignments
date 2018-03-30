def caesar_cipher(string, shift)
  result_char_array = string.split("").collect do |c|
    if(c.ord >= 'a'.ord)
      'a'.ord + ((c.ord - 'a'.ord + shift) % 26)
    elsif(c.ord >= 'A'.ord)
      'A'.ord + ((c.ord - 'A'.ord + shift) % 26)
    else
      c.ord
    end
  end.collect { |c| c.chr }.join
end

puts caesar_cipher("What a string!", 5)
