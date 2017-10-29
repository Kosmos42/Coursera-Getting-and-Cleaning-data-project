fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "getData.zip"
download.file(fileURL, fileName)
unzip(fileName)
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

featuresIndexMeanStd <- grep(".*mean.*|.*std.*", features[,2])
featuresMeanStd <- features[featuresIndexMeanStd,2]
featuresMeanStd <- gsub("-mean"," Mean",featuresMeanStd)
featuresMeanStd <- gsub("-std", "Std",featuresMeanStd)
featuresMeanStd <- gsub('[-()]', '', featuresMeanStd)

train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresIndexMeanStd]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresIndexMeanStd]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresMeanStd)

allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allDataMelt <- melt(allData, id = c("subject", "activity"))
allDataMean <- dcast(allDataMelt, subject + activity ~ variable, mean)

write.table(allDataMean, "tidy.txt", row.names = FALSE, quote = FALSE)
