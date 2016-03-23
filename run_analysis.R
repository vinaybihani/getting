library(reshape2)

filename <- "getdata_dataset.zip"
filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(URL, filename)
    }  
    if (!file.exists("UCI HAR Dataset")) { 
      unzip(filename) 
      }

      activityLbls <- read.table("UCI HAR Dataset/activity_labels.txt")
      activityLbls[,2] <- as.character(activityLbls[,2])
      features <- read.table("UCI HAR Dataset/features.txt")
      features[,2] <- as.character(features[,2])

      featuresreq <- grep(".*mean.*|.*std.*", features[,2])
      featuresreq.names <- features[featuresreq,2]
      featuresreq.names = gsub('-mean', 'Mean', featuresreq.names)
      featuresreq.names = gsub('-std', 'Std', featuresreq.names)
      featuresreq.names <- gsub('[-()]', '', featuresreq.names)


      # Load the datasets
      train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresreq]
      trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
      trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
      train <- cbind(trainSubjects, trainActivities, train)

      test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresreq]
      testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
      testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
      test <- cbind(testSubjects, testActivities, test)

      # merge datasets and add labels
      allData <- rbind(train, test)
      colnames(allData) <- c("subject", "activity", featuresreq.names)

      # turn activities & subjects into factors
      allData$activity <- factor(allData$activity, levels = activityLbls[,1], labels = activityLbls[,2])
      allData$subject <- as.factor(allData$subject)

      allData.melted <- melt(allData, id = c("subject", "activity"))
      allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

      write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
