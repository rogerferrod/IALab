# Uncertainty Tools

In this folder there are two Python scripts.

## Experiments Generator

Given a config in input, it generates a single JSON file containing the configuration for the third experiment (Experiment S3 in summary). In the configuration building process, it randomly samples the given number of query and evidence varibles from the BN passed in input.

### Usage

```python
python3 experiment_generator.py
```

## Treewidth

Script used to determine the treewidth of a set of BN (it reads the bif file inside a specific folder passed in input).

### Usage

In order to improve readability, we'll use the following shortening:

- ```input path```: path of the folder which contains all the .bif files,
- ```output path```: path of the folder in which put the output .csv file,

```python
python3 treewidth.py -i <input path> -o <output path>
```
