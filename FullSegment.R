library(rpart)
library(caret)
library(gbm)
library(dplyr)
library(ggplot2)
library(GGally)
library(ROCR)

setwd("~/Desktop/College/4.10/IEOR 142/Project/Final")
source("UtilityFunctions.R")

library(caTools)
library(randomForest)



#read training set and testing set

#full30fs
#noisy xyz here
full30fs <- ReadFuzzy(name = 'full_30_fs_sample.mat')
split = sample.split(full30fs$color, SplitRatio = 0.1)
full30fs <- subset(full30fs, split == TRUE)

# angle categorical variable 1 means 60 degree, 0 means 30 degree
# weight categorical variable 1 means fs, 0 menas wl
full30fs$angle = 0
full30fs$weight = 1

#full60fs
#noisy xyz here
full60fs <- ReadFuzzy(name = 'full_60_fs_sample.mat')
split = sample.split(full60fs$color, SplitRatio = 0.1)
full60fs <- subset(full60fs, split == TRUE)
# angle categorical variable 1 means 60 degree, 0 means 30 degree
# weight categorical variable 1 means fs, 0 menas wl
full60fs$angle = 1
full60fs$weight = 1

#full60w1
#noisy xyz here
full60w1 <- ReadFuzzy(name = 'full_60_w1_sample.mat')
split = sample.split(full60w1$color, SplitRatio = 0.1)
full60w1 <- subset(full60w1, split == TRUE)
# angle categorical variable 1 means 60 degree, 0 means 30 degree
# weight categorical variable 1 means fs, 0 menas wl
full60w1$angle = 1
full60w1$weight = 0

train <- rbind(full30fs, full60fs, full60w1)

rm(full30fs, full60fs, full60w1, split)
gc()

# random forest model
start.time <- Sys.time()
set.seed(101)
RFtype <- randomForest(factor(color) ~ ., data = train)
end.time <- Sys.time()
time.taken.rf <- end.time - start.time


# Load test set
test <- ReadFull(name = 'full_30_w1.mat')
test$angle = 0
test$weight = 0
check <- head(test, 5000000)



start.time <- Sys.time()
RFtypepred <- predict(RFtype, newdata = test)
end.time <- Sys.time()
time.taken.predict <- end.time - start.time

# accuracy
table_pred<-table(test$color, RFtypepred)
accuracy <- sum(diag(table_pred))/ sum(table_pred)
accuracy


test$seg <- RFtypepred

newseg = data.frame()
newseg$x <- test$x
y <- test$y
z <- test$z
seg <- test$seg

writeMat('new_30_w1.mat', x=x, y=y, z=z, seg=seg)
write.csv(newseg, file = 'new_30_w1.csv', row.names = FALSE)
