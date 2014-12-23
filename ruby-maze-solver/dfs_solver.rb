require_relative 'graph_node'

class Solver
  attr_reader :maze_hash, :maze_start

  def initialize
    @mode = ARGV[1] || "dfs"
    @steps = 1
    @maze_hash = load_maze
    @maze_start = @maze_hash["00"]
    build_maze_graph
  end

  def solve
    puts solvable? ? "Solvable" : "Unsolvable"
  end

  def solvable?
    explored = []
    unexplored = @maze_start.nodes

    until unexplored.empty?
      current_node = @mode == "dfs" ? unexplored.pop : unexplored.shift
      explored << current_node

      if current_node.value == "*"
        update_position(current_node)
        return true
      end

      update_position(current_node)

      nodes = @mode == "dfs" ? order(current_node.nodes) : current_node.nodes
      nodes.each do |node|
        unless explored.include?(node)
          unexplored << node
        end
      end
    end
    false
  end

  def order(nodes)
    first = nodes.group_by { |node| node.coords[0].to_i }
    second = first.sort_by(&:first).reverse.map(&:last)
    second.map { |set| set.sort_by { |node| node.coords[1].to_i } }.flatten.reverse
  end

  def load_maze
    maze_array = []
    file = File.open(ARGV[0], "r")
    file.each_line { |line| maze_array << line.chomp }

    maze_hash = {}
    maze_array.each_with_index do |row, y|
      row.chars.each_with_index do |tile, x|
        coords = "#{x}#{y}"
        maze_hash[coords] = GraphNode.new(tile, coords)
      end
    end
    maze_hash
  end

  def build_maze_graph
    @maze_hash.each do |pXY, parent|
      @maze_hash.each do |cXY, child|
        unless parent == child
          parent.add_edge(child) if valid_edge?(parent, child)
        end
      end
    end
  end

  def valid_edge?(parent, child)
    not_edge?(parent, child) &&
    adjacent?(parent, child) &&
    (child.value == "." || child.value == "*")
  end

  def not_edge?(parent, child)
    !parent.nodes.include?(child)
  end

  def adjacent?(parent, child)
    parentX = parent.coords[0].to_i
    parentY = parent.coords[1].to_i
    childX = child.coords[0].to_i
    childY = child.coords[1].to_i

    (parentX - childX).abs == 1 && (parentY - childY).abs == 0 ||
    (parentX - childX).abs == 0 && (parentY - childY).abs == 1
  end

  def update_position(current_tile)
    @maze_hash[current_tile.coords].value = "x"
    @steps += 1
    print_maze
  end

  def print_maze
    print "\e[2J\e[f"
    row = ""
    @maze_hash.each do |coord, tile|
      if coord[0] == "9"
        row += tile.value
        puts row
        row = ""
      else
        row += tile.value
      end
    end
    puts "Steps: #{@steps}"
    sleep 0.2
  end
end

Solver.new.solve
