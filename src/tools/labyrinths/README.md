# Labyrints Tools

In this folder there are three Python scripts.

## Astar

Script that generates frames for A* algorithm. It generates a frame for each algorithm's move inside the maze.

### Usage

In order to improve readability, we'll use the following shortening:

- ```input path```: path to the .txt file containing the A\* output,
- ```maze path```: path to the .pl file representing the maze,
- ```output path```: path of the folder in which put the output images.

```python
python3 heatmap_parser.py -i <input path> -m <maze path> -o <output path>
```

## Generator

Simple random maze generator.

### Usage

In order to improve readability, we'll use the following shortening:

- ```output path```: path of the folder in which put the output .pl file,
- ```rows```: number of rows for the maze to be generated,
- ```cols```: number of columns for the maze to be generated.

```python
python3 heatmap_parser.py -o <output path> -r <rows> -c <cols>
```

## Parser

Script that prints (save) and image with the optimum path inside the maze found by A\* in the run.

### Usage

In order to improve readability, we'll use the following shortening:

- ```input path```: path of the .pl file containing the A\* output,
- ```output path```: path of the folder in which save the final image of the algorithm. That image contains the optimum path from the start to the end inside the maze found by A\*.

```python
python3 parser.py -i <input path> -o <output path>
```
