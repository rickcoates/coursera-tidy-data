## These following functions implement a solution to the Course Project for the
## Coursera Data Science Specialization Getting and Cleaning Data MOOC.
## 
## The stated purpose of the project/assignment is to demonstrate an ability to collect, 
## work with, and clean a data set, with the ultimate goal of preparing a tidy data that 
## can be used for later analysis.
##
## The "unclean" data to be "tidied" is a data set collected from the accelerometers in
## Samsung Galaxy S smartphones known as the "Human Activity Recognition Using Smartphones 
## Dataset Version 1.0." The raw/untidy data consist of both training and test data (that 
## are to be combined). For the purpose of this analysis, the raw triaxial acceleration 
## data from the smartphone's accelerometer (total acceleration), the estimated body 
## acceleration data, and the triaxial angular velocity from the smartphone's gyroscope
## are NOT considered. Rather, the tidy data set for later analysis is constructed from
## a 561-feature vector of time and frequency domain variables for each observation, the 
## activity label associated with the feature vector (one of six: WALKING, WALKING_UPSTAIRS, 
## WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) and the (numeric/anonymized) identifier 
## of the human subject who carried the smartphone.

run_analysis <- function(download.data = F, directory = "UCI HAR Dataset") {
  ## Runs the complete analysis, including (optionally) downloading the data set 
  ## from source.
  ##
  ## Args: 
  ##   download.data: If TRUE, download the data set from source, Default is FALSE.
  ##   directory: The root directory of where the data set resides or should be 
  ##   placed if it is downloaded from source.
  ##
  ## Returns:
  ##   A tidy data set as defined in CodeBook.md. The data set is also saved as a 
  ##   CSV to the working directory.

  ## download the data set and extract the zip file if requested
  if (download.data == T) {
    message("downloading the data set...")
    filename <- paste0(directory, ".zip")
    ## download the data
    status <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", filename, method="curl")
    dateDownloaded <- date()
    if (status != 0) {
      stop(paste("download of data set failed with error code", status, "on", dateDownloaded))
    }
    else {
      message(paste("download of data set succeeded on", dateDownloaded))
      ## unzip the archive
      unzip(filename)
      ## remove the .zip file, since the extracted files are in a (sub)directory of the working directory
      file.remove(filename) 
    }
  }
  ## first, remove extraneous spaces from the measurement data file so it is possible
  ## to read in the measurement data using the fread function in the data.table package
  message("performing initial cleaning of the feature vector files...")
  despaced.test.filename  <- CleanTestOrTrainSpaces("test", directory)
  despaced.train.filename <- CleanTestOrTrainSpaces("train", directory)
  ## determine the measurements to extract from the test and train data sets based on
  ## the names of the features given in the features.txt file that comes with the data set
  message("determining features with both mean and stdev measurements...")
  mean.and.stdev.measurements <- MeasurementsOfInterest(directory)
  ## read in the data sets and only the features with both mean and stdev measurements,
  ## add in the activity labels and subject columns, tidy everything up and, finally, 
  ## merge the test and train data sets.
  message("reading in the various data set files and constructing a clean data frame...")
  tidy.data <- ReadDataAndCreateDataFrame(despaced.test.filename, despaced.train.filename, mean.and.stdev.measurements, directory)
  message("creating the second tidy data set (summarizing the first tidy data set)...")
  second.tidy.data.set <- CreateSecondTidyDataSet(tidy.data)
  message("writing out the second tidy data set to the working directory...")
  write.csv(second.tidy.data.set,"HAR_Tidy_Summarized.csv")
  second.tidy.data.set
}

CreateSecondTidyDataSet <- function(data) {
  ## Creates a second tidy data set that contains summary statistics of first 
  ## tidy data set.
  ##
  ## Args: 
  ##   download.data: The first tidy data set, a data frame containing all of
  ##                  the measurement variables of interest for each observation 
  ##                  as well as the activity label associated with the observation 
  ##                  and the subject identifier.
  ##
  ## Returns:
  ##   A second, independent tidy data set with the average of each variable 
  ##   for each activity and each subject. This data set as defined in CodeBook.md.
  
  require(plyr)
  ## use ddply to summarize all of the measurement variables of interest by
  ## activity (label) and subject. The name of the summarized (average/mean) 
  ## version of the variable is set to be name of the original variable with 
  ## .avg appended.
  tidy2.df <- ddply(data, .(ActivityLabel, SubjectNumber), summarize, 
                            tBodyAcc.mean.X.avg           = mean(tBodyAcc.mean.X),
                            tBodyAcc.mean.Y.avg           = mean(tBodyAcc.mean.Y),         
                            tBodyAcc.mean.Z.avg           = mean(tBodyAcc.mean.Z),          
                            tBodyAcc.std.X.avg            = mean(tBodyAcc.std.X),         
                            tBodyAcc.std.Y.avg            = mean(tBodyAcc.std.Y),        
                            tBodyAcc.std.Z.avg            = mean(tBodyAcc.std.Z),          
                            tGravityAcc.mean.X.avg        = mean(tGravityAcc.mean.X),       
                            tGravityAcc.mean.Y.avg        = mean(tGravityAcc.mean.Y),        
                            tGravityAcc.mean.Z.avg        = mean(tGravityAcc.mean.Z),        
                            tGravityAcc.std.X.avg         = mean(tGravityAcc.std.X),         
                            tGravityAcc.std.Y.avg         = mean(tGravityAcc.std.Y),         
                            tGravityAcc.std.Z.avg         = mean(tGravityAcc.std.Z),         
                            tBodyAccJerk.mean.X.avg       = mean(tBodyAccJerk.mean.X),       
                            tBodyAccJerk.mean.Y.avg       = mean(tBodyAccJerk.mean.Y),       
                            tBodyAccJerk.mean.Z.avg       = mean(tBodyAccJerk.mean.Z),       
                            tBodyAccJerk.std.X.avg        = mean(tBodyAccJerk.std.X),        
                            tBodyAccJerk.std.Y.avg        = mean(tBodyAccJerk.std.Y),        
                            tBodyAccJerk.std.Z.avg        = mean(tBodyAccJerk.std.Z),        
                            tBodyGyro.mean.X.avg          = mean(tBodyGyro.mean.X),          
                            tBodyGyro.mean.Y.avg          = mean(tBodyGyro.mean.Y),          
                            tBodyGyro.mean.Z.avg          = mean(tBodyGyro.mean.Z),          
                            tBodyGyro.std.X.avg           = mean(tBodyGyro.std.X),           
                            tBodyGyro.std.Y.avg           = mean(tBodyGyro.std.Y),           
                            tBodyGyro.std.Z.avg           = mean(tBodyGyro.std.Z),           
                            tBodyGyroJerk.mean.X.avg      = mean(tBodyGyroJerk.mean.X),      
                            tBodyGyroJerk.mean.Y.avg      = mean(tBodyGyroJerk.mean.Y),      
                            tBodyGyroJerk.mean.Z.avg      = mean(tBodyGyroJerk.mean.Z),      
                            tBodyGyroJerk.std.X.avg       = mean(tBodyGyroJerk.std.X),       
                            tBodyGyroJerk.std.Y.avg       = mean(tBodyGyroJerk.std.Y),       
                            tBodyGyroJerk.std.Z.avg       = mean(tBodyGyroJerk.std.Z),       
                            tBodyAccMag.mean.avg          = mean(tBodyAccMag.mean),          
                            tBodyAccMag.std.avg           = mean(tBodyAccMag.std),           
                            tGravityAccMag.mean.avg       = mean(tGravityAccMag.mean),       
                            tGravityAccMag.std.avg        = mean(tGravityAccMag.std),        
                            tBodyAccJerkMag.mean.avg      = mean(tBodyAccJerkMag.mean),      
                            tBodyAccJerkMag.std.avg       = mean(tBodyAccJerkMag.std),       
                            tBodyGyroMag.mean.avg         = mean(tBodyGyroMag.mean),         
                            tBodyGyroMag.std.avg          = mean(tBodyGyroMag.std),          
                            tBodyGyroJerkMag.mean.avg     = mean(tBodyGyroJerkMag.mean),     
                            tBodyGyroJerkMag.std.avg      = mean(tBodyGyroJerkMag.std),      
                            fBodyAcc.mean.X.avg           = mean(fBodyAcc.mean.X),           
                            fBodyAcc.mean.Y.avg           = mean(fBodyAcc.mean.Y),           
                            fBodyAcc.mean.Z.avg           = mean(fBodyAcc.mean.Z),           
                            fBodyAcc.std.X.avg            = mean(fBodyAcc.std.X),            
                            fBodyAcc.std.Y.avg            = mean(fBodyAcc.std.Y),            
                            fBodyAcc.std.Z.avg            = mean(fBodyAcc.std.Z),            
                            fBodyAccJerk.mean.X.avg       = mean(fBodyAccJerk.mean.X),       
                            fBodyAccJerk.mean.Y.avg       = mean(fBodyAccJerk.mean.Y),       
                            fBodyAccJerk.mean.Z.avg       = mean(fBodyAccJerk.mean.Z),       
                            fBodyAccJerk.std.X.avg        = mean(fBodyAccJerk.std.X),        
                            fBodyAccJerk.std.Y.avg        = mean(fBodyAccJerk.std.Y),        
                            fBodyAccJerk.std.Z.avg        = mean(fBodyAccJerk.std.Z),        
                            fBodyGyro.mean.X.avg          = mean(fBodyGyro.mean.X),          
                            fBodyGyro.mean.Y.avg          = mean(fBodyGyro.mean.Y),          
                            fBodyGyro.mean.Z.avg          = mean(fBodyGyro.mean.Z),          
                            fBodyGyro.std.X.avg           = mean(fBodyGyro.std.X),           
                            fBodyGyro.std.Y.avg           = mean(fBodyGyro.std.Y),           
                            fBodyGyro.std.Z.avg           = mean(fBodyGyro.std.Z),           
                            fBodyAccMag.mean.avg          = mean(fBodyAccMag.mean),          
                            fBodyAccMag.std.avg           = mean(fBodyAccMag.std),           
                            fBodyBodyAccJerkMag.mean.avg  = mean(fBodyBodyAccJerkMag.mean),  
                            fBodyBodyAccJerkMag.std.avg   = mean(fBodyBodyAccJerkMag.std),   
                            fBodyBodyGyroMag.mean.avg     = mean(fBodyBodyGyroMag.mean),     
                            fBodyBodyGyroMag.std.avg      = mean(fBodyBodyGyroMag.std),      
                            fBodyBodyGyroJerkMag.mean.avg = mean(fBodyBodyGyroJerkMag.mean), 
                            fBodyBodyGyroJerkMag.std.avg  = mean(fBodyBodyGyroJerkMag.std)  
                           )
}

CleanTestOrTrainSpaces <- function(test.or.train = "test", directory = "UCI HAR Dataset") {
  ## Removes extraneous spaces from the feature vector data for either the test or
  ## train data set. This function takes advantage of the format of the data being the same 
  ## for both the test and train data sets.
  ##
  ## Args: 
  ##   test.or.train: A character variable that indicates which raw data set to process
  ##                  (the test set or the train set)
  ##   directory: The root directory of where the raw HAR data set resides. 
  ##
  ## Returns:
  ##   The filename of the (new) "despaced" version of either the test or train raw
  ##   feature vector data.
  
  if (!(test.or.train %in% c("test", "train"))) {
    stop("invalid data subset requested; it must be either 'test' or 'train'")
  }
  message(paste("cleaning the", test.or.train, "data set..."))
  in.file <- file.path(directory, test.or.train, paste0("X_", test.or.train, ".txt"))
  if (!file.exists(in.file)) {
    stop(paste("the requested file", in.file, "does not exist"))
  }
  message(paste("reading in raw file", in.file, "..."))
  lines <- readLines(in.file)
  message("removing extraneous spaces in feature data column separators")
  lines <- gsub("  ", " ", lines) ## convert double spaces to a single space
  lines <- gsub("^ ", "", lines)  ## and remove any leading space at the beginning of a line
  ## write out the "despaced" version of the file to a different file
  filename <- paste0("despaced.X_", test.or.train, ".txt")
  despaced.file <- file.path(getwd(), filename)
  message("writing out new 'despaced' data file...")
  writeLines(lines, despaced.file)
  message(paste("new 'despaced' file", filename, "created in the working directory"))
  return(filename)
}

ReadDataAndCreateDataFrame <- function(test.measurements, train.measurements, mean.and.stdev.measurements, directory = "UCI HAR Dataset") {
  ## Reads in mean and standard deviation variables from the HAR feature vector 
  ## data, adds the subject identifiers and activity labels for both the test 
  ## and train data sets and merges them.
  ##
  ## Args:
  ##   test.measurements: The filename of the despaced version of the test feature vector data.
  ##   traing.measurements: The filename of the despaced version of the train feature vector data.
  ##   mean.and.stdev.measurements: A vector of the columns (variables) of interest 
  ##                                subsetted from the complete 561-feature vector.
  ##   directory: The root directory of where the raw HAR data set resides. 
  ##
  ## Returns:
  ##   A data frame of the cleaned and merged test and train data sets.
  
  message("reading in the mean and stdev measurements from the test data set...")
  test.df  <- ReadInDataAndExtractMeasurements(test.measurements, mean.and.stdev.measurements)
  message("adding subject id's and activity labels to test data set...")
  test.df <- AddSubjectIdentifers(test.df, "test")
  test.df <- AddActivityLabels(test.df, "test")
  message(paste(nrow(test.df), "obs of", ncol(test.df), "variables read"))
  message("reading in the mean and stdev measurements from the train data set...")
  train.df <- ReadInDataAndExtractMeasurements(train.measurements, mean.and.stdev.measurements)
  message("adding subject id's and activity labels to train data set...")
  train.df <- AddSubjectIdentifers(train.df, "train")
  train.df <- AddActivityLabels(train.df, "train")
  message(paste(nrow(train.df), "obs of", ncol(train.df), "variables read")) 
  ## merge the test and train data
  rbind(test.df, train.df)  
}

ReadInDataAndExtractMeasurements <- function(filename, means.and.stdevs) {
  ## Reads in a (despaced) raw HAR feature vector data file, subsets it by a vector
  ## of column numbers and assigns meaningful names to the measurement variables
  ## based on a vector of raw measurement names (with "problematic" characters
  ## removed or replaced).
  ##
  ## Args:
  ##   filename: The filename of the despaced version of the feature vector data.
  ##   means.and.stdevs: A data frame of two variables. The first column is the
  ##                     column number of either a mean or standard deviation
  ##                     measurement from the full  561-feature vector and the second
  ##                     column is the measurement variable's name from the HAR data 
  ##                     set's feature.txt file.
  ##
  ## Returns:
  ##   A data frame containing one row for each measurement and a column for each
  ##   measurement that is either a mean or a standard deviation measurement.
  
  require(data.table)
  ## (fast) read in a data.table with only the measurements on the mean and standard 
  ## deviation for each measurement.
  DT <- fread(filename, header=F, sep=" ", select=means.and.stdevs[,1])
  df <- as.data.frame(DT)
  ## give the measurements meaningful names, based on the names of the features
  ## from the features.txt file that comes with the data set
  meaningful.names <- gsub("\\(\\)", "", means.and.stdevs[,2]) ## remove parantheses
  meaningful.names <- gsub("-", ".", meaningful.names)         ## change dashes to dots
  names(df) <- meaningful.names
  df
}

MeasurementsOfInterest <- function(directory = "UCI HAR Dataset") {
  ## Extracts the mean and standard dev measurement column numbers and variable
  ## names from the HAR data set features.txt file. The measurements to extract
  ## are determined from the measurement variable name and are limited to 
  ## measurements for which there is BOTH a mean and standard deviation.
  ##
  ## Args:
  ##   directory: The root directory of where the raw HAR data set resides. 
  ##
  ## Returns:
  ##   A data frame of two variables. The first column is the column number of 
  ##   either a mean or standard deviation measurement from the full 561-feature 
  ##   vector and the second column is the measurement variable's name.
  
  ## read in the list of all the possible features/measurements in the 561-feature vector
  measurements <- read.table(file.path(directory,"features.txt"), stringsAsFactors=F)
  names(measurements) <- c("Col.Number", "Feature")
  ## limit the measurements of interest to only the features that have BOTH a mean and 
  ## standard deviation for each measurement, as per assignment point #2
  measurements <- subset(measurements, grepl("-mean\\(\\)|-std\\(\\)", as.character(measurements$Feature)))
  measurements
}

AddSubjectIdentifers <- function(data, test.or.train = "test", directory = "UCI HAR Dataset") {
  ## Adds subject identifiers to either a test or train set of measurement observations.
  ##
  ## Args:
  ##   data: a data frame of measurement observations
  ##   test.or.train: A character variable that indicates which measurement data set to 
  ##                  add subject identifiers to (the test set or the train set)
  ##   directory: The root directory of where the raw HAR data set resides. 
  ##
  ## Returns:
  ##   A new data frame with the column of subject identifiers PREPENDED to the
  ##   measurement observations. 

  if (!(test.or.train %in% c("test", "train"))) {
    stop("invalid data subset requested; it must be either 'test' or 'train'")
  }
  message(paste("adding subject id's to the", test.or.train, "measurements..."))
  subject.id.file <- file.path(directory, test.or.train, paste0("subject_", test.or.train, ".txt"))
  if (!file.exists(subject.id.file)) {
    stop(paste("the required subject id's file", subject.id.file, "does not exist"))
  }
  message(paste("reading in subject id's file", subject.id.file, "..."))
  subject.id.df <- read.table(subject.id.file)
  SubjectNumber <- subject.id.df[, 1]
  cbind(SubjectNumber, data)
}

AddActivityLabels <- function(data, test.or.train = "test", directory = "UCI HAR Dataset") {
  ## Adds activity labels to either a test or train set of measurement observations.
  ##
  ## Args:
  ##   data: a data frame of measurement observations
  ##   test.or.train: A character variable that indicates which measurement data set to 
  ##                  add subject identifiers to (the test set or the train set)
  ##   directory: The root directory of where the raw HAR data set resides. 
  ##
  ## Returns:
  ##   A new data frame with the column of (meaningful) activity labels APPENDED to the
  ##   measurement observations. 
  
  if (!(test.or.train %in% c("test", "train"))) {
    stop("invalid data subset requested; it must be either 'test' or 'train'")
  }
  message(paste("adding activities to the", test.or.train, "measurements..."))
  activity.file <- file.path(directory, test.or.train, paste0("y_", test.or.train, ".txt"))
  if (!file.exists(activity.file)) {
    stop(paste("the required activity labels file", activity.file, "does not exist"))
  }
  message(paste("reading in activity labels file", activity.file, "..."))
  activity.df <- read.table(activity.file)
  message("reading in activity number to descriptive activity names mapping file...")
  activity.labels.mapping <- ActivityLabelMapping(directory)  
  ActivityLabel <- activity.labels.mapping[activity.df[, 1],2]
  cbind(data, ActivityLabel)
}

ActivityLabelMapping <- function(directory = "UCI HAR Dataset") {
  ## Reads in the activity labels associated with the activity numbers in the
  ## HAR data set (from the activity_labels.txt file).
  ##
  ## Args:
  ##   directory: The root directory of where the raw HAR data set resides. 
  ##
  ## Returns:
  ##   A data frame of two variables. The first column is the activity number and
  ##   the second column is the activity name/label (e.g. 1 = WALKING)
  
  ## read in the list of activity labels
  activity.labels <- read.table(file.path(directory,"activity_labels.txt"), stringsAsFactors=F)
  names(activity.labels) <- c("ActivityNumber", "ActivityLabel")
  activity.labels
}
