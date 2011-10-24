require 'ruby-debug'

scenarios = STDIN.read.split("\n\n")
scenarios.each do |scenario|
  p scenario.split("\n")
end
