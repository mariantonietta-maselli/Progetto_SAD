# Librerie ----
library(moments)
library(dplyr)
library(data.table)

# Caricamento del dataset ----
ds <- read.csv("datasets/Dataset_Clean_Phishing_Domain.csv", header=TRUE, sep=",")
dsi <- ds

# Estrazione del nome delle feature dal sample/dataset ----
row_nomi_features <- names(ds)

# Ciclo for per visualizzare i barplot di tutte le feature ----
for(colonna in row_nomi_features){
  if(!startsWith(colonna,"having")){ # si escludono le feature booleane
    col = ds[[colonna]]
    tab = table(col)
    len = length(tab)
    desc = paste("Frequenze assolute", colonna)
    plot(tab, main = desc)
  }
}

# Grafici domain_length (pre outlier) ----
hist(ds$domain_length, freq = TRUE, col = "skyblue",
     main = "Istogramma domain_length", xlab = "Valori", ylab = "Frequenze")
skewness(ds$domain_length)
kurtosis(ds$domain_length)

box_domain_length = boxplot(ds$domain_length, horizontal = TRUE, col = "skyblue", cex = 0.5,
        main = "Boxplot domain_length")

# Grafici number_of_subdomains ----
hist(ds$number_of_subdomains, freq = TRUE, col = "skyblue",
     main = "Istogramma number_of_subdomains", xlab = "Valori", ylab = "Frequenze")
skewness(ds$number_of_subdomains)
kurtosis(ds$number_of_subdomains)

boxplot(ds$number_of_subdomains, horizontal = TRUE, col = "skyblue", cex = 0.5,
        main = "Boxplot number_of_subdomains")

# Grafici entropy_of_domain ----
hist(ds$entropy_of_domain, freq = TRUE)
skewness(ds$entropy_of_domain)
kurtosis(ds$entropy_of_domain)

boxplot(ds$entropy_of_domain, horizontal = TRUE, col = "skyblue", cex = 0.5,
        main = "Boxplot entropy_of_domain")

# Rimozione outlier ----
for(colonna in row_nomi_features) {
  col = dsi[[colonna]]
  Q1 = quantile(col, 0.25)
  Q3 = quantile(col, 0.75)
  IQR <- Q3 - Q1
  lower = Q1 - 1.5 * IQR
  upper = Q3 + 1.5 * IQR
  dsi <- subset(dsi, col >= lower & col <= upper)
}

# Stampa su csv il dataset senza outlier
fwrite(dsi, "datasets/Dataset_Clean_Phishing_Domain_Inlier.csv")