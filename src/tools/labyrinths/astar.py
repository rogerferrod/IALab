from PIL import Image
import argparse
import re
import glob


def generate_maze(input, input_maze, output):
    imgx = 500
    imgy = 500
    image = Image.new("RGB", (imgx, imgy))
    pixels = image.load()
    color = [(255, 255, 255), (0, 0, 0), (255, 255, 0), (255, 0, 0), (0, 255, 0), (0, 0, 255)]

    with open(input_maze) as f:
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

    with open(input_maze) as f:
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
                pixels[kx, ky] = color[maze[int(n_rows * kx / imgx)][int(n_col * ky / imgy)]]

    history = []
    with open(input) as f:
        for line in f:
            se = re.search(r"\[pq\([\d]+.?[\d]+,node\(pos\([\d]+,[\d]+\),(\[[\w|,]*\])\)\)", line)
            if se is not None:
                l = se.groups()[0][1:-1]
                actions = l.split(',')
                actions.reverse()
                history.append(actions)

    for idx, state in enumerate(history):
        moves = compute_moves(state, startx, starty)
        for move in moves:
            for ky in range(imgy):
                for kx in range(imgx):
                    if int(n_col * ky / imgy) == move[1] and int(n_rows * kx / imgx) == move[0]:
                        pixels[kx, ky] = color[-1]
        image.save(output + "maze" + str(idx) + ".png", "PNG")

    idx = len(history) + 1
    state = history[-1]
    moves = compute_moves(state, startx, starty)
    for move in moves:
        for ky in range(imgy):
            for kx in range(imgx):
                if int(n_col * ky / imgy) == move[1] and int(n_rows * kx / imgx) == move[0]:
                    pixels[kx, ky] = color[-2]
    image.save(output + "maze" + str(idx) + ".png", "PNG")


def compute_moves(state, startx, starty):
    current = (startx, starty)
    moves = [current]
    for action in state:
        if action == 'nord':
            current = (current[0], current[1] - 1)
        elif action == 'south':
            current = (current[0], current[1] + 1)
        elif action == 'est':
            current = (current[0] + 1, current[1])
        elif action == 'west':
            current = (current[0] - 1, current[1])
        moves.append(current)

    return moves


def make_gif(output):
    fp_in = output + "*.png"
    img, *imgs = [Image.open(f) for f in sorted(glob.glob(fp_in))]
    img.save(fp=output + "maze.gif", format='GIF', append_images=imgs, save_all=True, duration=500, loop=0)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", default="./output/astar.txt", help="input")
    parser.add_argument("-m", "--maze", default="./output/out.pl", help="input")
    parser.add_argument("-o", "--output", default="./output/img/", help="output folder")

    args = parser.parse_args()
    input = args.input
    maze = args.maze
    output = args.output

    generate_maze(input, maze, output)
    make_gif(output)
