library(dplyr)

# Caricamento del dataset ----
dataset <- read.csv("Dataset.csv", header=TRUE, sep=",")

# Creazione del sample (1% del dataset) ----
dsc <- dataset %>%  group_by(Type) %>%  sample_frac(0.01)

# Creazione del sample (1% del dataset) ----
ds <- dataset %>%  group_by(Type) %>%  sample_frac(0.01)

# Partizione per le osservazioni Phishing ----
ds <- dsc[dsc$Type == 1,]

# Partizione per le osservazioni Legitimate ----
ds <- dsc[dsc$Type == 0,]

# Estrazione del nome delle feature dal sample/dataset ----
row_nomi_features <- names(ds)

# Ciclo for per visualizzare i barplot di tutte le feature ----
for(colonna in row_nomi_features){
  print(colonna)
  col = ds[[colonna]]
  tab = table(col)
  len = length(tab)
  print(len)
  desc = paste("Frequenze assolute", colonna)
  barplot(tab, main = desc)
}