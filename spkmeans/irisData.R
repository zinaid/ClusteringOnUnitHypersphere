# Load libraries
library(tidyverse)
library(skmeans)
library(cluster)
library(caret)

# Load Iris dataset
data(iris)

# Normalize each row by its row sum
rowwise_normalization <- function(data) {
  row_sums <- rowSums(data)
  normalized_data <- sweep(data, 1, row_sums, FUN = "/")
  return(normalized_data)
}

# True class labels
true_labels <- iris$Species
# Create a vector of the new class labels
new_class_labels <- as.integer(true_labels)

# Replace the original class labels with the new class labels
iris$Species <- new_class_labels
# Print true labels
print(true_labels)

# Removing true labels
iris <- iris[, -5]

iris_matrix <- as.matrix(iris)

# Normalizing data
normalized_data <- rowwise_normalization(iris_matrix)
head(normalized_data)

# Check if data belongs to the unit sphere
norms <- sqrt(rowSums(normalized_data^2))
mean_norm <- mean(norms)

if (abs(mean_norm - 1) < 0.01) {
    print("The data belongs to the unit sphere.")
} else {
    print("The data does not belong to the unit sphere.")
}

# set.seed(123)
# Perform clustering using skmeans
skmeans_result <- skmeans(normalized_data, k = 3)

# Print cluster assignments
skmeans_result$cluster

# Create lookup table
lookup_table <- data.frame(cluster = c(1, 2, 3), label = levels(true_labels))

# Map cluster assignments to string labels using lookup table
cluster_labels <- lookup_table[skmeans_result$cluster, "label"]

# Transforming it to factors
cluster_labels <- as.factor(cluster_labels)
true_labels <- as.factor(true_labels)

# Checking levels
levels(cluster_labels)
levels(true_labels)

# Calculating confusion matrix
confusion_matrix <- confusionMatrix(cluster_labels, true_labels)
print(confusion_matrix)

# Setosa
true_positives_setosa <- confusion_matrix$table[1, 1]
false_positives_setosa1 <- confusion_matrix$table[1, 2]
false_positives_setosa2 <- confusion_matrix$table[1, 3]
false_negatives_setosa1 <- confusion_matrix$table[2, 1]
false_negatives_setosa2 <- confusion_matrix$table[3, 1]

recall_setosa <- true_positives_setosa / (true_positives_setosa + false_negatives_setosa1 + false_negatives_setosa2)
precision_setosa <- true_positives_setosa / (true_positives_setosa + false_positives_setosa1 + false_positives_setosa2)

# Versicolor
true_positives_versicolor <- confusion_matrix$table[2, 2]
false_positives_versicolor1 <- confusion_matrix$table[2, 1]
false_positives_versicolor2 <- confusion_matrix$table[2, 3]
false_negatives_versicolor1 <- confusion_matrix$table[1, 2]
false_negatives_versicolor2 <- confusion_matrix$table[3, 2]

recall_versicolor <- true_positives_versicolor / (true_positives_versicolor + false_negatives_versicolor1 + false_negatives_versicolor2)
precision_versicolor <- true_positives_versicolor / (true_positives_versicolor + false_positives_versicolor1 + false_positives_versicolor2)

# Virginica
true_positives_virginica <- confusion_matrix$table[3, 3]
false_positives_virginica1 <- confusion_matrix$table[3, 1]
false_positives_virginica2 <- confusion_matrix$table[3, 2]
false_negatives_virginica1 <- confusion_matrix$table[1, 3]
false_negatives_virginica2 <- confusion_matrix$table[2, 3]

recall_virginica <- true_positives_virginica / (true_positives_virginica + false_negatives_virginica1 + false_negatives_virginica2)
precision_virginica <- true_positives_virginica / (true_positives_virginica + false_positives_virginica1 + false_positives_virginica2)

macro_recall <- mean(c(recall_setosa, recall_versicolor, recall_virginica))
macro_precision <- mean(c(precision_setosa, precision_versicolor, precision_virginica))

print(paste("Recall:", macro_recall))
print(paste("Precision:", macro_precision))
