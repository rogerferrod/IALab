# YAPT

Yet Another Pathfinding Tool (YAPT) is a small javascript based utility to
paint mazes and transpile them in Prolog predicates.

The utility is pretty basic and doesn't enforce any semantic control on the
generated predicates (eg. multiple start and end cells).

## TODO

* Someone should provide a decent UI!
* Extend brush types

## Bugs

We know, for the Prolog exercise that there are some bugs in the final
labyrinth file. In particular, for the prolog interpreter (our version was
the 8.2.1) the facts "occupied()" have to be gropued together.
For example:

```prolog
num_rows(10).
num_columns(10).
start(pos(4,2)).        % start
occupied(pos(2,5)).     % begin occupied group
occupied(pos(3,5)).
occupied(pos(4,5)).
occupied(pos(5,5)).
occupied(pos(6,5)).
occupied(pos(7,5)).
occupied(pos(7,1)).
occupied(pos(7,2)).
occupied(pos(7,3)).
occupied(pos(7,4)).
occupied(pos(5,7)).
occupied(pos(6,7)).
occupied(pos(7,7)).
occupied(pos(8,7)).
occupied(pos(4,7)).
occupied(pos(4,8)).
occupied(pos(4,9)).
occupied(pos(4,10)).    % end occupied group
goal(pos(7,9)).         % goals
```

Why is this a bug? Because the **ouput** of this tool is **not always correct**,
you have to **check it every time**.
