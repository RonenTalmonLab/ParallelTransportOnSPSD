## ParallelTransportOnSPSD

The code in this repository creates the figures presented in this article: https://arxiv.org/abs/2007.14272
Please notice that in order to apply the code to the data sets, they need to be downloaded first from the following specified links.
The code was developed and tested in Matlab R2019a.

# Sanity check
1. Download and install Manopt toolbox from this link: https://www.manopt.org/tutorial.html

2. Run the file 'MainUnitTest1.m' in the folder 'ToyExample'.

# Article figures
In order to restore the article figures do the following:

3. Download the data and parser from this link: http://resources.mpi-inf.mpg.de/HDM05
   You need to download the *.asf files and the *_amc.zip files that are available for the different part-scenes.

4. Orgenize the different files to 5 folders according to different actors: tr, mm, bd, dg, bk.
Put all the folders under one directory: HDM05\data\HDM05_cut_amc

5. Create the data. You can use MainGetData.m as an example.

6. Run analysis. You can use Main1and3.m as an example.
