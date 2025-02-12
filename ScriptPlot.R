# Librerie ----
library(moments)
library(dplyr)
library(data.table)

# Caricamento del dataset ----
dataset <- read.csv("datasets/Dataset_Clean_Phishing_Domain_Inlier.csv", header=TRUE, sep=",")

# Estrazione del nome delle feature dal sample/dataset
row_nomi_features <- names(ds)

# Ciclo for per visualizzare i barplot di tutte le feature
for(colonna in row_nomi_features){
  if(!startsWith(colonna,"having")){ # si escludono le feature booleane
    col = ds[[colonna]]
    tab = table(col)
    len = length(tab)
    desc = paste("Frequenze assolute", colonna)
    plot(tab, main = desc)
  }
}

# Grafici domain_length ----
hist_domain = hist(ds$domain_length, freq = TRUE, col = "skyblue",
     main = "Istogramma domain_length", xlab = "Valori", ylab = "Frequenze")
skewness(ds$domain_length)
kurtosis(ds$domain_length)

box_domain = boxplot(ds$domain_length, horizontal = TRUE, col = "skyblue", cex = 0.5,
        main = "Boxplot domain_length")

# Grafici entropy_of_domain ----
hist_entropy = hist(ds$entropy_of_domain, freq = TRUE, col = "skyblue",
     main = "Istogramma entropy_of_domain", xlab = "Valori", ylab = "Frequenze")
skewness(ds$entropy_of_domain)
kurtosis(ds$entropy_of_domain)

box_entropy = boxplot(ds$entropy_of_domain, horizontal = TRUE, col = "skyblue", cex = 0.5,
        main = "Boxplot entropy_of_domain")

# Visualizzazione degli scatterplot per domain_length
plot(ds$number_of_dots_in_domain, ds$domain_length)
plot(ds$number_of_subdomains, ds$domain_length)
plot(ds$entropy_of_domain, ds$domain_length)
plot(ds$number_of_digits_in_domain, ds$domain_length)
plot(ds$number_of_hyphens_in_domain, ds$domain_length)
plot(ds$number_of_special_characters_in_domain, ds$domain_length)
plot(ds$number_of_digits_in_subdomain, ds$domain_length)
plot(ds$average_subdomain_length, ds$domain_length)