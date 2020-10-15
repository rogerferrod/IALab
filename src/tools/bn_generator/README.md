# Introduction

[Original repo](http://sites.poli.usp.br/pmr/ltd/Software/BNGenerator/) - Last up date: September 09 2015

Bayesian networks are popular representations for uncertainty; the idea is to use a directed acyclic graph and a collection of conditional probability distributions to represent a possibly complex joint probability distribution. Each node in the graph represents a variable, and the edges of the graph represent the direct dependencies among variables.
BNGenerator is a program that generates random Bayesian networks, guaranteeing that the distribution of generated networks is (asymptotically) uniform. The program is coded in Java and is freely distributed under the GNU license.

The program accepts constraints on the maximum degree for nodes and on the maximum number of arcs in the network; these constraints limit how "connected" the networks are. Also, it is possible to control the induced width of the network, leading to more "realistic" networks. Other constraints (for example, maximum number of parents for each node) could be coded with relatively simple modifications in the program; the theoretical analysis of the algorithm and the source code are available, and these modifications should not be too hard.

BNGenerator was coded by Jaime Shinsuke Ide , as a result of research conducted by Jaime S. Ide and Fabio G. Cozman . Ideas and results were based on the work of G. Melançon and M. Bousquet-Melou, and some parts of BNGenerator were directly inspired by the DagAlea software. The research was funded by FAPESP .

## Generation method

A Bayesian network is composed of
A directed acyclic graph with N nodes.
For each node, a random variable with V values.
For each variable, a conditional probability distribution p(X|P) , where P indicates the variables that are parents of X in the graph (that is, the nodes associated with P are parents of the node associated with X ).
To generate a Bayesian network, we need to generate a directed acyclic graph with N nodes, and for each node we must generate a number V of values, and then we must generate a probability distribution p(X|P). Our approach is to focus on each one of these problems separately; that is, we first generate a directed acyclic graph that is uniformly distributed in the space of graphs under consideration, then we generate a number V that is uniformly distributed within some interval, and then we randomly generate the probability distributions. It turns out that generating the number of values for each variable is easy, and that there exists a simple algorithm for generating the probability distributions given the graph and the values. The real problem is to generate random directed acyclic graphs.
There is a huge number of directed acyclic graphs for any reasonably large number of nodes. Even though there are expressions that would allow one to compute the number of directed acyclic graphs, there does not seem to exist a simple method that would allow us to sample uniformly from this huge space. Basically, there does not seem to be a method to map the integers (from 1 to some large number M) to the directed acyclic graphs with N nodes. But even if we knew how to sample from the space of all possible directed acyclic graphs, that knowledge would not give us a practical solution to the problem of generating random Bayesian networks. It has been observed that in practice Bayesian networks are rather sparse graphs, in the sense that nodes have a few parents and children (that is, the degree of the nodes is not too large). Now, our problem then is to generate uniformly distributed samples from the class of directed acyclic graphs with restrictions on node degree (or possibly, restrictions on the number of parents, number of children, number of arcs, etc). This is a hard problem.

Our approach, and the proofs that our algorithms for generating random directed acyclic graphs are correct, are in the paper

Jaime Shinsuke Ide , Fabio Gagliardi Cozman . Generating random Bayesian networks , Brazilian Symposium on Artificial Intelligence , Recife, Pernambuco, Brazil, 2002.
To generate random directed acyclic graphs, BNGenerator uses MCMC methods (Markov chain Monte Carlo). We define a set of possible transitions for a graph (that is, a set of possible modifications for the graph) and we select one transition at random. Given the characteristics of the possible transitions and the selection process, a random directed acyclic graph with uniform distribution is produced after several transitions. In fact, the result is asymptotic: in the limit of infinitely many transitions, a uniformly distributed sample will be produced. In the paper indicated previously, we present the transitions and selection process used by BNGenerator, and prove that they have the right properties: after many transitions, we obtain a uniform random Bayesian network. In theory we would have to wait for infinitely many iterations, but in practice we stop at a large number. Empirical studies suggest that for a graph with N nodes, we should perform at least 4 \* N \* N transitions. That is the number of transitions that BNGenerator adopts by default, but the user can specify a different number.

When we have a random directed acyclic graph, it is easy to generate a number V for each node. We just sample the uniform distribution between 2 and some maximum allowed number Vm. Once we have the number of values for all variables in the graph, we can generate probability distributions by sampling from Dirichlet distributions. See the paper indicated previously for a more detailed discussion.

BNGenerator starts from a very simple Bayesian network (a chain of nodes where each node has at most a parent and a child) and keeps performing transitions. The user can specify how many transitions are performed before a network is saved in file. After a network is saved, BNGenerator can keep performing transitions and saving more networks.

An important point is that we differentiate between generic graphs and graphs that do have a single path (directed or undirected) between any two nodes. The latter graphs are said singly connected, and also called polytrees. The distinction is important in Bayesian networks because singly connected networks have interesting properties that do not generalize to other classes of networks. It should be noted that no guaranteed algorithm for generating random polytrees seems to exist at the moment (that is, an algorithm that can guarantee the distribution of the generated samples). BNGenerator can produce random singly connected Bayesian networks if the user wishes to do so.

## Controlling induced width constraint

Recently, we added a new feature on BNGenerator as described with details on the paper

Jaime Shinsuke Ide , Fabio Gagliardi Cozman . Generation of Random Bayesian Networks with Constraints on Induced Width, with Applications to the Average Analysis od d-Connectivity, Quasi-random Sampling, and Loopy Propagation. University of São Paulo. Technical Report June 2003. (320KB )

We eventually found that the most appropriate quantity to control is the induced width of networks. The induced width of a network can be easily explained and understood; it conveys the algorithmic complexity of inferences and, indirectly, it captures how dense the network is. Our tests indicate (rather subjectively) that a network with low induced width ''looks like'' real networks in the literature. Besides, it makes sense to control induced width, as we are usually interested in comparing algorithms or parameterizing results with respect to the complexity of the underlying network, and induced width is the main indicator of such complexity. Unfortunately, the generation of random graphs with constraints on induced width is significantly more involved than the generation of graphs with constraints on node degree and number of edges. In the paper above, we report on new algorithms that accomplish generation of graphs with simultaneous constraints on all these quantities: induced width, node degree, and number of edges.

Finding the exact value of induced width is NP-hard problem with no easy solution. Then, in order to get more efficiency, we compute as ''induced width'' a value obtained with a particular efficient heuristic. We observed that the heuristic approximates very well the exact value of the induced width.

## Downloading BNGenerator

In this package, you can find all the necessary files to run the latest version of the BNGenerator, and the related source files.
Running BNGenerator

BNGenerator is coded in the Java language; to run it, you need to have the Java Virtual Machine installed. We have coded BNGenerator using Java 1.2; it is likely that everything will work with Java 1.0 and Java 1.1, but we cannot guarantee it. Download Java 1.2 or later from JavaSoft if you don't have it yet.
BNGenerator is run as follows (assuming all files and the colt.jar library are in the same directory):

```java BNGenerator -classpath .;colt.jar [- optionvalue]*```
where ```[-optionvalue]``` indicates a sequence of pairs where option can be any of ```-namevalue```:

Every option has a default value that is assumed if the option is not specified. The options are:

- *nNodes*: the number of nodes in the networks that are generated. Default is 4. Note: nNodes must be larger than 3 (you can easily generate all directed acyclic graphs with 3 nodes).
- *maxDegree*: the maximum degree of any node in the networks that are generated (the degree of a node is the sum of incoming and outgoing arcs). Default is (nNodes - 1). Note: maxDegree must be larger than 2 (you can easily enumerate all graphs with nNodes and maxDegree equal to 2).
- *maxArcs*: the maximum number of arcs that can be present in the generated networks. Note that, for a given number of nodes and a given maximum degree, the number of arcs must satisfy some constraints. If the specified number of arcs is impossible, a message is printed. The default behavior is to ignore any constraint on the number of arcs.
- *maxIW*: the maximum value of induced width in the generated networks. Induced width conveys the algorithmic complexity of inferences and, indirectly, it captures how dense the network is. The default behavior is to ignore any constraint on induced width.
- *nBNs*: The number of random Bayesian networks that are generated and actually saved in files. Default is 1.
- *nTransitions*: the number of iterations (transitions in the Markov chain built by BNGenerator) between networks are generated and saved. Note that every iteration generates a new Bayesian network; after nTransitions , a network is saved in a file (and this process is repeated nBNs times). Default is (4 \* nNodes \* nNodes ).
- *format*: the output format for the generated networks. it can be either xml (in which case the output is in the XMLBIF format) or java (in which case the output is a Java program that can be used to input data into the EBayes library or xmljava (in which case both outputs are generated). Default is xml.
- *nVal*: the maximum number of values for each variable (node) in the generated networks. Each variable has a random number of values between 2 and nVal. Default is 2 (every variable is binary).
- *fName*: the name of the file(s) that will receive output networks. An extension will be appended to fName , depending on the value of format . If nBNs is larger than one, a sequence of files is generated. The file names are of the form fName X.format , where X is a number. Default is Graph .
- *structure*: the type of network generated: either singly (in which case singly-connected networks will be generated) or multi (in which case multi-connected networks will be generated with Algorithm 1 of paper , if there is no constraint on induced width; otherwise, networks will be generated with Algorithm PMMixed of paper ). Singly connected networks are usually called polytrees. Note that multi option leads to the generation of generic graphs, including graphs that are singly connected, trees, and chains. But the probability of hitting a singly connected graph using the multi option is really small for large values of nNodes. Default is multi.
- *testUnif*: also there is the testUnif option that should not be used except if you are interested in testing uniformity for generated networks; if so, contact the developers of BNGenerator for help.

## Examples

The following lines indicate valid calls to BNGenerator:

1. ```java -classpath .;colt.jar BNGenerator -nNodes 20 - maxDegree 3 -nBNs 1 - fName example```
   Generates one Bayesian network with 20 binary nodes and stores the network in the file example1.xml . Every node has a maximum degree of 3. Before the final network is saved, 1600 transitions are performed (using the default 4*20*20).
   The resulting network is here.

2. ```java -classpath .;colt.jar BNGenerator -nNodes 20 - maxDegree 3 -nBNs 1 - maxArcs 25 -fName example```
   Same as previous example, but with a limit on the number of arcs (limited to 25). The resulting network is here.
   java -classpath .;colt.jar BNGenerator -nNodes 20 - maxDegree 3 -nBNs 10 -nVal 5 -nTransitions 10000 - fName example
   Generates ten Bayesian networks with 20 nodes. Each variable has 2 to 5 values. The networks are saved in files exampleX.xml, where X goes from 1 to 10. Every node has a maximum degree of 3. Between any two networks are saved (and before the first network is saved), 10000 transitions are performed.
   One of the resulting networks is here.

3. ```java -classpath .;colt.jar BNGenerator - nNodes 20 -maxDegree 3 - nBNs 1 - fName example```
   Generates one Bayesian network with 20 binary nodes and stores the network in the file example1.xml . Every node has a maximum degree of 3. Before the final network is saved, 1600 transitions are performed (using the default 4*20*20).
   The resulting network is here.

4. ```java -classpath .;colt.jar BNGenerator - nNodes 20 -maxDegree 3 - nBNs 1 - structure singly - fName example```
   Same as the last one, but now the program is constrained to generate a polytree. The resulting network is here.

5. ```java -classpath .;colt.jar BNGenerator - nNodes 15 -maxDegree 14 - nBNs 1 - fName example -structure pmmixed -maxIW 2```
   Generates one Bayesian network with 15 binary nodes and stores the network in the file example1.xml. The network has a maximum heuristic width of 2 (computed using the minimum weight heuristic implementation of EBayes). Heuristic width is calculated instead of induced width because of computational complexity (details in the paper ).
   The resulting network is here.

### Acknowledgments

We thank Nir Friedman for suggesting the Dirichlet distribution method, and Robert Castelo for pointing us to Melançon et al's work. We thank Guy Melançon for confirming that the idea of constructing connected directed acyclic graph was sound and for making his DagAlea software available. We also thank Jaap Suermondt and Alessandra Potrich for providing important ideas, and Y. Xiang, P. Smets, D. Dash, M. Horsh, E. Santos, and B. D'Ambrosio for suggesting valuable procedures.
This research was conducted at the Decision Making Lab at the University of Sao Paulo , with support from the funding agency FAPESP ; both institutions are in Sao Paulo, Brazil.
