require 'ruby-debug'

module SixDegrees
  extend self

  def levels(params)
    if params.has_key?(:text) == false && params.has_key?(:filename) == false
      raise "specify a filename or some text"
    end

    filename = params[:filename]
    text = params[:text]

    if filename
      text = File.read(filename)
    end

    c = connect(text)
    c = remove_noise(c)
    c = Hash[c.sort]

    result = ''

    c.each do |k, v|
      levels = bfs(c, k)
      debugger if k == 'leta'
      
      (0..levels.values.max).each do |i|
        names = []
        levels.select{|k, v| v == i}.each { |n| names << n.first }
        result += "#{names.sort.join(', ')}\n"
      end
      result = "#{result}\n"
    end

    result.chomp!

    #if filename
      #File.open("rose_#{filename}", 'w') do |outfile|
        #outfile.write result
      #end
    #end

    result
  end

  def connect(text)
    connections = {}

    text.each_line do |line|
      author = line[0..line.index(': ')-1]
      mentioned = line.scan(/@(\w+)/)
      # append only uniques
      connections[author] = connections[author] ? connections[author] | mentioned.flatten : mentioned.flatten
    end

    # sort mentioned users
    connections.map{ |k,v| v.sort! }
    connections
  end

  def remove_noise(connections)
    connections.each do |k, v|
      # remove one way connections
      v.delete_if { |i| connections[i].nil? || !connections[i].include?(k) }
    end

    connections
  end

  def bfs(graph, start)
    queue = [start]
    visited = [start]
    levels = { start => 0 }

    until queue.empty?
      node = queue.shift

      graph[node].each do |child|
        unless visited.include?(child)
          levels[child] = levels[node] + 1
          queue.push(child)
          visited << child
        end
      end unless graph[node].nil?
    end

    levels
  end
end
