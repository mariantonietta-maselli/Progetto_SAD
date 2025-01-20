# Librerie ----
library(moments)

# Caricamento del dataset ----
ds <- read.csv("Dataset_Clean_Phishing_Domain.csv", header=TRUE, sep=",")

# Estrazione del nome delle feature dal sample/dataset ----
row_nomi_features <- names(ds)[-1] # si esclude la feature Type

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

# Grafici domain_length ----
hist(ds$domain_length, freq = TRUE, col = "skyblue",
     main = "Istogramma domain_length", xlab = "Valori", ylab = "Frequenze")
skewness(ds$domain_length)
kurtosis(ds$domain_length)

boxplot(ds$domain_length, horizontal = TRUE, col = "skyblue", cex = 0.5,
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