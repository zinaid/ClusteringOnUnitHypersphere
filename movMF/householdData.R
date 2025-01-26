# Loading libraries
library(tidyverse)
library(movMF)
library(caret)
library(HSAUR2)

# Loading dataset household
data(household)

# Normalize each row by its row sum
rowwise_normalization <- function(data) {
  row_sums <- rowSums(data)
  normalized_data <- sweep(data, 1, row_sums, FUN = "/")
  return(normalized_data)
}

# Taking true labels
true_labels <- household$gender
print(true_labels)

# Removing the cluster column/true label
household <- household[, -5]

household_matrix <- as.matrix(household)

# Normalizing data and transforming it to matrix
normalized_data <- rowwise_normalization(household_matrix)

# Check if data belongs to the unit sphere
norms <- sqrt(rowSums(normalized_data^2))
mean_norm <- mean(norms)

if (abs(mean_norm - 1) < 0.01) {
  print("The data belongs to the unit sphere.")
} else {
  print("The data does not belong to the unit sphere.")
}

# Perform clustering using movMF
#set.seed(123)
movmf_result <- movMF(normalized_data, k = 2)

# Check structure of movmf_result
str(movmf_result)

# Deriving cluster assignments from the P matrix (probabilities)
cluster_labels <- apply(movmf_result$P, 1, which.max)

# Map cluster assignments to string labels using lookup table
lookup_table <- data.frame(cluster = c(2, 1), label = levels(true_labels))

# Map cluster assignments to string labels using lookup table
cluster_labels <- lookup_table[cluster_labels, "label"]

# Ensure that cluster_labels and true_labels have the same levels
cluster_labels <- factor(cluster_labels, levels = levels(true_labels))

# Checking levels
print(levels(cluster_labels))
print(levels(true_labels))

# Calculating confusion matrix
confusion_matrix <- confusionMatrix(cluster_labels, true_labels)
print(confusion_matrix)

# Female
true_positives_female <- confusion_matrix$table[1, 1]
false_positives_female <- confusion_matrix$table[1, 2]
false_negatives_female <- confusion_matrix$table[2, 1]

macro_recall_female <- true_positives_female / (true_positives_female + false_negatives_female)
macro_precision_female <- true_positives_female / (true_positives_female + false_positives_female)

# Male
true_positives_male <- confusion_matrix$table[2, 2]
false_positives_male <- confusion_matrix$table[2, 1]
false_negatives_male <- confusion_matrix$table[1, 2]

macro_recall_male <- true_positives_male / (true_positives_male + false_negatives_male)
macro_precision_male <- true_positives_male / (true_positives_male + false_positives_male)

macro_recall <- mean(c(macro_recall_female, macro_recall_male))
macro_precision <- mean(c(macro_precision_female, macro_precision_male))

print(paste("Recall:", macro_recall))
print(paste("Precision:", macro_precision))