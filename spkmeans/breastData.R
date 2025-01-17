# Load library
library(mlbench)
library(tidyverse)
library(skmeans)
library(cluster)
library(caret)
library(HSAUR2)

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

# Remove ID because it is irrelavant, removing also true_labels
BreastCancer <- BreastCancer[, -1]
BreastCancer <- BreastCancer[, -10]

# Normalizing data
# X_normalized <- scale(BreastCancer)

# Converting to matrix
BreastCancer_matrix <- as.matrix(BreastCancer)

normalized_data <- normalize_to_unit_sphere(BreastCancer_matrix)
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
# Performing skmeans
skmeans_result <- skmeans(normalized_data, k = 2)

# Printig results
skmeans_result$cluster

# Create lookup table
lookup_table <- data.frame(cluster = c(1, 2), label = levels(true_labels))

# Map cluster assignments to string labels using lookup table
cluster_labels <- lookup_table[skmeans_result$cluster, "label"]

# Converting to factors
cluster_labels <- as.factor(cluster_labels)
true_labels <- as.factor(true_labels)

# Finding confusionMatrix
confusion_matrix <- confusionMatrix(cluster_labels, true_labels)

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

print(paste("Recall:", macro_recall))
print(paste("Precision:", macro_precision))
