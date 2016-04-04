from graphics import *
from time import sleep

def main():
	win = GraphWin("California", 900, 900)
	src = open("data.txt", "r")
	for line in src:
		line = line[:-1]
		# print(line)
		y1, x1, y2, x2 = line.split(",")
		x1, x2 = int((float(x1) + 125) * 80), int((float(x2) + 125) * 80)
		y1, y2 = int((float(y1) - 32) * 80), int((float(y2) - 32) * 80)
		L = Line(Point(x1,y1), Point(x2, y2))
		L.draw(win)
		# sleep(0.1)
	print('done!')
	win.getMouse()
	win.close()

if __name__ == '__main__':
	main()