def bubble_sort arr
  return arr if arr.size <= 1

  swapped = true
  while swapped
    swapped = false
    0.upto(arr.size - 2) do |i|
      if arr[i] > arr[i+1]
        arr[i], arr[i+1] = arr[i+1], arr[i]
        swapped = true
      end
    end
  end

  arr
end

numbers = [4, 5, 48, 1, 6, 4]
p bubble_sort numbers

def bubble_sort_by arr
  return arr if arr.size <= 1

  swapped = true
  while swapped
    swapped = false
    0.upto(arr.size - 2) do |i|
      if yield(arr[i], arr[i+1]) > 0
        arr[i], arr[i+1] = arr[i+1], arr[i]
        swapped = true
      end
    end
  end

  arr
end

arr = bubble_sort_by(["hi", "hello", "hey", "goodbye"]) do |left, right|
  left.length - right.length
end
p arr
