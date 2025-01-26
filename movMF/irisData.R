# Load required libraries
library(mlbench)
library(movMF)
library(tidyverse)
library(caret)
library(writexl)


data(iris)

normalized_data_with_clusters <- cbind(as.data.frame(iris))

# Save to Excel file
write_xlsx(iris, "iris.xlsx")

rowwise_normalization <- function(data) {
  row_sums <- rowSums(data)
  normalized_data <- sweep(data, 1, row_sums, FUN = "/")
  return(normalized_data)
}


# Taking true labels
true_labels <- iris$Species
print(true_labels)

# Removing the true label column
iris <- iris[, -5]

# Normalizing data and transforming it to matrix
iris_matrix <- as.matrix(iris)

# Normalizing data and transforming it to matrix
normalized_data <- rowwise_normalization(iris_matrix)

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
movmf_result <- movMF(normalized_data, k = 3)

# Deriving cluster assignments from the P matrix (probabilities)
cluster_labels <- apply(movmf_result$P, 1, which.max)

# Map cluster assignments to string labels using lookup table
lookup_table <- data.frame(cluster = c(1, 2, 3), label = levels(true_labels))

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
