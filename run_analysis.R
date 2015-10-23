run_analysis <- function () {
if (!file.exists("Dataset.zip")) { 
	print("It's necessary that Dataset.zip file exists in this directory!");
	return(1);
}
print("Dataset.zip exists! Continuing...");
print("Unzipping file ............................... [Dataset.zip]");
unzip("Dataset.zip");
print(".............................................. [Done!]");
setwd("./UCI HAR Dataset");
print("Readding files to data frames................. [features{feature.txt}, activity{activity_labels.txt}]");
features <- read.table("features.txt", col.names=c("id_features","features"));
activity <- read.table("activity_labels.txt", col.names=c("id_activity","activity"));
print(".............................................. [Done!]");
library(sqldf);
print("Getting features columns names................ [colnames{features}]");
colnames <- sqldf("SELECT id_features, features FROM features WHERE features LIKE '%mean()%' OR features LIKE '%std()%'");
print(".............................................. [Done!]");
print("");
print("############WORKING WITH TEST DATA############");
print("");
print("Readding file and aplying columns names....... [X_test{./test/X_test.txt}]");
X_test <- read.table("./test/X_test.txt");
X_test <- X_test[,colnames$id_features];
names(X_test) <- colnames$features;
print(".............................................. [Done!]");
print("Readding file to data frame................... [subject_test{./test/subject_test.txt}]");
subject_test <- read.table("./test/subject_test.txt", col.names=c("subject"));
print(".............................................. [Done!]");
print("Readding file to data frame................... [y_test{./test/y_test.txt}]");
y_test <- read.table("./test/y_test.txt", col.names=c("id_activity"));
print(".............................................. [Done!]");
print("Bindding data frames.......................... [test{subject_test, X_test, y_test}]");
test <- cbind(subject_test, X_test, y_test);
print(".............................................. [Done!]");
print("Mergging data frames.......................... [test, activity]");
test <- merge(test, activity, by.x="id_activity", by.y="id_activity");
print(".............................................. [Done!]");
print("");
print("############WORKING WITH TRAIN DATA###########");
print("");
print("Readding file and aplying columns names....... [X_train{./train/X_train.txt}]");
X_train <- read.table("./train/X_train.txt");
X_train <- X_train[,colnames$id_features];
names(X_train) <- colnames$features;
print(".............................................. [Done!]");
print("Readding file to data frame................... [subject_train{./train/subject_train.txt}]");
subject_train <- read.table("./train/subject_train.txt", col.names=c("subject"));
print(".............................................. [Done!]");
print("Readding file to data frame................... [y_train{./train/y_train.txt}]");
y_train <- read.table("./train/y_train.txt", col.names=c("id_activity"));
print(".............................................. [Done!]");
print("Bindding data frames.......................... [train{subject_train, X_train, y_train}]");
train <- cbind(subject_train, X_train, y_train);
print(".............................................. [Done!]");
print("Mergging data frames.......................... [train, activity]");
train <- merge(train, activity, by.x="id_activity", by.y="id_activity");
print(".............................................. [Done!]");
print("Bindding data frames.......................... [test, train]");
t0 <- rbind(test, train);
print(".............................................. [Done!]");
print("");
print("#############CALCULATING AVERAGES#############");
print("");
project <- data.frame(-1);
print("Selectting subjects and activities............ [Bidded data frame{test, train}]");
subjects <- sqldf("SELECT DISTINCT subject FROM t0 ORDER BY subject");
activities <- sqldf("SELECT DISTINCT id_activity, activity FROM t0 ORDER BY id_activity");
print(".............................................. [Done!]");
print("Calculating averages.......................... [mean{subject ~ activity}]");
for (s in 1:nrow(subjects)) {
	for (a in 1:nrow(activities)) {
		sql <- sprintf("SELECT * FROM t0 WHERE subject=%s AND id_activity=%s", s, a);
		t1 <- sqldf(sql);
		t2 <- data.frame();
		t2[1,1] <- activities[a,1];
		t2[1,2] <- subjects[s,1];
		for (c in 3:(ncol(t1)-1)) { t2[1,c] <- mean(t1[,c]); }
		t2[1,69] <- activities[a,2];
		if (project[1,1] == -1) { project <- t2; }
		else { project <- rbind(project, t2); }
	}
}
print(".............................................. [Done!]");
names(project) <- names(t0);
project;
}
