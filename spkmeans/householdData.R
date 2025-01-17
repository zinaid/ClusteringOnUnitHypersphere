# Loading libraries
library(tidyverse)
library(skmeans)
library(cluster)
library(caret)
library(HSAUR2)

# Loading dataset household
data(household)

# Normalize data points to unit sphere
normalize_to_unit_sphere <- function(data) {
    # Center the data
    centered_data <- data - colMeans(data)

    # Compute Euclidean norms
    norms <- sqrt(rowSums(centered_data^2))

    # Normalize to unit length
    unit_data <- centered_data / norms

    return(unit_data)
}

# Taking true labels
true_labels <- household$gender
print(true_labels)

# Removing the cluster column/true label
household <- household[, -5]

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
# Perform clustering using skmeans
skmeans_result <- skmeans(household_matrix, k = 2)

# Print cluster assignments
skmeans_result$cluster

# Create lookup table and assign cluster results to levels in true_labels
lookup_table <- data.frame(cluster = c(2, 1), label = levels(true_labels))

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
