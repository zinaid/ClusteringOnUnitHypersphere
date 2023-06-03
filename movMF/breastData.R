# Load required libraries
library(mlbench)
library(movMF)
library(tidyverse)
library(caret)

normalize_to_unit_sphere <- function(data) {
    # Center the data
    centered_data <- data - colMeans(data)

    # Compute Euclidean norms
    norms <- sqrt(rowSums(centered_data^2))

    # Normalize to unit length
    unit_data <- centered_data / norms

    return(unit_data)
}

# Load Wisconsin breast cancer data
data(BreastCancer)

# Checking data types of columns
str(BreastCancer)

# Converting all columns to numeric
BreastCancer$Cl.thickness <- as.numeric(as.character(BreastCancer$Cl.thickness))
BreastCancer$Cell.size <- as.numeric(as.character(BreastCancer$Cell.size))
BreastCancer$Cell.shape <- as.numeric(as.character(BreastCancer$Cell.shape))
BreastCancer$Marg.adhesion <- as.numeric(as.character(BreastCancer$Marg.adhesion))
BreastCancer$Cl.thickness <- as.numeric(as.character(BreastCancer$Cl.thickness))
BreastCancer$Epith.c.size <- as.numeric(as.character(BreastCancer$Epith.c.size))
BreastCancer$Bare.nuclei <- as.numeric(as.character(BreastCancer$Bare.nuclei))
BreastCancer$Bl.cromatin <- as.numeric(as.character(BreastCancer$Bl.cromatin))
BreastCancer$Normal.nucleoli <- as.numeric(as.character(BreastCancer$Normal.nucleoli))
BreastCancer$Mitoses <- as.numeric(as.character(BreastCancer$Mitoses))

# Cleaning null rows
BreastCancer <- na.omit(BreastCancer)

# True class labels
true_labels <- BreastCancer$Class

# Checking number of clusters
levels(true_labels)

# Print true labels
print(true_labels)

# Remove ID because it is irrelevant, removing also true_labels
BreastCancer <- BreastCancer[, -1]
BreastCancer <- BreastCancer[, -10]

# Converting to matrix
BreastCancer_matrix <- as.matrix(BreastCancer)

# Normalizing data and transforming it to matrix
normalized_data <- normalize_to_unit_sphere(BreastCancer_matrix)

# Check if data belongs to the unit sphere
norms <- sqrt(rowSums(normalized_data^2))
mean_norm <- mean(norms)

if (abs(mean_norm - 1) < 0.01) {
    print("The data belongs to the unit sphere.")
} else {
    print("The data does not belong to the unit sphere.")
}
# Performing movMF clustering
k <- 2 # number of clusters

fit <- movMF(normalized_data, k = k)
print(fit)
# Extract cluster assignments
# cluster_assignments <- fit$cluster
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

# Benign
true_positives_benign <- confusion_matrix$table[1, 1]
false_positives_benign <- confusion_matrix$table[1, 2]
false_negatives_benign <- confusion_matrix$table[2, 1]

recall_benign <- true_positives_benign / (true_positives_benign + false_negatives_benign)
precision_benign <- true_positives_benign / (true_positives_benign + false_positives_benign)

# Malign
true_positives_malign <- confusion_matrix$table[2, 2]
false_positives_malign <- confusion_matrix$table[2, 1]
false_negatives_malign <- confusion_matrix$table[1, 2]

recall_malign <- true_positives_malign / (true_positives_malign + false_negatives_malign)
precision_malign <- true_positives_malign / (true_positives_malign + false_positives_malign)

macro_recall <- mean(c(recall_benign, recall_malign))
macro_precision <- mean(c(precision_benign, precision_malign))


# Print macro recall and macro precision
print(paste("Macro recall:", macro_recall))
print(paste("Macro precision:", macro_precision))
