# How to use BN Generator

[Original repo](http://sites.poli.usp.br/pmr/ltd/Software/BNGenerator/) - Last up date: September 09 2015

We fixed the original BN Generator run script. Now, to run bn generator you simply have to run ```runBnGenerator.*``` script. There is one ```.bat``` script for Windows users , and one ```.sh``` script for Unix users.

## Set the parameters for the generator

In both scripts, the parameters are encoded inside the file. Depending on your goal you can change the BN Generator parameters in order to obtain a specific BN.

Here is a list of all possible BN Generator input parameters, copied from the [original repository](http://sites.poli.usp.br/pmr/ltd/Software/BNGenerator/).

- **nNodes**: the number of nodes in the networks that are generated. Default is 4. Note: nNodes must be larger than 3 (you can easily generate all directed acyclic graphs with 3 nodes).
- **maxDegree**: the maximum degree of any node in the networks that are generated (the degree of a node is the sum of incoming and outgoing arcs). Default is (nNodes - 1). Note: maxDegree must be larger than 2 (you can easily enumerate all graphs with nNodes and maxDegree equal to 2).
- **maxArcs**: the maximum number of arcs that can be present in the generated networks. Note that, for a given number of nodes and a given maximum degree, the number of arcs must satisfy some constraints. If the specified number of arcs is impossible, a message is printed. The default behavior is to ignore any constraint on the number of arcs.
- **maxIW**: the maximum value of induced width in the generated networks. Induced width conveys the algorithmic complexity of inferences and, indirectly, it captures how dense the network is. The default behavior is to ignore any constraint on induced width.
- **nBNs**: The number of random Bayesian networks that are generated and actually saved in files. Default is 1.
- **nTransitions**: the number of iterations (transitions in the Markov chain built by BNGenerator) between networks are generated and saved. Note that every iteration generates a new Bayesian network; after nTransitions , a network is saved in a file (and this process is repeated nBNs times). Default is (4 nNodes).
- **format**: the output format for the generated networks. it can be either xml (in which case the output is in the XMLBIF format) or java (in which case the output is a Java program that can be used to input data into the EBayes library or xmljava (in which case both outputs are generated). Default is xml.
- **nVal**: the maximum number of values for each variable (node) in the generated networks. Each variable has a random number of values between 2 and nVal. Default is 2 (every variable is binary).
- **fName**: the name of the file(s) that will receive output networks. An extension will be appended to fName , depending on the value of format . If nBNs is larger than one, a sequence of files is generated. The file names are of the form fName X.format , where X is a number. Default is Graph .
- **structure**: the type of network generated: either singly (in which case singly-connected networks will be generated) or multi (in which case multi-connected networks will be generated with Algorithm 1 of paper , if there is no constraint on induced width; otherwise, networks will be generated with Algorithm PMMixed of paper ). Singly connected networks are usually called polytrees. Note that multi option leads to the generation of generic graphs, including graphs that are singly connected, trees, and chains. But the probability of hitting a singly connected graph using the multi option is really small for large values of nNodes. Default is multi.
- **testUnif**: also there is the testUnif option that should not be used except if you are interested in testing uniformity for generated networks; if so, contact the developers of BNGenerator for help.

## Run fixed BN Generator

Depending on your OS, run the following command to run BN Generator.

- Unix: ```./Run/runBnGenerator```
- Windows: ```Run/runrunBnGenerator.bat```
