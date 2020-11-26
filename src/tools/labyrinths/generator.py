"""
Random maze generator for prolog project.
"""

__author__ = "Roger Ferrod, Pio Raffaele Fina, Lorenzo Tabasso"

import random
from PIL import Image
import argparse


def generate_maze(mx, my, output):
    imgx = 500
    imgy = 500
    image = Image.new("RGB", (imgx, imgy))
    pixels = image.load()

    maze = [[0 for _ in range(mx)] for _ in range(my)]
    dx = [0, 1, 0, -1]
    dy = [-1, 0, 1, 0]
    color = [(0, 0, 0), (255, 255, 255), (255, 0, 255), (255, 0, 0)]

    # start the maze from a random cell
    startx = random.randint(0, mx - 1)
    starty = random.randint(0, my - 1)

    f = open(output + 'out.pl', "w")
    f.write("num_rows(%d).\n" % my)
    f.write("num_columns(%d).\n" % mx)
    f.write("start(pos(%d,%d)).\n" % (starty + 1, startx + 1))

    stack = [(startx, starty)]

    while len(stack) > 0:
        (cx, cy) = stack[-1]
        maze[cy][cx] = 1
        nlst = []  # list of available neighbors
        for i in range(4):
            nx = cx + dx[i]
            ny = cy + dy[i]

            if 0 <= nx < mx and 0 <= ny < my:
                if maze[ny][nx] == 0:
                    ctr = 0
                    for j in range(4):
                        ex = nx + dx[j]
                        ey = ny + dy[j]
                        if 0 <= ex < mx and 0 <= ey < my:
                            if maze[ey][ex] == 1:
                                ctr += 1
                    if ctr == 1:
                        nlst.append(i)
        # if 1 or more neighbors available then randomly select one and move
        if len(nlst) > 0:
            ir = nlst[random.randint(0, len(nlst) - 1)]
            cx += dx[ir]
            cy += dy[ir]
            stack.append((cx, cy))
        else:
            stack.pop()

    n_occupate = 0
    # save
    for ky in range(my):
        for kx in range(mx):
            if maze[kx][ky] == 0:
                f.write("occupied(pos(%d,%d)).\n" % (ky + 1, kx + 1))
                n_occupate += 1

    # f.write("numeroOccupate(%d).\n" % n_occupate)

    endx = -1
    endy = -1
    # select random end
    found = False
    while not found:
        endx = random.randint(0, mx - 1)
        endy = random.randint(0, my - 1)
        if maze[endx][endy] == 1 and startx != endx and starty != endy:
            f.write("goal(pos(%d,%d)).\n" % (endy + 1, endx + 1))
            found = True

    # paint the maze
    for ky in range(imgy):
        for kx in range(imgx):
            if int(my * ky / imgy) == starty and int(mx * kx / imgx) == startx:
                pixels[kx, ky] = color[2]
            elif int(my * ky / imgy) == endy and int(mx * kx / imgx) == endx:
                pixels[kx, ky] = color[3]
            else:
                pixels[kx, ky] = color[maze[int(mx * kx / imgx)][int(my * ky / imgy)]]

    f.close()
    image.save(output + "Maze_" + str(mx) + "x" + str(my) + ".png", "PNG")
    print("start(y:{0}, x:{1})".format(starty + 1, startx + 1))
    print("goal(y:{0}, x:{1})".format(endy + 1, endx + 1))

    diff_x = abs(startx + 1 - endx + 1)
    diff_y = abs(starty + 1 - endy + 1)

    print("Distance: (y:{0}, x:{1}) (lower -> near, higher -> far)".format(diff_y, diff_x))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-o", "--output", default="./output/", help="output folder")
    parser.add_argument("-r", "--rows", default=40, type=int, help="number of rows")
    parser.add_argument("-c", "--columns", default=40, type=int, help="number of columns")

    args = parser.parse_args()
    nx = args.rows
    ny = args.columns
    outputname = args.output

    generate_maze(nx, ny, outputname)
