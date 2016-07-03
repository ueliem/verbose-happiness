import math

class Node:
	def __init__(self, nodeid, position):
		self.nodeid = ""
		self.position = position

class OutputTerminal(Node):
	pass

class InputTerminal(Node):
	pass

class DirectedGraph():
	def __init__(self, width, height):
		self.nodes = {}
		self.edges = []
		self.numRows = height
		self.numCols = width
	def addNode(self, nodeid, node):
		self.nodes[nodeid] = node
	def removeNode(self):
		if nodeid in self.nodes:
			del self.nodes[nodeid]
	def updateNode(self, nodeid):
		pass
	def getNode(self, nodeid):
		if nodeid in self.nodes:
			return self.nodes[nodeid]
		else:
			return None
	def addEdge(self, u, v):
		self.edges.append((u,v))
	def removeEdge(self):
		pass
	def getEdges(self, vid):
		edges = []
		for edge in self.edges:
			if edge[0] == vid or edge[1] == vid:
				edges.append(edge)
		return edges
	def getNeighbors(self, nodeid):
		neighbors = []
		if nodeid in self.nodes:
			for edge in self.edges:
				if edge[0] == nodeid:
					neighbors.append(edge[1])
			return neighbors
		return None
	def getRoutingDistance(self):
		acc = 0
		for (uid,vid) in self.edges:
			if self.getNode(uid).position == None:
				continue
			elif self.getNode(vid).position == None:
				continue
			(ux,uy) = self.getNode(uid).position
			(vx,vy) = self.getNode(vid).position
			dist = math.sqrt((ux - vx)**2 + (uy - vy)**2)
			acc = acc + dist
		return acc
	def getManhattanDistance(self):
		acc = 0
		for (uid,vid) in self.edges:
			if self.getNode(uid).position == None:
				continue
			elif self.getNode(vid).position == None:
				continue
			(ux,uy) = self.getNode(uid).position
			(vx,vy) = self.getNode(vid).position
			distx = abs(ux - vx)
			disty = abs(uy - vy)
			acc = acc + distx + disty
		return acc
	def initialPlacement(self):
		pass
	def renderPlacement(self):
		# Preallocate the 2d grid/graph
		rows = [['.']*self.numCols for _ in range(0,self.numRows)]

		# Draw the edges
		for (uid,vid) in self.edges:
			if self.getNode(uid).position == None:
				continue
			elif self.getNode(vid).position == None:
				continue
			(ux,uy) = self.getNode(uid).position
			(vx,vy) = self.getNode(vid).position
			# Draw the vertical line from uy to vy along vx
			for i in range(0, abs(vy-uy)+1):
				rows[uy+i][vx] = '*'
			# Draw the horizontal line from ux to vx along uy
			for i in range(0, abs(vx-ux)+1):
				rows[uy][ux+i] = '*'

		# Get each node and place it on the graph
		unplacedNodeCount = 0
		for (nodeid,node) in self.nodes.iteritems():
			if node.position == None:
				unplacedNodeCount = unplacedNodeCount + 1
			else:
				nx = node.position[0]
				ny = node.position[1]
				(rows[ny])[nx] = renderNode(node)

		# Print each row
		for row in reversed(rows):
			print "".join(row)
		print "Unplaced Nodes: " + str(unplacedNodeCount)

def renderNode(n):
	if n == None:
		return '.'
	elif isinstance(n, InputTerminal):
		return 'I'
	elif isinstance(n, OutputTerminal):
		return 'O'
	else:
		return '#'

