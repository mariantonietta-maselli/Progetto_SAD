# Caricamento del dataset ----
ds <- read.csv("Dataset_Clean_Phishing.csv", header=TRUE, sep=",")

# Estrazione del nome delle feature dal sample/dataset ----
row_nomi_features <- names(ds)[-1] # si esclude la feature Type

# Ciclo for per visualizzare i barplot di tutte le feature ----
for(colonna in row_nomi_features){
  if(!startsWith(colonna,"having")){ # si escludono le feature booleane
    col = ds[[colonna]]
    tab = table(col)
    len = length(tab)
    desc = paste("Frequenze assolute", colonna)
    barplot(tab, main = desc)
  }
}