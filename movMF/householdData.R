# Load required libraries
library(mlbench)
library(movMF)
library(tidyverse)

data(household)

# Taking true labels
true_labels <- household$gender
print(true_labels)

# Removing the true label column
household <- household[, -5]

# Normalizing data and transforming it to matrix
X_normalized <- scale(household)
household_matrix <- as.matrix(X_normalized)

# Performing movMF clustering
k <- 2 # number of clusters
fit <- movMF(household_matrix, k = k)

# Extract cluster assignments
cluster_assignments <- predict(fit, household_matrix)

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
