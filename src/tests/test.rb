#update from eclipse

#committing to bitbucket with eGit on eclipse
#commit any changes locally that are made by right clicking commit 
# on the file viewer on the left (and add a message).
#when you want to push all of your changes to bitbucket do team/remote/push
#enter the uri as https://bitbucket.org/capturetheflag/capturetheflag.git
#choose head for both of the top two things.
#click update all
#click finish


class Test
  def self.factorial(n)
    if n == 1 || n == 0
      return 1
    else
      return n * factorial(n - 1)
    end
  end
end

puts Test.factorial(10);

puts "Hello with newline\n character"
puts "I am such a noob with ruby"
puts "1 2 3 4"