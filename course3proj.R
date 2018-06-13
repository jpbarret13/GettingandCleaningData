## Check if the file exists in the directory and creates it if it does not.

if(!file.exists("./files")){dir.create("./files")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./files/Dataset.zip",method="curl")

## Unzip the file into the directory

unzip(zipfile="./files/Dataset.zip",exdir="./files")

## Creates the path which the read.table command will use to read the unzipped files
## and then reads the different variables from the files
path_rf <- file.path("./data" , "UCI HAR Dataset")

featurestrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
activitytrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
subjecttrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
activitytest <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
subjecttest <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
featurestest <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)


## Merges the test and training datasets
subjectboth <- rbind(subjecttrain, subjecttest)
activityboth <- rbind(activitytrain, activitytest)
featuresboth <- rbind(featurestrain, featurestest)

## Sets the name of the datasets to a descriptive label
names(subjectboth) <- c("subject")
names(activityboth) <- c("activity")
featuresnames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(featuresboth) <- featuresnames$V2

## Merges the datasets so that it is all under one dataset of name "Data"
mergedata <- cbind(subjectboth, activityboth)
Data <- cbind(featuresboth, mergedata)

## Creating a subset of the Data dataset which only lists out variables with either
## mean or standard deviation in the name
subsetfeaturesnames<- featuresnames$V2[grep("mean\\(\\)|std\\(\\)", featuresnames$V2)]

names <- c(as.character(subsetfeaturesnames), "subject", "activity" )
Data <- subset(Data, select = names)

## Variable names area changed to more descriptive names

names(Data) <- gsub("^t", "time", names(Data))
names(Data) <- gsub("^f", "frequency", names(Data))
names(Data) < -gsub("Acc", "Accelerometer", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))
names(Data) <- gsub("BodyBody", "Body", names(Data))

## Second tidy dataset was created to get the mean and median of each variable
library(plyr);
Data2 <- aggregate(. ~subject + activity, Data, mean)
Data2 <- Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
