This software is licensed under the University of Illinois/NCSA Open Source
License:
Copyright (c) 2013 The Board of Trustees of the University of Illinois. All
rights reserved.
Developed by: Department of Civil and Environmental Engineering University
of Illinois at Urbana-Champaign


Estimating traffic control strategies with inverse optimal control - Code submission
Version 0.01 06/27/2013

GENERAL USAGE NOTES
-------------------

1. 	This release of software is intended to complement a paper submission to the 
	IEEE-ITSC 2013 conference.

2.	This software is intended to be run on MATLAB. It was developed using MATLAB
	R2012a and there are no guarantees that it will function as intended on other
	versions of MATLAB or all computer configurations.

HOW TO USE TO SOFTWARE
----------------------

1.	Download all the files in the package and save them on a single folder.
2. 	Direct the MATLAB workspace to that folder.
3.	In the MATLAB command window, type 'run' to start. This should produce all the 
	figures that were included in the paper.
4.	In the file named 'run.m', there is a section where the true weights can be
	modified. The variable to modify is named 'expertWeights'. 
5.	In the file named 'main.m', the standard deviation of the distribution used to
	create model errors can be changed by changing the variable named 'errorStdDev'.
	The default value is 0.00.
6.	In the file 'initialize.m', all the parameters of the problem can be changed to
	reasonable values.



CONTACT INFORMATION
-------------------

Name: Sudeep Gowrishankar
Institution: University of Illinois at Urbana-Champaign
Email: sgowris2@gmail.com



