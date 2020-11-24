# How to use BN Generatior

We fixed the original BN Generator run script. Now, to run bn generator you simply have to run ```runBnGenerator.*``` script. There is one version for Windows users in ```.bat```, and one version for Unix users in ```.sh```.

## Set the parameters for the generator

### Unix Script

In order to simplify the process of generating BNs, we added in the Unix script a link to the file ```bnconfig.txt```, which contains the configuration for the BN that BN Generator has to produce.

So, if you want to use the Unix script, you should:

1. Run ```chmod +x runBnGenerator.sh```,
2. Edit ```bnconfig.txt``` with the right configuration for yoyr output network,
3. Run ```./runBnGenerator```.

### Windows Script

In the Windows script we didn't know how to replicate the work we did on the Unix Script, so, we have simply left the configuration for the output BN inside the script.
