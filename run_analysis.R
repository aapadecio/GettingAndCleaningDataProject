#loads activity datasets from test and train within working directory
testactivity = read.table("y_test.txt", header = FALSE)
trainactivity = read.table("y_train.txt", header = FALSE)

#loads subject datasets from test and train within working directory
testsubject = read.table("subject_test.txt", header = FALSE)
trainsubject = read.table("subject_train.txt", header = FALSE)

#loads features datasets from test and train within working directory
testfeatures = read.table("X_test.txt", header = FALSE)
trainfeatures = read.table("X_train.txt", header = FALSE)

#Combine activity, subject and feature sets from test and training sets, respectively
#Merge the test and training sets to create one data set

activity = rbind(trainactivity, testactivity)
subject = rbind(trainsubject, testsubject)
features = rbind(trainfeatures, testfeatures)

#Change factor levels to match activity labels
labels = read.table("activity_labels.txt", header = FALSE)
activity$V1 = factor(activity$V1, levels = as.integer(labels$V1), labels = labels$V2)

#Name activity and subject columns
names(activity) = c("activity")
names(subject) = c("subject")

#Name feature columns from features text file
featurestxt = read.table("features.txt", header = FALSE)
names(features) = featurestxt$V2

#Select columns with mean and standard deviation data and subsetting
meanstdev = c(as.character(featurestxt$V2[grep("mean\\(\\)|std\\(\\)", featurestxt$V2)]))
subdata = subset(features,select = meanstdev)

#Combine data sets with activity names and labels
subjectactivity <- cbind(subject, activity)
finaldata <- cbind(subdata, subjectactivity)

#Clarify time and frequency variables
names(finaldata)<-gsub("^t", "time", names(finaldata))
names(finaldata)<-gsub("^f", "frequency", names(finaldata))

#Create new data set with subject and activity means

suppressWarnings(cleandata <- aggregate(finaldata, by = list(finaldata$subject, finaldata$activity), FUN = mean))
colnames(cleandata)[1] <- "Subject"
names(cleandata)[2] <- "Activity"

#Remove average and standard deviation for non-aggregated subject and activity columns
cleandata <- cleandata[1:68]

#Write tidy data to text file
write.table(cleandata, file = "tidy.txt", row.name = FALSE)

