require 'ruby-debug'

module SixDegrees
  extend self

  def connect(params)
    if params.has_key?(:text) == false && params.has_key?(:filename) == false
      raise "specify a filename or some text"
    end

    filename = params[:filename]
    text = params[:text]

    connections = {}

    if filename
      text = File.read(filename)
    end

    text.each_line do |line|
      author = line[0..line.index(': ')-1]
      mentioned = line.scan(/@(\w+)/)
      next if mentioned.empty?
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

    # remove users with no connections
    connections.reject!{ |k,v| v.empty? }
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
