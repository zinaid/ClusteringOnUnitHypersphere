library(movMF)

cluster1_mean <- c(1, 1, 1)
cluster1_kappa <- 50
cluster2_mean <- c(-1, -1, -1)
cluster2_kappa <- 50

# Generate data
# set.seed(123)
cluster1_data <- rmovMF(25, cluster1_mean, cluster1_kappa)
cluster2_data <- rmovMF(25, cluster2_mean, cluster2_kappa)

# Create data frames with cluster labels
cluster1_df <- data.frame(
    x = cluster1_data[, 1],
    y = cluster1_data[, 2],
    z = cluster1_data[, 3],
    cluster = 1
)
cluster1_df
cluster2_df <- data.frame(
    x = cluster2_data[, 1],
    y = cluster2_data[, 2],
    z = cluster2_data[, 3],
    cluster = 2
)

# Combine the data frames
data <- rbind(cluster1_df, cluster2_df)
data
# Save to Excel file
library(writexl)
write_xlsx(data, "data/50.xlsx")
