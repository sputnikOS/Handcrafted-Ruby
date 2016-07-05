  def fib(n)
    return 1 if n <= 2

    fib_index = 3
    a, b = 1, 1

    while fib_index <= n
      c = a + b
      a = b
      b = c
      fib_index += 1
    end
    c
  end

p (1..10).map {|i| fib(i)}
p (1..10).inject {|sum, i| sum + fib(i)}

# Alternate Method Using Recursion
  def fibonacci(n)
    return  n  if n <= 1
    fibonacci(n - 1) + fibonacci(n - 2)
  end

p ( 1..10 ).map {|i| fibonacci(i)}
p ( 1..10 ).inject {|sum, i| sum + fibonacci(i)}