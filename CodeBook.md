## About this file
This code book that describes the variables, the data, and any transformations or work performed to clean up the data 


## Introduction
The goal of this project is to analyse and transform the data collected from the accelerometers from the Samsung Galaxy S smartphones.
The data is downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and contains 2 data sets (training and test) that should be merged.
After that we perform transformations to clean column labels, some values, group rows and generate new values. The resulting tidy data set will be written to the output file tidy_set_output.txt and delivered together with this CodeBook.

## Output file, variables and data
The script creates the tidy_set_output.txt file that contains a transformed data set, which follows the guidelines of a tidy data set:
1) Each variable forms a column
2) Each observation forms a row
3) Each type of observational unit forms a table

Our output file contains a data frame with 180 observations on the following 36 variables:

* subjectId - a number ranging from 1 to 30 identifying the subject who performed the activity
* activity - a character describing the activity that was performed
* other variables resemble the variables described in the original features_info.txt file. Namely 

  - prefix 't' to denote time
  
  - prefix 'f' to denote Fast Fourier Transform (FFT) applied to some of these signals
  
  - Acc and Gyro to denote that signals come from the accelerometer and gyroscope
  
  - Body and Gravity to denote that the acceleration was  separated into body and gravity acceleration
  
  - X,Y,Z to denote 3-axial measurements
  
  - Jerk to denote signals derived from body linear acceleration and angular velocity
  
  - Mag to denote the magnitude of these three-dimensional signals
  
  - Mean to denote the average of each variable for each activity and each subject.

## Input data files 

After unzipping the original data and analysing data files we used the following files:

* test/X_test.txt
* train/X_train.txt
They contains lines with leading spaces, so to trim them we need to read the file with read.csv and  set the parameter strip.white=TRUE.
Each line represents a 561-feature vector with time and frequency domain variables. 
Features are separated by spaces, sometimes by multiple spaces, so to split the line we need to use the regular expression " +" in the pattern to split on

* features.txt 
This file has in each line two values: the id and the label. Those labels would be column labels for feature values from both X_test.txt and X_train.txt files.

* test/subject_test.txt
* train/subject_train.txt
These files contain subject ids (one id per line) of people who performed the activity measured in the corresponding row of X_*.txt file
Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
We append those ids as an extra column (labelled subjectId) to the (test/train) data set

* test/y_test.txt
* train/y_train.txt
These files contain activity ids (one id per line). Those activities were measured in the corresponding row of X_*.txt file
We append those ids as an extra column (labelled activityId) to the (test/train) data set

* activity_labels.txt
This file contains labels corresponding to activity ids, used in y_*.txt files
We use those labels to put descriptive activity names instead of activity ids in the data sets.

All used files do not have header rows.

## Transformations performed

1. First we load the dplyr package to manipulate the input data
2. Then we put the unzipped data in the working directory of this project
3. Then we read the features.txt file to be used as column labels for the data. Just in case we trim spaces (strip.white=TRUE) and separate values in each line by space (sep=" ").
The labels will be the second column of this data frame.
Unfortunately there are duplicated labels that would break reshaping and mutating activities later, so create valid names with the make.names function.
4. Then we read test and training data from test/X_test.txt and train/X_train.txt files. We use strip.white=TRUE to strip leading spaces. We get data frames containing 1 column and each line consists of space-separated feature values.
5. Then we load the reshape2 library to call the colsplit function, since both data sets need to be reshaped into multiple feature columns. 
Since in some lines values might be separated by multiple spaces, we use the " +" pattern to split on.
And we assign our new valid column names to these data frames.
6. Then we add subjectId columns to each (test and train) data frames. 
We read the test/subject_test.txt and train/subject_train.txt files and add the column with subject ids as the first column to our data frames.
7. Then we add activityId columns to each (test and train) data frames. 
We read the test/y_test.txt and train/y_train.txt files and add the column with activity ids as the first column to our data frames already modified with subject ids.
8. Then we merge two sets by using the rbind function. That is step 1 of this project requirements.
9. Step 2. Then we select subset of full data: only columns with measurements on the mean and standard deviation. 
Namely, the columns that contained either mean() or std() in their label name. There are more names that might contain Mean substring, but we use only those that contain those substrings with brackets as a hint that a function was executed. We might use bigger column set, the output would be just bigger, but it doesn't impact the steps below.
Since we modified column labels those brackets were replaced by dots, so we look for labels containing either "mean.." or "sdt..".
We also select new subjectId and activityId columns.
10. Step 3. Now our activityId column contains numeric activity ids, i.e. number ranging from 1 to 6. 
The mapping to descriptive labels  replace activity ids by descriptive names is given in the activity_labels.txt file.
We read this file and its second column into the vector. The indices of this vector correspond to activity ids.
And we use the mutate function to replace numbers by descriptive labels in the activityId column.
11. Step 4. Here we rename the column names. The column names are descriptive enough provided we have the good explanation in the original features_info.txt file.
We just clean those names a little and make them consistently use the camel case.
We use the gsub function to replace strings with regular expressions.
First we replace a dot followed by a letter by a capital letter according to the camel case of variables names.
Secondly we remove the remaining dots introduced at the step when we fixed duplicated labels.
Finally we rename activityId column into activity, since it doesn't contain ids any more.
12. Step 5. To group data by subject and activity we first melt data by subjectId and activityId as ids and using other column names as variables.
To create a tidy data set we dcast this melted data , applying the mean function to all variables.
13. Finally we write the result as required by using the write.table function without row names.



## Dependencies

We used the following packages
* dplyr - to manipulate the data
* reshape2 - to reshape the data