require 'json_canvas'
require 'find'

def create_file_tree(directory)
  jc = JsonCanvas.create
  root = jc.add_text(id: "root", x: 0, y: 0, width: 200, height: 50, text: File.basename(directory), color: "2")

  nodes = { directory => { node: root, x: 0, y: 0 } }
  level_spacing = 100
  sibling_spacing = 50

  Find.find(directory) do |path|
    next if path == directory || path.include?("/.git") || File.basename(path) == ".git"

    parent_dir = File.dirname(path)
    parent_info = nodes[parent_dir]
    parent_node = parent_info[:node]

    x = parent_info[:x] + sibling_spacing
    y = parent_info[:y] + level_spacing

    if File.directory?(path)
      dir_node = jc.add_text(id: path, x: x, y: y, width: 200, height: 50, text: File.basename(path), color: "3")
      nodes[path] = { node: dir_node, x: x, y: y }
      jc.add_edge(fromNode: parent_node.id, toNode: dir_node.id)
    else
      file_node = jc.add_text(id: path, x: x, y: y, width: 200, height: 50, text: File.basename(path), color: "4")
      jc.add_edge(fromNode: parent_node.id, toNode: file_node.id)
    end

    # Adjust parent coordinates for the next sibling
    parent_info[:x] = x
    parent_info[:y] = [parent_info[:y], y + sibling_spacing].max
  end

  jc
end

def save_canvas(jc, filename)
  jc.save(filename)
end

directory = ARGV[0] || "."
output_file = ARGV[1] || "file_tree.canvas"

jc = create_file_tree(directory)
save_canvas(jc, output_file)

puts "File tree saved to #{output_file}"
