class GraphNode
  attr_accessor :value, :nodes, :coords

  def initialize(value, coords)
    @value = value
    @coords = coords
    @nodes = []
  end

  def add_edge(node)
    @nodes << node
  end
end
