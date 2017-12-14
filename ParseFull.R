library(R.matlab)
library(caTools)

setwd("~/Desktop/College/4.10/IEOR 142/Project/InitialDickingAround")

full <- readMat('full_30_fs.mat')$full
x = full[,1]
y = full[,2]
z = full[,3]
noisex = full[,4]
noisey = full[,5]
noisez= full[,6]
intensity=full[,7]
neg_x = full[,8]
pos_x = full[,9]
neg_y = full[,10]
pos_y = full[,11]
neg_z = full[,12]
pos_z = full[,13]
color=full[,14]

rm(full)
gc()

full_set <- data.frame(x, y, z, noisex, noisey, noisez, 
                       intensity, neg_x, pos_x, neg_y, 
                       pos_y, neg_z, pos_z, color)

rm(x, y, z, noisex, noisey, noisez, intensity, neg_x,
   pos_x, neg_y, pos_y, neg_z, pos_z, color)
gc()

table(full_set$color)

split = sample.split(full_set$color, SplitRatio = 0.1)
set.train = subset(full_set, split == TRUE)
