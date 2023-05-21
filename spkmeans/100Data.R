library("readxl")
library(tidyverse)
library(skmeans)
library(cluster)
library(caret)
my_data <- read_excel(file.choose())
head(my_data)
true_labels <- my_data$cluster
print(true_labels)
my_data$x <- as.numeric(as.character(my_data$x))
my_data$y <- as.numeric(as.character(my_data$y))
my_data$z <- as.numeric(as.character(my_data$z))
levels(true_labels)

household <- my_data[, -4]
X_normalized <- scale(household)

household_matrix <- as.matrix(household)
# Perform clustering using skmeans
skmeans_result <- skmeans(household_matrix, k = 2)


# Map cluster assignments to string labels using lookup table
cluster_labels <- lookup_table[skmeans_result$cluster, "label"]

# Transforming it to factors
cluster_labels <- as.factor(cluster_labels)
true_labels <- as.factor(true_labels)


# Create lookup table and assign cluster results to levels in true_labels
lookup_table <- data.frame(cluster = c(1, 2), label = levels(true_labels))

# Checking levels
levels(cluster_labels)
levels(true_labels)

# Calculating confusion matrix
confusion_matrix <- confusionMatrix(cluster_labels, true_labels)
print(confusion_matrix)

# Cluster1
true_positives_cluster1 <- confusion_matrix$table[1, 1]
false_positives_cluster1 <- confusion_matrix$table[1, 2]
false_negatives_cluster1 <- confusion_matrix$table[2, 1]

macro_recall_cluster1 <- true_positives_cluster1 / (true_positives_cluster1 + false_negatives_cluster1)
macro_precision_cluster1 <- true_positives_cluster1 / (true_positives_cluster1 + false_positives_cluster1)

# Cluster1
true_positives_cluster2 <- confusion_matrix$table[2, 2]
false_positives_cluster2 <- confusion_matrix$table[2, 1]
false_negatives_cluster2 <- confusion_matrix$table[1, 2]

macro_recall_cluster2 <- true_positives_cluster2 / (true_positives_cluster2 + false_negatives_cluster2)
macro_precision_cluster2 <- true_positives_cluster2 / (true_positives_cluster2 + false_positives_cluster2)

macro_recall <- mean(c(macro_recall_cluster1, macro_recall_cluster2))
macro_precision <- mean(c(macro_precision_cluster1, macro_precision_cluster2))

print(paste("Recall:", macro_recall))
print(paste("Precision:", macro_precision))
