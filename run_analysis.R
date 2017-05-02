library(reshape2)

#unzip file <- if folder not exists
zipFileName <- "getdata%2Fprojectfiles%2FUCI_HAR_Dataset.zip"
if (!file.exists("UCI HAR Dataset")) { 
  unzip(zipFileName) 
}

# Load activity_labels.txt
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])

#Load features.txt
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only mean
features_wanted <- grep(".*mean.*|.*std.*", features[,2])
features_wanted.names <- features[features_wanted,2]
features_wanted.names = gsub('-mean', 'Mean', features_wanted.names)

# Extract only standard deviation
features_wanted.names = gsub('-std', 'Std', features_wanted.names)
features_wanted.names <- gsub('[-()]', '', features_wanted.names)

# Load the traub datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[features_wanted]
train_activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_activities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[features_wanted]
test_activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_activities, test)

# merge datasets
result_data <- rbind(train, test)
# add labels
colnames(result_data) <- c("subject", "activity", features_wanted.names)

# turn activities subjects as factors
result_data$activity <- factor(result_data$activity, levels = activity_labels[,1], labels = activity_labels[,2])
result_data$subject <- as.factor(result_data$subject)

result_data.melted <- melt(result_data, id = c("subject", "activity"))
result_data.mean <- dcast(result_data.melted, subject + activity ~ variable, mean)

#Output Data as tidy.txt
write.table(result_data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)




