library(data.table)
library(reshape2)

# Read in the labels
myPath <- "K:/Brian/Code/R/John Hopkins - Data Science Specialization/Getting and Cleaning Data"
myPath =
fileName <- file.path(myPath, "UCI HAR Dataset", "activity_labels.txt")
activityLabels <- read.table(fileName)[,2]

# Read in the features
fileName <- file.path(myPath, "UCI HAR Dataset", "features.txt")
features <- read.table(fileName)[,2]

# Get the mean and standard deviation
extractFeatures <- grepl("mean|std", features)

# Load and process test data.
fileName <- file.path(myPath, "UCI HAR Dataset", "test", "X_test.txt")
X_test <- read.table(fileName)
fileName <- file.path(myPath, "UCI HAR Dataset", "test", "y_test.txt")
y_test <- read.table(fileName)
fileName <- file.path(myPath, "UCI HAR Dataset", "test", "subject_test.txt")
subject_test <- read.table(fileName)
names(X_test) = features

# Get the mean and standard deviation
X_test = X_test[,extractFeatures]

# Load activity labels
y_test[,2] = activityLabels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind the data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Read and process the test and training data.
fileName <- file.path(myPath, "UCI HAR Dataset", "train", "X_train.txt")
X_train <- read.table(fileName)
fileName <- file.path(myPath, "UCI HAR Dataset", "train", "y_train.txt")
y_train <- read.table(fileName)

# Read the training subject data
fileName <- file.path(myPath, "UCI HAR Dataset", "train", "subject_train.txt")
subject_train <- read.table(fileName)
names(X_train) = features

# Get the mean and standard deviation
X_train = X_train[,extractFeatures]

# Load the activity data
y_train[,2] = activityLabels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind the data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge the test and train data sets
data = rbind(test_data, train_data)

id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data = melt(data, id = id_labels, measure.vars = data_labels)

# Mean of data set using dcast
tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)

fileName <- file.path(myPath, "tidy_data.txt")
write.table(tidy_data, file = fileName, row.name=FALSE)
