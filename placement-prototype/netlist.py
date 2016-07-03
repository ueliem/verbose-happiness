import math

class DirectedGraph():
	def __init__(self, nodes=[], edges=[]):
		self.nodes = nodes
		self.edges = edges
	def addNode(self, node):
		self.nodes.append(node)
	def removeNode(self, nodeid):
		if nodeid in self.nodes:
			del self.nodes[nodeid]
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
	def weightOfEdge(self, node1, node2):
		n1neighbors = self.getNeighbors(node1)
		n2neighbors = self.getNeighbors(node2)
		if node1 in n2neighbors or node2 in n2neighbors:
			return 1
		else:
			return 0

class Rect:
	def __init__(self, x, y, w, h):
		self.x = x
		self.y = y
		self.w = w
		self.h = h
	def bisectVertical(self):
		left = Rect(self.x, self.y,
				int(math.ceil(self.w/2.0)), self.h)
		right = Rect(self.x+int(math.ceil(self.w/2.0)), self.y,
				int(math.ceil(self.w/2.0)), self.h)
		return (left, right)
	def bisectHorizontal(self):
		bottom = Rect(self.x, self.y,
				self.w, int(math.ceil(self.h/2.0)))
		top = Rect(self.x, self.y+int(math.ceil(self.h/2)),
				self.w, int(math.ceil(self.h/2.0)))
		return (top, bottom)

