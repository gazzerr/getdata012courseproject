## This script does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# load the dplyr package to manipulate the data: 
library(dplyr)

# set the working directory to  my getdata012courseproject
# download file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# unzip the file to the working directory


# first read the features.txt file to be used as column labels
features <- read.csv("UCI HAR Dataset/features.txt",stringsAsFactors = FALSE, strip.white=TRUE, sep=" ",header = FALSE)
feature_labels<-features[,2]
# unfortunately there are duplicated labels that would break reshaping and mutating activities later, so create valid names
valid_column_names <- make.names(names=feature_labels, unique=TRUE, allow_ = TRUE)

# get test and training data. Use strip.white=TRUE to strip leading spaces
test_data <- read.csv("UCI HAR Dataset/test/X_test.txt",stringsAsFactors = FALSE, strip.white=TRUE,header = FALSE)
train_data <- read.csv("UCI HAR Dataset/train/X_train.txt",stringsAsFactors = FALSE, strip.white=TRUE,header = FALSE)

# load reshape2 library 
library(reshape2)
# use colsplit function to split and name columns of data sets. Use " +" pattern to split on multiple spaces
test_data<- colsplit(test_data[,1]," +",valid_column_names)
train_data<- colsplit(train_data[,1]," +",valid_column_names)

# add subjectId column
test_subjects<-read.csv("UCI HAR Dataset/test/subject_test.txt",stringsAsFactors = FALSE, strip.white=TRUE,header = FALSE)
train_subjects<-read.csv("UCI HAR Dataset/train/subject_train.txt",stringsAsFactors = FALSE, strip.white=TRUE,header = FALSE)
test_data<-cbind(subjectId=test_subjects[,1],test_data)
train_data<-cbind(subjectId=train_subjects[,1],train_data)

# add activityId column
test_activities<-read.csv("UCI HAR Dataset/test/y_test.txt",stringsAsFactors = FALSE, strip.white=TRUE,header = FALSE)
train_activities<-read.csv("UCI HAR Dataset/train/y_train.txt",stringsAsFactors = FALSE, strip.white=TRUE,header = FALSE)
test_data<-cbind(activityId=test_activities[,1],test_data)
train_data<-cbind(activityId=train_activities[,1],train_data)

# 1. merge two sets
full_data<-rbind(test_data,train_data)

# 2. select only subsets of data, namely the columns with mean and std
full_data_subset<-select(full_data,subjectId,activityId, contains("mean.."), contains("sdt.."))


# load data into a table frame: 
full_data_subset <- tbl_df(full_data_subset)

# 3. replace activity ids by descriptive names
activities <- read.csv("UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE, strip.white=TRUE, sep=" ",header = FALSE)
activity_labels<-activities[,2]
full_data_subset<-mutate(full_data_subset,activityId=activity_labels[activityId])

# 4. Tidy up the column names
x<- names(full_data_subset)
y<-gsub("\\.(\\w)","\\U\\1",x,perl=TRUE)
clean_names<-gsub("\\.","",y)
names(full_data_subset)<-clean_names
full_data_subset<-rename(full_data_subset, activity=activityId)

# 5. melt data by subject and activity
melteddata<-melt(full_data_subset, id=c("subjectId","activity"), measure.vars=names(full_data_subset)[3:length(names(full_data_subset))])
tidy_set<-dcast(melteddata,  subjectId+activity~variable, mean)

# write the result as required
write.table(tidy_set,file="tidy_set_output.txt",row.name=FALSE)
