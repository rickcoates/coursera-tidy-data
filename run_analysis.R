run_analysis <- function(download.data = F, directory = "UCI HAR Dataset") {
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
  despaced.test.filename  <- CleanTestOrTrainSpaces("test", directory)
  despaced.train.filename <- CleanTestOrTrainSpaces("train", directory)
  ## determine the measurements to extract from the test and train data sets based on
  ## the names of the features given in the features.txt file that comes with the data set
  message("determining features with both mean and stdev measurements...")
  mean.and.stdev.measurements <- MeasurementsOfInterest(directory)
  ## read in the data sets and only the features with both mean and stdev measurements
  ## merge the test and train data sets
  tidy.data <- ReadDataAndCreateDataFrame(despaced.test.filename, despaced.train.filename, mean.and.stdev.measurements, directory)
  tidy.data
}

CreateSecondTidyDataSet <- function(data) {
  require(plyr)
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
  ## read in the list of all the possible features/measurements in the 561-feature vector
  measurements <- read.table(file.path(directory,"features.txt"), stringsAsFactors=F)
  names(measurements) <- c("Col.Number", "Feature")
  ## limit the measurements of interest to only the features that have BOTH a mean and 
  ## standard deviation for each measurement, as per assignment point #2
  measurements <- subset(measurements, grepl("-mean\\(\\)|-std\\(\\)", as.character(measurements$Feature)))
  measurements
}

ActivityLabelMapping <- function(directory = "UCI HAR Dataset") {
  ## read in the list of activity labels
  activity.labels <- read.table(file.path(directory,"activity_labels.txt"), stringsAsFactors=F)
  names(activity.labels) <- c("ActivityNumber", "ActivityLabel")
  activity.labels
}

AddSubjectIdentifers <- function(data, test.or.train = "test", directory = "UCI HAR Dataset") {
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
