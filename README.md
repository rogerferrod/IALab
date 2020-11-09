# IALab

Repository for the IALab exam's projects, session 2019-2020.

You can find the final summaries of each project inside the ```docs``` folder.
In this file, we will only provide a list of shell commands to run the code.

## Prolog

In order to run our Prolog code, type the following command on the shell.
We used **Prolog 8.2.1**.

```shell
swipl
    ['labirinto.pl'].
    ['azioni.pl'].
    ['bfs.pl'].
    bfs(X), write(X).

    ['labirinto.pl'].
    ['azioni.pl'].
    ['iddfs.pl'].
    iterative_deepening_search(X), write(X).

    ['labirinto.pl'].
    ['azioni.pl'].
    ['ida.pl'].
    assert(distance(l1)). # or l2 o linf
    ida(X), write(X).

    ['labirinto.pl'].
    ['azioni.pl'].
    ['utils.pl'].
    ['astar.pl'].
    assert(distance(l1)). # or l2 o linf
    astar(X), write(X). # or astar(X), length(X,L), write(L).

    # For saving to file
    open('astar.txt', write, Out), with_output_to(Out, astar(X)), close(Out).
```

## ASP

In order to run our ASP code, go inside the ```asp``` folder and type the 
following command on the shell. We used **Clingo 5.4.0**.

```shell
clingo generation2.cl facts.cl master.cl
```

To print the output in a **separated file**, run:

```shell
clingo generation2.cl facts.cl master.cl > output/out.txt
```

**Note**: Run only ```generation2.cl```, because is much faster than ```generation.cl```. It is faster because ```generation2.cl``` uses an optimized syntax for
the CLIPS interpreter, but is not quite human-readable as ```generation.cl```.
So, to summarize, to run use ```generation2.cl```, and for understand the code
read ```generation.cl```.

## CLIPS

In order to run our prolog code, type the following command on the shell.
We used **CLIPS 6.4 Beta**.

### Windows enviroment

```shell
clipsdos -f run.bat
```

### Unix enviroment

```shell
./[path to your clips executable] -f run.bat
```

## Uncertanty

In order to run our Java code, type the following command on the shell.
In order to run this part of code, you must use **JDK 1.8 or higher**.

### Static Bayesian Networks

**Template:**

```java -jar static.jar <ordering> <verbose> <json> <experiment> <th1> <th2> <pruningEdges>```

**Example of run:**

```shell
java -jar static.jar topological false ../../input/static/Avg_queries.json earthquake true true true
```

### Dynamic Bayesian Networks

**Template:**

```java -jar dynamic.jar <ordering> <verbose> <json> <experiment>```

**Example of run:**

```shell
java -jar dynamic.jar topological true ../../input/dynamic/DBNexperiments.json Umbrella_00
```

### Paticle filtering

**Template:**

```java -jar particle.jar <iterations> <json> <experiment>```

**Example of run:**

```shell
java -jar particle.jar 10000 ../../input/dynamic/DBNexperiments.json fivestates2_00
```
