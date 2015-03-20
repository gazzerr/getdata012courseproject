## Introduction
The purpose of the project in this repo is to collect and clean a data set that represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
The goal is to prepare tidy data that can be used for later analysis. 

## Scripts
This repository contains the following files:
* the run_analysis.R script for performing the analysis of the data
* the CodeBook.md that describes the variables, the data, and any transformations performed to clean up the data
* this README.md file that explains how all of the scripts in this repo work and how they are connected

To run the run_analysis.R script first download the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzip it into a subfolder under your working directory. So in your working directory next to the run_analysis.R file you should have the subfolder named "UCI HAR Dataset".

After the script finishes there will be the "tidy_set_output.txt" file created under the working directory. This output file will contain the tidy data set. See the CodeBook for performed transformations.