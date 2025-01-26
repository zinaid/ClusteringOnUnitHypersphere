# Load libraries
library(tidyverse)
library(movMF)
library(caret)
library(HSAUR2)
library(mlbench)

# Normalize each row by its row sum
rowwise_normalization <- function(data) {
  row_sums <- rowSums(data)
  normalized_data <- sweep(data, 1, row_sums, FUN = "/")
  return(normalized_data)
}

# Load Wisconsin breast cancer data
data(BreastCancer)

# Checking data types of columns
str(BreastCancer)

# Converting all columns to numeric
BreastCancer$Cl.thickness <- as.numeric(as.character(BreastCancer$Cl.thickness))
BreastCancer$Cell.size <- as.numeric(as.character(BreastCancer$Cell.size))
BreastCancer$Cell.shape <- as.numeric(as.character(BreastCancer$Cell.shape))
BreastCancer$Marg.adhesion <- as.numeric(as.character(BreastCancer$Marg.adhesion))
BreastCancer$Epith.c.size <- as.numeric(as.character(BreastCancer$Epith.c.size))
BreastCancer$Bare.nuclei <- as.numeric(as.character(BreastCancer$Bare.nuclei))
BreastCancer$Bl.cromatin <- as.numeric(as.character(BreastCancer$Bl.cromatin))
BreastCancer$Normal.nucleoli <- as.numeric(as.character(BreastCancer$Normal.nucleoli))
BreastCancer$Mitoses <- as.numeric(as.character(BreastCancer$Mitoses))

# Cleaning null rows
BreastCancer <- na.omit(BreastCancer)

# True class labels
true_labels <- BreastCancer$Class

# Remove ID and true_labels
BreastCancer <- BreastCancer[, -1]
BreastCancer <- BreastCancer[, -10]

# Converting to matrix
BreastCancer_matrix <- as.matrix(BreastCancer)

# Applying row-wise normalization
normalized_data <- rowwise_normalization(BreastCancer_matrix)

# Check if the normalized data sums to 1
row_sums <- rowSums(normalized_data)
mean_row_sum <- mean(row_sums)

if (abs(mean_row_sum - 1) < 0.01) {
  print("The data is row-wise normalized.")
} else {
  print("The data is not row-wise normalized.")
}

# Perform clustering using movMF
set.seed(123)
movmf_result <- movMF(normalized_data, k = 2)

# Deriving cluster assignments from the P matrix (probabilities)
cluster_labels <- apply(movmf_result$P, 1, which.max)

# Map cluster assignments to string labels using lookup table
lookup_table <- data.frame(cluster = c(1, 2), label = levels(true_labels))

# Map cluster assignments to string labels
cluster_labels <- lookup_table[cluster_labels, "label"]

# Ensure that cluster_labels and true_labels have the same levels
cluster_labels <- factor(cluster_labels, levels = levels(true_labels))

# Checking levels
print(levels(cluster_labels))
print(levels(true_labels))

# Calculating confusion matrix
confusion_matrix <- confusionMatrix(cluster_labels, true_labels)
print(confusion_matrix)

# Benign
true_positives_benign <- confusion_matrix$table[1, 1]
false_positives_benign <- confusion_matrix$table[1, 2]
false_negatives_benign <- confusion_matrix$table[2, 1]

recall_benign <- true_positives_benign / (true_positives_benign + false_negatives_benign)
precision_benign <- true_positives_benign / (true_positives_benign + false_positives_benign)

# Malign
true_positives_malign <- confusion_matrix$table[2, 2]
false_positives_malign <- confusion_matrix$table[2, 1]
false_negatives_malign <- confusion_matrix$table[1, 2]

recall_malign <- true_positives_malign / (true_positives_malign + false_negatives_malign)
precision_malign <- true_positives_malign / (true_positives_malign + false_positives_malign)

macro_recall <- mean(c(recall_benign, recall_malign))
macro_precision <- mean(c(precision_benign, precision_malign))

print(paste("Recall:", macro_recall))
print(paste("Precision:", macro_precision))
