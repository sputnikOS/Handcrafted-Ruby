# The two following methods calculate the first ten integers in the Fibonacci sequence,
# and then prints the sum of all of the integers. 

# Using Recursion
  def fibonacci(n)
    return  n  if n <= 1
    fibonacci(n - 1) + fibonacci(n - 2)
  end

  puts "Total: %i" %
         ((0..10).inject(0) do |t,i|
           f = fibonacci(i)
           puts "%s: %s" % [i.to_s.rjust(2), f.to_s.rjust(3)]
           t + f
         end)

# Without Recursion
#   def fib(n)
#     a = 0
#     b = 1
#
#     n.times do
#       temp = a
#       a = b
#       b = temp + b
#     end
#
#     return a
#   end
#
# puts "Total: %i" %
#          ((0..10).inject(0) do |t,i|
#            f = fib(i)
#            puts "%s: %s" % [i.to_s.rjust(2), f.to_s.rjust(3)]
#            t + f
#          end)
#

