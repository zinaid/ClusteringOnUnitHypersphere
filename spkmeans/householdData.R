# Loading libraries
library(tidyverse)
library(skmeans)
library(cluster)
library(caret)
library(HSAUR2)

# Loading dataset household
data(household)

# Taking true labels
true_labels <- household$gender
print(true_labels)

# Removing the cluster column/true label
household <- household[, -5]

# Normalizing data and transforming it to matrix
X_normalized <- scale(household)
household_matrix <- as.matrix(X_normalized)

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
