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

Simple maze generator.

### Usage

In order to improve readability, we'll use the following shortening:

- ```output path```: path of the folder in which put the output .pl file,
- ```rows```: number of rows for the maze to be generated,
- ```cols```: number of columns for the maze to be generated.

```python
python3 heatmap_parser.py -o <output path> -r <rows> -c <cols>
```

## Parser

Sorry, we no longer remember... :(
