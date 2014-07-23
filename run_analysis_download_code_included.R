#load necessary libraries
library(reshape2)
library(plyr)

#download the zip file as a temp file
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)

#read all necessary files into tables
testdata <- read.table(unz(temp,"UCI HAR Dataset/test/X_test.txt"))
testsubjects <- read.table(unz(temp,"UCI HAR Dataset/test/subject_test.txt"))
testactivities <- read.table(unz(temp,"UCI HAR Dataset/test/y_test.txt"))
traindata <- read.table(unz(temp,"UCI HAR Dataset/train/X_train.txt"))
trainsubjects <- read.table(unz(temp,"UCI HAR Dataset/train/subject_train.txt"))
trainactivities <- read.table(unz(temp,"UCI HAR Dataset/train/y_train.txt"))
feat <- read.table(unz(temp,"UCI HAR Dataset/features.txt"))
actlabs <- read.table(unz(temp,"UCI HAR Dataset/activity_labels.txt"))

unlink(temp)

#merge the tables for the 2 sets
combddata <- rbind(testdata,traindata)
combdsubjects <- rbind(testsubjects,trainsubjects)
combdactivities <- rbind(testactivities,trainactivities)

#determine which of the 561 measurements are Means or Std Devs
feat$MeanOrStd <- ifelse((grepl("mean()",feat$V2,fixed=T)|grepl("std()",feat$V2,fixed=T)),TRUE,FALSE)
reqcol <- feat[feat$MeanOrStd,1]
newcombdd <- combddata[, reqcol]
names(newcombdd) <- feat[feat$MeanOrStd,2] #change variable labels
write.table(names(newcombdd),file="codebook.txt",row.names=F) #use this to produce codebook if reqd

#match Activity Names to Activity Ref and join to data file
m <- join(combdactivities,actlabs,type="left")
newcombdd$Activity <- m$V2
newcombdd$SubjectID <- combdsubjects$V1

#create a "long, skinny" file for each Subject, Activity combo & means of the measurements
DataMelt <- melt(newcombdd,id=c("SubjectID","Activity"))
d <- dcast(DataMelt, SubjectID + Activity ~ variable,mean,drop=F)
write.table(d,file="igr_tidy_data_file.txt",row.names=F)




