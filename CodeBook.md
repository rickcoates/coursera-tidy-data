### Introduction

This Code Book documents the "second, independent tidy data set" as required by the Course Project for the Coursera Data Science Specialization Getting and Cleaning Data MOOC.

The stated purpose of the project/assignment is to "demonstrate an ability to collect, work with, and clean a data set, with the ultimate goal of preparing a tidy data that can be used for later analysis."

The "unclean" data to be "tidied" is a data set collected from the accelerometers in Samsung Galaxy S smartphones, known as the "Human Activity Recognition (HAR) Using Smartphones Dataset Version 1.0." The raw/untidy data consist of both training and test data (that are to be combined). For the purpose of this analysis (and the specific requirements of the Course Project) the raw triaxial acceleration data from the smartphone's accelerometer (total acceleration), the estimated body  acceleration data, and the triaxial angular velocity from the smartphone's gyroscope (contained in *Inertial Signals* subdirectories of the raw HAR data set) are **not** considered. Rather, a first tidy data set for later analysis is constructed from a 561-feature vector of time and frequency domain variables for each observation (*X_test.txt* and *X_train.txt* files), the activity number/label associated with the feature vector (*y_test.txt* and *y_train.txt* files) and the (numeric/anonymized) identifier of the human subject who carried the smartphone (*subject_test.txt* and *subject_train.txt* files). 

The second, independent tidy data set summarizes all of the measurement variables in the first tidy data set *by activity (label) and subject*. The name of the summarized (average/mean) version of the each measurement variable is set to be name of the original variable with `.avg` appended. The result contains 180 observations (30 subjects * 6 different activities) of the 66 summarized measurements of interest (in contrast to the 10,299 total observations for the 66 measurements of interest in the first tidy data set).

This second, independent tidy data set is created by running functions in `run_analysis.R`. See the README.md and/or the comments/documentation in the `run_analysis.R` file for details on how the analysis is performed.

### Summary of the Data Set

* Column 1: The observation (row) number.
* Column 2: The observed **ActivityLabel** associated with the (summary statistics of) observation measurements. Possible values are WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, or LAYING.
* Column 3: A **SubjectNumber** in the range 1-30, representing an anonymized identifier for each unique subject (person) who was carrying the smartphone related to the (summary statistics of) observation measurements. 
* Columns 4-69: Averages of summary statistics, specifically means (**mean**) or standard deviations (**std**) of tri-axial (three-dimensions: **X**, **Y** and **Z**) accelerometer (**Acc**) *or* gyroscope (**Gyro**) measurements in either the *time domain* (**t** prefix, columns 4-43) or the *frequency domain* (**f** prefix, columns 44-69). *Note that the observation measurement means and standard deviations are all normalized and bounded within [-1,1]*.

### Detailed Data Set Definition

1. The row number.
2. **ActivityLabel**: The observed activity associated with the (summary) observation measurements. Possible values are WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, or LAYING.
3. **SubjectNumber**: A number in the range 1-30, representing an anonymized identifier for each unique subject (person) who was carrying the smartphone related to the (summary) observation measurements. 4. **tBodyAcc.mean.X.avg**: Average of the means of time domain body acceleration measurements in the X dimension.
5. **tBodyAcc.mean.Y.avg**: Average of the means of time domain body acceleration measurements in the Y dimension.
6. **tBodyAcc.mean.Z.avg**: Average of the means of time domain body acceleration measurements in the Z dimension.
7. **tBodyAcc.std.X.avg**: Average of the standard deviations of time domain body acceleration measurements in the X dimension.
8. **tBodyAcc.std.Y.avg**: Average of the standard deviations of time domain body acceleration measurements in the Y dimension.
9. **tBodyAcc.std.Z.avg**: Average of the standard deviations of time domain body acceleration measurements in the Z dimension.
10. **tGravityAcc.mean.X.avg**: Average of the means of time domain gravity acceleration measurements in the X dimension.
11. **tGravityAcc.mean.Y.avg**: Average of the means of time domain gravity acceleration measurements in the Y dimension.
12. **tGravityAcc.mean.Z.avg**: Average of the means of time domain gravity acceleration measurements in the Z dimension.
13. **tGravityAcc.std.X.avg**: Average of the standard deviations of time domain gravity acceleration measurements in the X dimension.
14. **tGravityAcc.std.Y.avg**: Average of the standard deviations of time domain gravity acceleration measurements in the Y dimension.
15. **tGravityAcc.std.Z.avg**: Average of the standard deviations of time domain gravity acceleration measurements in the Z dimension.
16. **tBodyAccJerk.mean.X.avg**: Average of the means of time domain body acceleration (jerk) measurements in the X dimension.
17. **tBodyAccJerk.mean.Y.avg**: Average of the means of time domain body acceleration (jerk) measurements in the Y dimension.
18. **tBodyAccJerk.mean.Z.avg**: Average of the means of time domain body acceleration (jerk) measurements in the Z dimension.
19. **tBodyAccJerk.std.X.avg**: Average of the standard deviations of time domain body acceleration (jerk) measurements in the X dimension.
20. **tBodyAccJerk.std.Y.avg**: Average of the standard deviations of time domain body acceleration (jerk) measurements in the Y dimension.
21. **tBodyAccJerk.std.Z.avg**: Average of the standard deviations of time domain body acceleration (jerk) measurements in the Z dimension.
22. **tBodyGyro.mean.X.avg**: Average of the means of time domain body gyroscope measurements in the X dimension.
23. **tBodyGyro.mean.Y.avg**: Average of the means of time domain body gyroscope measurements in the Y dimension.
24. **tBodyGyro.mean.Z.avg**: Average of the means of time domain body gyroscope measurements in the Z dimension.
25. **tBodyGyro.std.X.avg**: Average of the standard deviations of time domain body gyroscope measurements in the X dimension.
26. **tBodyGyro.std.Y.avg**: Average of the standard deviations of time domain body gyroscope measurements in the Y dimension.
27. **tBodyGyro.std.Z.avg**: Average of the standard deviations of time domain body gyroscope measurements in the Z dimension.
28. **tBodyGyroJerk.mean.X.avg**: Average of the means of time domain body gyroscope (jerk) measurements in the X dimension.
29. **tBodyGyroJerk.mean.Y.avg**: Average of the means of time domain body gyroscope (jerk) measurements in the Y dimension.
30. **tBodyGyroJerk.mean.Z.avg**: Average of the means of time domain body gyroscope (jerk) measurements in the Z dimension.
31. **tBodyGyroJerk.std.X.avg**: Average of the standard deviations of time domain body gyroscope (jerk) measurements in the X dimension.
32. **tBodyGyroJerk.std.Y.avg**: Average of the standard deviations of time domain body gyroscope (jerk) measurements in the Y dimension.
33. **tBodyGyroJerk.std.Z.avg**: Average of the standard deviations of time domain body gyroscope (jerk) measurements in the Z dimension.
34. **tBodyAccMag.mean.avg**: Average of the means of time domain body acceleration (mag) measurements.
35. **tBodyAccMag.std.avg**: Average of the standard deviations of time domain body acceleration (mag) measurements.
36. **tGravityAccMag.mean.avg**: Average of the means of time domain gravity acceleration (mag) measurements.
37. **tGravityAccMag.std.avg**: Average of the standard deviations of time domain body acceleration (mag) measurements.
38. **tBodyAccJerkMag.mean.avg**: Average of the means of time domain body (jerk) acceleration (mag) measurements.
39. **tBodyAccJerkMag.std.avg**: Average of the standard deviation of time domain body (jerk) acceleration (mag) measurements.
40. **tBodyGyroMag.mean.avg**: Average of the means of time domain body gyroscope (mag) measurements.
41. **tBodyGyroMag.std.avg**: Average of the standard deviations of time domain body gyroscope (mag) measurements.
42. **tBodyGyroJerkMag.mean.avg**: Average of the means of time domain body (jerk) gyroscope (mag) measurements.
43. **tBodyGyroJerkMag.std.avg**: Average of the standard deviations of time domain body (jerk) gyroscope (mag) measurements.
44. **fBodyAcc.mean.X.avg**: Average of the means of frequency domain body acceleration measurements in the X dimension.
45. **fBodyAcc.mean.Y.avg**: Average of the means of frequency domain body acceleration measurements in the Y dimension.
46. **fBodyAcc.mean.Z.avg**: Average of the means of frequency domain body acceleration measurements in the Z dimension.
47. **fBodyAcc.std.X.avg**: Average of the standard deviations of frequency domain body acceleration measurements in the X dimension.
48. **fBodyAcc.std.Y.avg**: Average of the standard deviations of frequency domain body acceleration measurements in the Y dimension.
49. **fBodyAcc.std.Z.avg**: Average of the standard deviations of frequency domain body acceleration measurements in the Z dimension.
50. **fBodyAccJerk.mean.X.avg**: Average of the means of frequency domain body acceleration (jerk) measurements in the X dimension.
51. **fBodyAccJerk.mean.Y.avg**: Average of the means of frequency domain body acceleration (jerk) measurements in the Y dimension.
52. **fBodyAccJerk.mean.Z.avg**: Average of the means of frequency domain body acceleration (jerk) measurements in the Z dimension.
53. **fBodyAccJerk.std.X.avg**: Average of the standard deviations of frequency domain body acceleration (jerk) measurements in the X dimension.
54. **fBodyAccJerk.std.Y.avg**: Average of the standard deviations of frequency domain body acceleration (jerk) measurements in the Y dimension.
55. **fBodyAccJerk.std.Z.avg**: Average of the standard deviations of frequency domain body acceleration (jerk) measurements in the Z dimension.
56. **fBodyGyro.mean.X.avg**: Average of the means of frequency domain body gyroscope measurements in the X dimension.
57. **fBodyGyro.mean.Y.avg**: Average of the means of frequency domain body gyroscope measurements in the Y dimension.
58. **fBodyGyro.mean.Z.avg**: Average of the means of frequency domain body gyroscope measurements in the Z dimension.
59. **fBodyGyro.std.X.avg**: Average of the standard deviations of frequency domain body gyroscope measurements in the X dimension.
60. **fBodyGyro.std.Y.avg**: Average of the standard deviations of frequency domain body gyroscope measurements in the Y dimension.
61. **fBodyGyro.std.Z.avg**: Average of the standard deviations of frequency domain body gyroscope measurements in the Z dimension.
62. **fBodyAccMag.mean.avg**: Average of the means of frequency domain body acceleration (mag) measurements.
63. **fBodyAccMag.std.avg**: Average of the standard deviations of frequency domain body acceleration (mag) measurements.
64. **fBodyBodyAccJerkMag.mean.avg**: Average of the means of frequency domain body (jerk) acceleration (mag) measurements.
65. **fBodyBodyAccJerkMag.std.avg**: Average of the standard deviations of frequency domain body (jerk) acceleration (mag) measurements.
66. **fBodyBodyGyroMag.mean.avg**: Average of the means of frequency domain body gyroscope (mag) measurements.
67. **fBodyBodyGyroMag.std.avg**: Average of the standard deviations of frequency domain body gyroscope (mag) measurements.
68. **fBodyBodyGyroJerkMag.mean.avg**: Average of the means of frequency domain body (jerk) gyroscope (mag) measurements.
69. **fBodyBodyGyroJerkMag.std.avg**: Average of the standard deviations of frequency domain body (jerk) gyroscope (mag) measurements.

