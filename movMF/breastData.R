# Load required libraries
library(mlbench)
library(movMF)
library(tidyverse)

# Load Wisconsin breast cancer data
data(BreastCancer)

# Checking data types of columns
str(BreastCancer)

# Converting all columns to numeric
BreastCancer$Cl.thickness <- as.numeric(as.character(BreastCancer$Cl.thickness))
BreastCancer$Cell.size <- as.numeric(as.character(BreastCancer$Cell.size))
BreastCancer$Cell.shape <- as.numeric(as.character(BreastCancer$Cell.shape))
BreastCancer$Marg.adhesion <- as.numeric(as.character(BreastCancer$Marg.adhesion))
BreastCancer$Cl.thickness <- as.numeric(as.character(BreastCancer$Cl.thickness))
BreastCancer$Epith.c.size <- as.numeric(as.character(BreastCancer$Epith.c.size))
BreastCancer$Bare.nuclei <- as.numeric(as.character(BreastCancer$Bare.nuclei))
BreastCancer$Bl.cromatin <- as.numeric(as.character(BreastCancer$Bl.cromatin))
BreastCancer$Normal.nucleoli <- as.numeric(as.character(BreastCancer$Normal.nucleoli))
BreastCancer$Mitoses <- as.numeric(as.character(BreastCancer$Mitoses))

# Cleaning null rows
BreastCancer <- na.omit(BreastCancer)

# True class labels
true_labels <- BreastCancer$Class

# Checking number of clusters
levels(true_labels)

# Print true labels
print(true_labels)

# Remove ID because it is irrelevant, removing also true_labels
BreastCancer <- BreastCancer[, -1]
BreastCancer <- BreastCancer[, -10]

# Normalizing data
X_normalized <- scale(BreastCancer)

# Converting to matrix
BreastCancer_matrix <- as.matrix(X_normalized)

# Performing movMF clustering
k <- 2 # number of clusters

fit <- movMF(BreastCancer_matrix, k = k)
print(fit)
# Extract cluster assignments
# cluster_assignments <- fit$cluster
# Extract cluster assignments
cluster_assignments <- predict(fit, BreastCancer_matrix)

# Create lookup table
lookup_table <- data.frame(cluster = 1:k, label = levels(true_labels))

# Map cluster assignments to string labels using lookup table
cluster_labels <- lookup_table$label[cluster_assignments]

# Reorder levels of cluster_labels to match true_labels
cluster_labels <- factor(cluster_labels, levels = levels(true_labels))

# Convert to factors
cluster_labels <- as.factor(cluster_labels)
true_labels <- as.factor(true_labels)

# Compute confusion matrix
confusion_matrix <- confusionMatrix(cluster_labels, true_labels)

# Print confusion matrix
print(confusion_matrix)

# Compute recall for each class
recall_benign <- confusion_matrix$table[1, 1] / sum(confusion_matrix$table[1, ])
recall_malign <- confusion_matrix$table[2, 2] / sum(confusion_matrix$table[2, ])

# Compute precision for each class
precision_benign <- confusion_matrix$table[1, 1] / sum(confusion_matrix$table[, 1])
precision_malign <- confusion_matrix$table[2, 2] / sum(confusion_matrix$table[, 2])

# Compute macro recall
macro_recall <- mean(c(recall_benign, recall_malign))

# Compute macro precision
macro_precision <- mean(c(precision_benign, precision_malign))

# Print macro recall and macro precision
print(paste("Macro recall:", macro_recall))
print(paste("Macro precision:", macro_precision))
