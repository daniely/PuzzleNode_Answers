require 'ruby-debug'

module SixDegrees
  extend self

  def levels(params)
    filename = params[:filename]
    text = params[:text]

    raise "specify a filename or some text" if filename.nil? && text.nil?

    text = File.read(filename) if filename

    c = connect(text)
    c = remove_noise(c)
    # sort first level names
    c = Hash[c.sort]

    result = ''

    c.each do |k, v|
      levels = bfs(c, k)
      
      (0..levels.values.max).each do |i|
        names = []
        levels.select{|k, v| v == i}.each { |n| names << n.first }
        # sort names within subgroups
        result += "#{names.sort.join(', ')}\n"
      end
      result = "#{result}\n"
    end

    result.chomp
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
