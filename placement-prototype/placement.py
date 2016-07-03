# from dirgraph import *
from netlist import *
import algo_fm

def hpwl(pos):
	minx = 0
	miny = 0
	maxx = 0
	maxy = 0
	for (item,p) in pos.iteritems():
		if p[0] < minx:
			minx = p[0]
		elif p[0] > maxx:
			maxx = p[0]
		if p[1] < miny:
			miny = p[1]
		elif p[1] > maxy:
			maxy = p[1]
	return abs(maxx - minx) + abs(maxy - miny)


def renderPlacement(pos, w, h):
	grid = [['.']*w for i in range(h)]
	for (item,p) in pos.iteritems():
		if item.startswith("in"):
			grid[p[1]][p[0]] = 'I'
		elif item.startswith("out"):
			grid[p[1]][p[0]] = 'O'
		else:
			grid[p[1]][p[0]] = '#'
	for row in reversed(grid):
		print row

def main():
	grid = Rect(0, 0, 4, 6)
	netlist = DirectedGraph()

	netlist.addNode("in0")
	netlist.addNode("out0")
	netlist.addNode("n0")
	netlist.addNode("n1")
	netlist.addNode("n2")
	netlist.addNode("n3")
	netlist.addNode("n4")
	netlist.addNode("n5")
	netlist.addNode("n6")

	netlist.addEdge("in0", "n0")
	netlist.addEdge("n0", "n1")
	netlist.addEdge("n0", "n2")
	netlist.addEdge("n1", "n2")
	netlist.addEdge("n2", "out0")
	netlist.addEdge("n3", "out0")
	netlist.addEdge("n4", "n5")
	netlist.addEdge("n5", "n6")
	netlist.addEdge("n6", "out0")

	# algo_fm.partition_fm(netlist)
	pos = algo_fm.placement(netlist, grid)
	renderPlacement(pos, 4, 6)
	print "HPWL: " + str(hpwl(pos))


if __name__ == "__main__": main()

