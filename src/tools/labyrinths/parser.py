__author__ = "Roger Ferrod, Pio Raffaele Fina, Lorenzo Tabasso"

from PIL import Image
import argparse
import re


def generate_maze(input, output):
    imgx = 500
    imgy = 500
    image = Image.new("RGB", (imgx, imgy))
    pixels = image.load()
    color = [(255, 255, 255), (0, 0, 0), (255, 255, 0), (255, 0, 0)]

    with open(input) as f:
        head = [next(f) for _ in range(2)]
        for line in head:
            line = line.strip()
            n_rows_re = re.search(r"num_rows\(([\d]+)\)\.", line)
            n_col_re = re.search(r"num_columns\(([\d]+)\)\.", line)
            if n_rows_re is not None:
                n_rows = int(n_rows_re.groups()[0])
            if n_col_re is not None:
                n_col = int(n_col_re.groups()[0])

    maze = [[0 for _ in range(n_rows)] for _ in range(n_col)]

    with open(input) as f:
        for line in f:
            start = re.search(r"start\(pos\(([\d]+),([\d]+)\)\)\.", line)
            end = re.search(r"goal\(pos\(([\d]+),([\d]+)\)\)\.", line)
            if start is not None:
                startx = int(start.groups()[1]) - 1
                starty = int(start.groups()[0]) - 1
            if end is not None:
                endx = int(end.groups()[1]) - 1
                endy = int(end.groups()[0]) - 1
            walls = re.search(r"occupied\(pos\(([\d]+),([\d]+)\)\)\.", line)
            if walls is not None:
                x = int(walls.groups()[1]) - 1
                y = int(walls.groups()[0]) - 1
                maze[x][y] = 1

    for ky in range(imgy):
        for kx in range(imgx):
            if int(n_col * ky / imgy) == starty and int(n_rows * kx / imgx) == startx:
                pixels[kx, ky] = color[2]
            elif int(n_col * ky / imgy) == endy and int(n_rows * kx / imgx) == endx:
                pixels[kx, ky] = color[3]
            else:
                if int(n_rows * kx / imgx) >= n_rows or int(n_col * ky / imgy) >= n_col:
                    print('here')
                pixels[kx, ky] = color[maze[int(n_rows * kx / imgx)][int(n_col * ky / imgy)]]

    image.save(output + "maze.png", "PNG")


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", default="./output/out.pl", help="input")
    parser.add_argument("-o", "--output", default="./output/", help="output folder")

    args = parser.parse_args()
    input = args.input
    output = args.output

    generate_maze(input, output)
