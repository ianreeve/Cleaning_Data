#load necessary libraries
library(reshape2)
library(plyr)


#read all necessary files into tables
testdata <- read.table("test/X_test.txt")
testsubjects <- read.table("test/subject_test.txt")
testactivities <- read.table("test/y_test.txt")
traindata <- read.table("train/X_train.txt")
trainsubjects <- read.table("train/subject_train.txt")
trainactivities <- read.table("train/y_train.txt")
feat <- read.table("features.txt")
actlabs <- read.table("activity_labels.txt")


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




