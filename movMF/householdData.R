# Load required libraries
library(mlbench)
library(movMF)
library(tidyverse)
library(caret)
library(HSAUR2)

normalize_to_unit_sphere <- function(data) {
    # Center the data
    centered_data <- data - colMeans(data)

    # Compute Euclidean norms
    norms <- sqrt(rowSums(centered_data^2))

    # Normalize to unit length
    unit_data <- centered_data / norms

    return(unit_data)
}

data(household)

# Taking true labels
true_labels <- household$gender
print(true_labels)

# Removing the true label column
household <- household[, -5]

# Normalizing data and transforming it to matrix
household_matrix <- as.matrix(household)

# Normalizing data and transforming it to matrix
normalized_data <- normalize_to_unit_sphere(household_matrix)

# Check if data belongs to the unit sphere
norms <- sqrt(rowSums(normalized_data^2))
mean_norm <- mean(norms)

if (abs(mean_norm - 1) < 0.01) {
    print("The data belongs to the unit sphere.")
} else {
    print("The data does not belong to the unit sphere.")
}

# set.seed(123)
# Performing movMF clustering
k <- 2 # number of clusters
fit <- movMF(normalized_data, k = k)

# Extract cluster assignments
cluster_assignments <- predict(fit, normalized_data)

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
