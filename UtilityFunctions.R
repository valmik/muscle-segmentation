# A couple utility functions to clean up the full segment code

library(R.matlab)

# -------------------------------------- ReadNorm -----------------
ReadNorm <- function(name) {
  
  data <- readMat(name)$sample
  x = data[,1]
  y = data[,2]
  z = data[,3]
  intensity=data[,7]
  neg_x = data[,8]
  pos_x = data[,9]
  neg_y = data[,10]
  pos_y = data[,11]
  neg_z = data[,12]
  pos_z = data[,13]
  color=data[,14]
  data <- data.frame(x, y, z, intensity, neg_x, pos_x, neg_y, pos_y, 
                         neg_z, pos_z, color)
  
  return(data)
}


# -------------------------------------- ReadFuzzy -----------------
ReadFuzzy <- function(name) {
  
  data <- readMat(name)$sample
  x = data[,4]
  y = data[,5]
  z = data[,6]
  intensity=data[,7]
  neg_x = data[,8]
  pos_x = data[,9]
  neg_y = data[,10]
  pos_y = data[,11]
  neg_z = data[,12]
  pos_z = data[,13]
  color=data[,14]
  data <- data.frame(x, y, z, intensity, neg_x, pos_x, neg_y, pos_y, 
                     neg_z, pos_z, color)
  
  return(data)
}

# -------------------------------------- ReadFull -----------------
ReadFull <- function(name) {
  
  data <- readMat(name)$full
  x = data[,1]
  y = data[,2]
  z = data[,3]
  intensity=data[,7]
  neg_x = data[,8]
  pos_x = data[,9]
  neg_y = data[,10]
  pos_y = data[,11]
  neg_z = data[,12]
  pos_z = data[,13]
  color=data[,14]
  data <- data.frame(x, y, z, intensity, neg_x, pos_x, neg_y, pos_y, 
                     neg_z, pos_z, color)
  
  return(data)
}


