setwd("~/Desktop/College/4.10/IEOR 142/Project/InitialDickingAround")

library(R.matlab)
library(rpart)
library(rpart.plot)
library(caret)
library(randomForest)
library(gbm)
library(caTools)
library(dplyr)
library(ggplot2)
library(GGally)
library(caTools)
library(ROCR)

#read training set and testing set

train4 <- readMat('DataSets (old)/train_30_w1.mat')$train

#actually fuzzy x y z values
x = train4[,4] 
y = train4[,5]
z= train4[,6]

intensity=train4[,7]
neg_x = train4[,8]
pos_x = train4[,9]
neg_y = train4[,10]
pos_y = train4[,11]
neg_z = train4[,12]
pos_z = train4[,13]
color=train4[,14]

train4 <- data.frame(x, y, z, intensity, neg_x, pos_x, neg_y, pos_y, 
                     neg_z, pos_z, color)
table(train4$color)


test <- readMat('test_30_fs.mat')$test
x = test[,1]
y = test[,2]
z = test[,3]
noisex = test[,4]
noisey = test[,5]
noisez= test[,6]
intensity=test[,7]
neg_x = test[,8]
pos_x = test[,9]
neg_y = test[,10]
pos_y = test[,11]
neg_z = test[,12]
pos_z = test[,13]
color=test[,14]

test <- data.frame(x, y, z, intensity, neg_x, pos_x, neg_y, pos_y, 
                   neg_z, pos_z, color)
table(test$color)


# 
# # random split the data
# set.seed(303)
# split = sample.split(train4$color, SplitRatio = 0.2)
# muscle.train <- filter(train4, split == TRUE)
# split = sample.split(test$color, SplitRatio = 0.2)
# muscle.test <- filter(test, split == TRUE)


#Apply Random Forest
set.seed(101)
RFmod <- randomForest(factor(color) ~ ., data = train4)
RFpred <- predict(RFmod, newdata = test)
table_pred<-table(test$color, RFpred)
accuracy <- sum(diag(table_pred))/ sum(table_pred)
accuracy

