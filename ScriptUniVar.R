# 1. Caricare il dataset in un dataframe OK
# 2. Creare un dataframe vuoto per memorizzare i risultati delle analisi OK
# 3. Utilizzare il dataframe per memorizzare tuti i passi dell'analisi TODO
# 4. Stampare su un unico file il dataframe TODO
# 5. Stampare la singola riga del dataframe su un file dedicato TODO


# Caricamento del dataset
cat("Caricamento del dataset","\n")
ds <- read.csv("Dataset.csv", header=TRUE, sep=",")

# Informazioni sulla struttura del dataset
cat("Informazioni sulla struttura del dataset","\n")
str(ds)

row_nomi_features <- names(ds)

col_misure_descrittive_univar <- c("Media","Moda","Mediana", "Varianza", 
                               "Dev. Standard", "Quantili", "Range", "IQR",
                               "Frequenze Assolute", "Frequenze Relative",
                               "Funzione di Distribuzione Empirica",
                               "Summary")

df <- data.frame(matrix(ncol = length(misure_descrittive_univar),
                         nrow = length(nomi_features)))
row.names(df) <- nomi_features
colnames(df) <- misure_descrittive_univar
df