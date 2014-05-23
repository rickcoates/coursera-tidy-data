### Introduction

The functions in the run_analysis.R file implement a solution to the Course Project for the Coursera Data Science Specialization Getting and Cleaning Data MOOC.

The stated purpose of the project/assignment is to "demonstrate an ability to collect, work with, and clean a data set, with the ultimate goal of preparing a tidy data that can be used for later analysis."

The "unclean" data to be "tidied" is a data set collected from the accelerometers in Samsung Galaxy S smartphones, known as the "Human Activity Recognition (HAR) Using Smartphones Dataset Version 1.0." The raw/untidy data consist of both training and test data (that are to be combined). For the purpose of this analysis (and the specific requirements of the Course Project) the raw triaxial acceleration data from the smartphone's accelerometer (total acceleration), the estimated body  acceleration data, and the triaxial angular velocity from the smartphone's gyroscope (contained in *Inertial Signals* subdirectories of the raw HAR data set) are **not** considered. Rather, the tidy data set for later analysis is constructed from a 561-feature vector of time and frequency domain variables for each observation (*X_test.txt* and *X_train.txt* files), the activity number/label associated with the feature vector (*y_test.txt* and *y_train.txt* files) and the (numeric/anonymized) identifier of the human subject who carried the smartphone (*subject_test.txt* and *subject_train.txt* files). For details on the resulting (second, independent) tidy data set, see CodeBook.md.

### Running the Analysis

The main analysis, which creates the second tidy data set (as defined by the assignment), can be run by calling the `run_analysis` function.  

	run_analysis <- function(download.data = F, directory = "UCI HAR Dataset")

To download the raw HAR data from source, set `download.data = TRUE`. To change the root directory of where the data set resides (or where it should be placed if downloaded from source), set the `directory` parameter to the desired directory.

A data.frame containing the second tidy data set, as defined in CodeBook.md, is returned. The same data set is also saved as a CSV format file, named *HAR_Tidy_Summarized.txt*, to the working directory.

If the first (unsummarized) tidy data set is of interest, it can be created independently as follows:

	  despaced.test.filename  <- CleanTestOrTrainSpaces("test", directory)
	  despaced.train.filename <- CleanTestOrTrainSpaces("train", directory)
	  mean.and.stdev.measurements <- MeasurementsOfInterest(directory)
	  tidy.data <- ReadDataAndCreateDataFrame(despaced.test.filename, 
	  					despaced.train.filename, 
	  					mean.and.stdev.measurements, 
	  					directory)

where the `directory` parameter is the root directory of the raw HAR data set.

### Summary of the Analysis Performed

#### Step 1

Extraneous spaces are removed from the measurement data file for both the test and train data sets (*X_test.txt* and *X_train.txt*), so it is possible to (fast) read in measurement data using the fread function in the `data.table` package, *plus*,(simultaneously) subset the data set to the columns of interest (measurements with both mean and standard deviation statistics). 

The result of this step are new "despaced" versions of the *X_test.txt* and *X_train.txt* files, named *despaced.X_test.txt* and *despaced.X_train.txt* respectively.

The function that performs this step is:

	CleanTestOrTrainSpaces <- function(test.or.train = "test", directory = "UCI HAR Dataset")

which is run twice. Once for the test data set and once for the train data set.

#### Step 2

Determine the measurements to extract from the test and train data sets based on the names of the features given in the *features.txt* file that comes with the HAR data set.

The function that performs this step is:

	MeasurementsOfInterest <- function(directory = "UCI HAR Dataset") 

The method for determining which features/measurements to extract is to `regex` on the measurement variable names (as defined in the HAR data set's *features.txt* file) and subset on names that contain `-mean()` or `-std()`. Note that this eliminates the `*-meanFreq()` measurements/variables on the assumption that, since there is no corresponding standard deviation measurement for the variable, the `*-meanFreq()` variables should be excluded, which satisfies Course Project requirement #2:

* Extracts only the measurements on the mean and standard deviation for each measurement.

#### Step 3

1. Read in the "despaced" test and train data sets created in **Step 1**, but only the columns containing features with both mean and standard deviation measurements, as determined in **Step 2**.
2. Clean up the measurement variable names so they are meaningful/readable.
3. Add in the activity label column (with meaning activity label names rather than the activity label *numbers* in the raw *y_test.txt* and *y_train.txt* files) 
4. Add in the subject id column
5. Merge the test and train data sets.

The function that performs this step is:

	ReadDataAndCreateDataFrame <- function(test.measurements, train.measurements, mean.and.stdev.measurements, directory = "UCI HAR Dataset") 
 
This step satisfies Course Project requirements #1, #2 (in combination with **Step 2**), #3 and #4:

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive activity names. 

#### Step 4

Create a second, independent tidy data set  that summarizes all of the measurement variables in the first tidy data set (created in **Steps 1 - 3**) *by activity (label) and subject*. The name of the summarized (average/mean) version of the each measurement variable is set to be name of the original variable with `.avg` appended. The result contains 180 observations (30 subjects * 6 different activities) of the 66 summarized measurements of interest (in contrast to the 10,299 total observations for the 66 measurements of interest in the first tidy data set). For more details on the second (final result) tidy data set, see CodeBook.md. 

The function that performs this step is:

	CreateSecondTidyDataSet <- function(data) 
 
This step satisfies Course Project requirements #5:

* Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Versions and Packages Used

**R Version:** 3.0.3 (2014-03-06) a.k.a Warm Puppy

####Packages:
* plyr 1.8.1
* data.table 1.9.1
 
### Complete List of Analysis Functions

**ActivityLabelMapping** - Reads in the activity labels associated with the activity numbers in the HAR data set (from the activity_labels.txt file).

**AddActivityLabels** - Adds activity labels to either a test or train set of measurement observations.

**AddSubjectIdentifers** - Adds subject identifiers to either a test or train set of measurement observations.

**CleanTestOrTrainSpaces** -   Removes extraneous spaces from the feature vector data for either the test or train data set. This function takes advantage of the format of the data being the same for both the test and train data sets.

**CreateSecondTidyDataSet** - Creates a second tidy data set that contains summary statistics of first tidy data set.

**MeasurementsOfInterest** -   Extracts the mean and standard dev measurement column numbers and variable names from the HAR data set features.txt file. The measurements to extract are determined from the measurement variable name and are limited to measurements for which there is BOTH a mean and standard deviation.

**ReadDataAndCreateDataFrame** -   Reads in mean and standard deviation variables from the HAR feature vector data, adds the subject identifiers and activity labels for both the test and train data sets and merges them.

**ReadInDataAndExtractMeasurements** -   Reads in a (despaced) raw HAR feature vector data file, subsets it by a vector of column numbers and assigns meaningful names to the measurement variables based on a vector of raw measurement names (with "problematic" characters removed or replaced).

**run_analysis** - Runs the complete analysis, including (optionally) downloading the data set from source.





