from netlist import *
import time

def placement(graph, grid):
	print str(len(graph.nodes)) + " " + str(graph.nodes)
	# if len(graph.nodes) == 1:
	if len(graph.nodes) < grid.w:
		print "Grid height: " + str(grid.h)
		# return graph
		return partition_row(graph, grid)
	(binA, binB) = partition_fm(graph)
	# time.sleep(1)
	(top, bottom) = grid.bisectHorizontal()
	t = placement(DirectedGraph(binB, graph.edges), top)
	b = placement(DirectedGraph(binA, graph.edges), bottom)
	t.update(b)
	return t

def partition_row(graph, grid):
	if len(graph.nodes) == 1:
		print "Size " + str(grid.w) + " " + str(grid.h)
		# if grid.w*grid.h >= 1:
		return {graph.nodes[0]: (grid.x, grid.y)}
		# else:
			# print "FAILURE: size " + str(grid.w*grid.h)
			# return None
	(left, right) = grid.bisectVertical()
	(binA, binB) = partition_fm(graph)
	l = partition_row(DirectedGraph(binA, graph.edges), left)
	r = partition_row(DirectedGraph(binB, graph.edges), right)
	print type(l)
	l.update(r)
	return l

def partition_fm(graph):
	binA = []
	binB = []
	lockedNodes = [False]*len(graph.nodes)
	# Initial partition
	for (i,node) in enumerate(graph.nodes):
		if i % 2 == 0:
			binA.append(node)
		else:
			binB.append(node)
	
	# trivial case
	if len(graph.nodes) == 2:
		return (binA, binB)

	gba = GainBucket(binA, binB, graph)
	gbb = GainBucket(binB, binA, graph)

	# Iterate until all nodes are locked

	# print "Start"
	# print "Bin A: " + str(binA)
	# print "Bin B: " + str(binB)
	# print "Cost: " + \
			# str(computePartitionCost(graph.edges, binA, binB))
	# print lockedNodes
	while False in lockedNodes:
		ra = float(len(binA)) / (len(binA) + len(binB))
		rb = float(len(binB)) / (len(binA) + len(binB))
		# print "RA " + str(ra)
		# print "RB " + str(rb)
		if gba.maxGain() > 0 and ra > 0.35:
			(n,i) = gba.nextNode()
			lockedNodes[graph.nodes.index(n)] = True
			binA.remove(n)
			binB.append(n)
		elif gbb.maxGain() > 0 and rb > 0.35:
			(n,i) = gbb.nextNode()
			lockedNodes[graph.nodes.index(n)] = True
			binB.remove(n)
			binA.append(n)
		else:
			break
		gba.updateGains(binA, binB, graph)
		gbb.updateGains(binB, binA, graph)
		# print lockedNodes
	# print lockedNodes
	# print "Bin A: " + str(binA)
	# print "Bin B: " + str(binB)
	# print "Cost: " + \
			# str(computePartitionCost(graph.edges, binA, binB))
	return (binA, binB)

class GainBucket:
	def __init__(self, thisBin, otherBin, graph):
		self.updateGains(thisBin, otherBin, graph)
	def updateGains(self, thisBin, otherBin, graph):
		gain = {}
		for node in thisBin:
			gain[node] = computeGain(node, thisBin, otherBin, graph)
		# for node in otherBin:
			# gain[node] = computeGain(node, otherBin, thisBin, graph)

		self.buckets = {}
		for (n,g) in gain.iteritems():
			if g in self.buckets:
				self.buckets[g].append(n)
			else:
				self.buckets[g] = [n]

		self.queue = sorted(self.buckets.keys(), reverse=True)
	def maxGain(self):
		if len(self.queue) > 0:
			return self.queue[0]
		return None
	def nextNode(self):
		if len(self.queue) > 0:
			if self.queue[0] in self.buckets:
				n = self.buckets[self.queue[0]].pop(0)
				g = self.queue[0]
				if len(self.buckets[self.queue[0]]) == 0:
					# del self.buckets[self.queue[0]]
					del self.queue[0]
				return (n, g)
			else:
				return None
		else:
			return None


def computeGain(node, thisBin, otherBin, graph):
	ecost = 0
	icost = 0
	for edge in graph.edges:
		if (edge[0] == node and edge[1] in otherBin) \
				or (edge[1] == node and edge[0] in otherBin):
			ecost += 1
		elif (edge[0] == node and edge[1] in thisBin) \
				or (edge[1] == node and edge[0] in thisBin):
			icost += 1
	return ecost - icost

def computePartitionCost(edges, binA, binB):
	t = 0
	for edge in edges:
		if edge[0] in binA and edge[1] in binB:
			t += 1
		elif edge[1] in binA and edge[0] in binB:
			t += 1
	return t

