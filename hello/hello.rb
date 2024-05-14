require 'json_canvas'

# Create a new canvas
jc = JsonCanvas.create

# Add text nodes
hello_node = jc.add_text(id: "HELLO", x: 100, y: 100, width: 200, height: 50, text: "HELLO")
world_node = jc.add_text(id: "WORLD", x: 400, y: 300, width: 200, height: 50, text: "WORLD", color: "1")

# Add an edge to connect the nodes
jc.add_edge(id: "hello_to_world", fromNode: hello_node.id, toNode: world_node.id, fromSide: "right", toSide: "left", color: "2", label: "to")

# Save the canvas to a file
jc.save("hello.canvas")

# Load the canvas from the "hello_world.canvas" file
loaded_canvas = JsonCanvas.parse(File.read("hello.canvas"))

# Output the loaded canvas as a JSON string
puts loaded_canvas.to_json
