require 'json_canvas'
require 'fileutils'

def add_node(canvas, path, depth, y_position, is_directory)
  name = File.basename(path)
  x_position = depth * 300
  color = is_directory ? '3' : ''
  node = canvas.add_text(id: path, x: x_position, y: y_position, text: name, color: color)
  node
end

def add_edge(canvas, parent_node, child_node)
  canvas.add_edge(fromNode: parent_node.id, toNode: child_node.id)
end

def explore_directory(canvas, root_node, dir_path, depth = 0, y_position = 0)
  entries = Dir.entries(dir_path).reject { |entry| entry == '.' || entry == '..' || entry == '.git' }
  previous_sibling_max_y = y_position

  entries.each do |entry|
    entry_path = File.join(dir_path, entry)
    is_directory = File.directory?(entry_path)
    current_node = add_node(canvas, entry_path, depth, previous_sibling_max_y, is_directory)

    if depth > 1
      parent_path = File.dirname(entry_path)
      parent_node = canvas.nodes.find { |node| node.id == parent_path }
      add_edge(canvas, parent_node, current_node) if parent_node
    elsif depth == 1
      add_edge(canvas, root_node, current_node)
    end

    if is_directory
      child_y_position = previous_sibling_max_y + 80
      previous_sibling_max_y = explore_directory(canvas, root_node, entry_path, depth + 1, child_y_position)
    end

    previous_sibling_max_y += 80
  end

  previous_sibling_max_y
end

# メインスクリプト
def generate_file_tree(dir_path)
  jc = JsonCanvas.create
  root_node = add_node(jc, dir_path, 0, 0, true)
  explore_directory(jc, root_node, dir_path, 1, 100)
  jc.save("file_tree.canvas")
  puts "File tree saved to file_tree.canvas"
end

# コマンドライン引数からディレクトリパスを取得
if ARGV.length != 1
  puts "Usage: ruby script.rb <directory_path>"
  exit 1
end

directory_path = ARGV[0]
generate_file_tree(directory_path)
