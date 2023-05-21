# Load required libraries
library(mlbench)
library(movMF)
library(tidyverse)
library(caret)


data(iris)

# Taking true labels
true_labels <- iris$Species
print(true_labels)

# Removing the true label column
iris <- iris[, -5]

# Normalizing data and transforming it to matrix
X_normalized <- scale(iris)
iris_matrix <- as.matrix(X_normalized)

# Performing movMF clustering
k <- 3 # number of clusters
fit <- movMF(iris_matrix, k = k)

# Extract cluster assignments
cluster_assignments <- predict(fit, iris_matrix)

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
