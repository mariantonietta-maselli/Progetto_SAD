# 1. Caricare il dataset in un dataframe
# 2. Creare un dataframe per memorizzare i risultati delle analisi
# 3. Utilizzare un unico dataframe per memorizzare tuti i passi dell'analisi

# Caricamento del dataset
cat("Caricamento del dataset","\n")
df <- read.csv("Dataset.csv", header=TRUE, sep=",")

# Informazioni sulla struttura del dataset
cat("Informazioni sulla struttura del dataset","\n")
str(df)