library("readxl")
library(mlbench)
library(movMF)
library(tidyverse)
library(caret)

my_data <- read_excel(file.choose())
head(my_data)
true_labels <- my_data$cluster
print(true_labels)
my_data$x <- as.numeric(as.character(my_data$x))
my_data$y <- as.numeric(as.character(my_data$y))
my_data$z <- as.numeric(as.character(my_data$z))

data <- my_data[, -4]

data_matrix <- as.matrix(data)
# Performing movMF clustering
# set.seed(123)
k <- 2 # number of clusters
fit <- movMF(data_matrix, k = k)

# Extract cluster assignments
cluster_assignments <- predict(fit, data_matrix)

true_labels <- as.factor(true_labels)
levels(true_labels)

# Create lookup table
lookup_table <- data.frame(cluster = 1:k, label = levels(true_labels))

# Map cluster assignments to string labels using lookup table
cluster_labels <- lookup_table$label[cluster_assignments]

# Reorder levels of cluster_labels to match true_labels
cluster_labels <- factor(cluster_labels, levels = levels(true_labels))
# Convert to factors
cluster_labels <- as.factor(cluster_labels)

# Compute confusion matrix
confusion_matrix <- confusionMatrix(cluster_labels, true_labels)

# Print confusion matrix
print(confusion_matrix)

print(cluster_labels)

# Cluster 1
true_positives_cluster1 <- confusion_matrix$table[1, 1]
false_positives_cluster1 <- confusion_matrix$table[1, 2]
false_negatives_cluster1 <- confusion_matrix$table[2, 1]

macro_recall_cluster1 <- true_positives_cluster1 / (true_positives_cluster1 + false_negatives_cluster1)
macro_precision_cluster1 <- true_positives_cluster1 / (true_positives_cluster1 + false_positives_cluster1)

# Cluster 2
true_positives_cluster2 <- confusion_matrix$table[2, 2]
false_positives_cluster2 <- confusion_matrix$table[2, 1]
false_negatives_cluster2 <- confusion_matrix$table[1, 2]

macro_recall_cluster2 <- true_positives_cluster2 / (true_positives_cluster2 + false_negatives_cluster2)
macro_precision_cluster2 <- true_positives_cluster2 / (true_positives_cluster2 + false_positives_cluster2)

macro_recall <- mean(c(macro_recall_cluster1, macro_recall_cluster2))
macro_precision <- mean(c(macro_precision_cluster1, macro_precision_cluster2))

print(paste("Recall:", macro_recall))
print(paste("Precision:", macro_precision))


library(ggplot2)

# Assuming your data is stored in a data frame called 'my_data'
# and the features for clustering are stored in columns 'x', 'y', and 'z'

# Create a scatter plot of two variables with cluster colors
ggplot(my_data, aes(x = x, y = y, color = as.factor(cluster))) +
    geom_point() +
    labs(x = "X", y = "Y", color = "Cluster") +
    ggtitle("Scatter Plot of X and Y with Cluster Colors")

# Create a 3D scatter plot of three variables with cluster colors
ggplot(my_data, aes(x = x, y = y, z = z, color = as.factor(cluster))) +
    geom_point() +
    labs(x = "X", y = "Y", z = "Z", color = "Cluster") +
    ggtitle("3D Scatter Plot of X, Y, and Z with Cluster Colors")


# Calculate the Jaccard Index
cluster1 <- cluster_labels == 1
cluster2 <- cluster_labels == 2
true_cluster1 <- true_labels == 1
true_cluster2 <- true_labels == 2

intersection <- sum(cluster1 & true_cluster1) + sum(cluster2 & true_cluster2)
union <- sum(cluster1 | true_cluster1) + sum(cluster2 | true_cluster2)

jaccard_index <- intersection / union

# Print the Jaccard Index
print(paste("Jaccard Index:", jaccard_index))
