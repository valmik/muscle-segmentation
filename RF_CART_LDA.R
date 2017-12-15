library(R.matlab)
library(rpart)
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

full30fs<- readMat('full_30_fs_sample.mat')$sample
full30w1<- readMat('full_30_w1_sample.mat')$sample
full60fs<- readMat('full_60_fs_sample.mat')$sample
full60w1<- readMat('full_60_w1_sample.mat')$sample

#full30fs
#noisy xyz here
x = full30fs[,4]
y = full30fs[,5]
z = full30fs[,6]
intensity=full30fs[,7]
neg_x = full30fs[,8]
pos_x = full30fs[,9]
neg_y = full30fs[,10]
pos_y = full30fs[,11]
neg_z = full30fs[,12]
pos_z = full30fs[,13]
color=full30fs[,14]
full30fs <- data.frame(x, y, z, intensity, neg_x, pos_x, neg_y, pos_y, 
                          neg_z, pos_z, color)
# angle categorical variable 1 means 60 degree, 0 means 30 degree
# weight categorical variable 1 means fs, 0 menas wl
full30fs$angle = 0
full30fs$weight = 1
# random split the data to give the 1st part of training set
set.seed(101)
split = sample.split(full30fs$color, SplitRatio = 0.015)
train30fs <- filter(full30fs, split == TRUE)

#full30w1
#noisy xyz here
x = full30w1[,4]
y = full30w1[,5]
z = full30w1[,6]
intensity=full30w1[,7]
neg_x = full30w1[,8]
pos_x = full30w1[,9]
neg_y = full30w1[,10]
pos_y = full30w1[,11]
neg_z = full30w1[,12]
pos_z = full30w1[,13]
color=full30w1[,14]
full30w1 <- data.frame(x, y, z, intensity, neg_x, pos_x, neg_y, pos_y, 
                       neg_z, pos_z, color)
# angle categorical variable 1 means 60 degree, 0 means 30 degree
# weight categorical variable 1 means fs, 0 menas wl
full30w1$angle = 0
full30w1$weight = 0
# random split the data to give the 2nd part of training set
set.seed(101)
split = sample.split(full30w1$color, SplitRatio = 0.015)
train30w1 <- filter(full30w1, split == TRUE)

#full60fs
#noisy xyz here
x = full60fs[,4]
y = full60fs[,5]
z = full60fs[,6]
intensity=full60fs[,7]
neg_x = full60fs[,8]
pos_x = full60fs[,9]
neg_y = full60fs[,10]
pos_y = full60fs[,11]
neg_z = full60fs[,12]
pos_z = full60fs[,13]
color=full60fs[,14]
full60fs <- data.frame(x, y, z, intensity, neg_x, pos_x, neg_y, pos_y, 
                       neg_z, pos_z, color)
# angle categorical variable 1 means 60 degree, 0 means 30 degree
# weight categorical variable 1 means fs, 0 menas wl
full60fs$angle = 1
full60fs$weight = 1
# random split the data to give the 3rd part of training set
set.seed(101)
split = sample.split(full60fs$color, SplitRatio = 0.015)
train60fs <- filter(full60fs, split == TRUE)

#combining training sets
train <- rbind(train30fs,train30w1,train60fs)


#testingset test60w1
#exact x y z values here
x = full60w1[,1]
y = full60w1[,2]
z = full60w1[,3]
intensity=full60w1[,7]
neg_x = full60w1[,8]
pos_x = full60w1[,9]
neg_y = full60w1[,10]
pos_y = full60w1[,11]
neg_z = full60w1[,12]
pos_z = full60w1[,13]
color=full60w1[,14]
full60w1 <- data.frame(x, y, z, intensity, neg_x, pos_x, neg_y, pos_y, 
                       neg_z, pos_z, color)
full60w1$angle = 1
full60w1$weight = 0
# random split the data to give the testing set
set.seed(101)
split = sample.split(full60w1$color, SplitRatio = 0.04)
test <- filter(full60w1, split == TRUE)




# random forest model
start.time <- Sys.time()
set.seed(101)
RFtype <- randomForest(factor(color) ~ ., data = train)
end.time <- Sys.time()
time.taken.rf <- end.time - start.time
start.time <- Sys.time()
RFtypepred <- predict(RFtype, newdata = test)
end.time <- Sys.time()
time.taken.predict <- end.time - start.time
# accuracy
table_pred<-table(test$color, RFtypepred)
accuracy <- sum(diag(table_pred))/ sum(table_pred)
accuracy


# CART model
# Step1: Begin with a small cp. 
start.time <- Sys.time()
set.seed(123)
tree <- rpart(color ~ ., data = train, method = "class", control = rpart.control(cp = 0.001))
end.time <- Sys.time()
time.taken.cart <- end.time - start.time
printcp(tree)
# Step2: find the smallest cp value
bestcp <- tree$cptable[which.min(tree$cptable[,"xerror"]),"CP"]
# Step3: Prune the tree using the best cp.
tree.pruned <- prune(tree, cp = bestcp)
# Predict the test set
start.time <- Sys.time()
treepred <- predict(tree.pruned, test)
# Use majority rule to change the probability to class prediction
test$predcolorcart = 0
for (i in seq(1, 100000, by=1)){
  num = which(treepred[i,]==max(treepred[i,]))
  if (num==1){
    test[i,14]=0}
  else if (num==2){
    test[i,14]=7}
  else if (num==3){
    test[i,14]=8}
  else if (num==4){
    test[i,14]=9}
  else if (num==5){
    test[i,14]=45}
  else if (num==6){
    test[i,14]=51}
  else if (num==7){
    test[i,14]=52}
  else if (num==8){
    test[i,14]=53}
  else
    test[i,14]=68
}
end.time <- Sys.time()
time.taken.cartpred <- end.time - start.time
# Calculate the accuracy
table_pred<-table(test$color, test$predcolorcart)
accuracy <- sum(diag(table_pred))/ sum(table_pred)
accuracy


# LDA model
library(MASS)
# train
start.time <- Sys.time()
ldacolor <- lda(color ~ ., data = train)
end.time <- Sys.time()
time.taken.lda <- end.time - start.time
# predict
start.time <- Sys.time()
pred <- predict(ldacolor, test)
# Use majority rule to change the probability to class prediction
ldapred <- pred$posterior
test$predcolorlda = 0
for (i in seq(1, 100000, by=1)){
  num = which(ldapred[i,]==max(ldapred[i,]))
  if (num==1){
    test[i,15]=0}
  else if (num==2){
    test[i,15]=7}
  else if (num==3){
    test[i,15]=8}
  else if (num==4){
    test[i,15]=9}
  else if (num==5){
    test[i,15]=45}
  else if (num==6){
    test[i,15]=51}
  else if (num==7){
    test[i,15]=52}
  else if (num==8){
    test[i,15]=53}
  else
    test[i,15]=68
}
end.time <- Sys.time()
time.taken.ldapred <- end.time - start.time
# Calculate the accuracy
table_pred<-table(test$color, test$predcolorlda)
accuracy <- sum(diag(table_pred))/ sum(table_pred)
accuracy