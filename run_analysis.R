> #1 download and unzip the file
> if(!file.exists("./data")){dir.create("./data")}
> fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
> download.file(fileUrl,destfile = "./data/dataset.zip")
trying URL 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
Content type 'application/zip' length 62556944 bytes (59.7 MB)
downloaded 5.7 MB

Warning message:
In download.file(fileUrl, destfile = "./data/dataset.zip") :
  downloaded length 6025216 != reported length 62556944
> if(!file.exists("UCI_HAR_Dataset")){unzip(zipfile = "./data/dataset.zip",exdir="./data")}
Warning message:
In unzip(zipfile = "./data/dataset.zip", exdir = "./data") :
  error 1 in extracting from zip file
> 
> #2.1read training table
> x_train <- read.table("./data/UCI HAR Dataset/train/x_train.txt")
> y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
> subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
> 
> #2.2read testing table
> x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
> y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
> subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
> 
> #2.3read lables and vector
> activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')
> features <- read.table('./data/UCI HAR Dataset/features.txt')
> 
> #3 column name
> colnames(x_train) <- features[,2]
> colnames(y_train) <- "activityId"
> colnames(subject_train) <- "subjectId"
> colnames(x_test) <- features[,2] 
> colnames(y_test) <- "activityId"
> colnames(subject_test) <- "subjectId"
> colnames(activity_labels) <- c('activityId','activityType')
> 
> #4 combine data
> cmb_train <- cbind(y_train,subject_train,x_train)
> cmb_test <- cbind(y_test,subject_test,x_test)
> allinone <- rbind(cmb_train,cmb_test)
> colNames <- colnames(allinone)
> 
> #5.1 create vector
> mean_std <- (grepl("activityId" , colNames) | 
+                  grepl("subjectId" , colNames) | 
+                  grepl("mean.." , colNames) | 
+                  grepl("std.." , colNames))
> 
> #5.2 create subset
> setForMeanAndStd <- allinone[ , mean_std == TRUE]
> 
> setWithActivityNames <- merge(setForMeanAndStd, activity_labels,
+                               by='activityId',
+                               all.x=TRUE)
> 
> #6.1 tidy data set
> secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
> secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
> 
> #6.2 write data set
> write.table(secTidySet, "secTidySet.txt", row.name=FALSE)
> 
