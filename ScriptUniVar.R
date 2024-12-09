# 1. Caricare il dataset in un dataframe OK
# 2. Creare un dataframe vuoto per memorizzare i risultati delle analisi OK
# 3. Utilizzare il dataframe per memorizzare tuti i passi dell'analisi TODO
# 4. Stampare su un unico file il dataframe OK
# 5. Stampare la singola riga del dataframe su un file dedicato OK


# Caricamento del dataset ----
cat("Caricamento del dataset","\n")
ds <- read.csv("Dataset.csv", header=TRUE, sep=",")

# Informazioni sulla struttura del dataset ----
cat("Informazioni sulla struttura del dataset","\n")
str(ds)

# Nomi delle features
row_nomi_features <- names(ds)

# Misure descrittive ----
col_misure_descrittive_univar <- c("Media","Moda","Mediana", "Varianza", 
                               "Dev. Standard", "Quantili", "Range", "IQR",
                               "Frequenze Assolute", "Frequenze Relative",
                               "Funzione di Distribuzione Empirica",
                               "Summary")

# Creazione dataframe vuoto per ospitare i risultati ----
df <- data.frame(matrix(ncol = length(misure_descrittive_univar),
                         nrow = length(nomi_features)))
row.names(df) <- nomi_features
colnames(df) <- col_misure_descrittive_univar
df

# Funzione per calcolare la moda ----
calcolate_mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

# Loop per calcolare le misure descrittive ----
# Per una visualizzazione più chiara si sono arrotondati i valori a 4 cifre decimali
for (col in nomi_features) {
  if (is.numeric(ds[[col]])) {
    df[col, "Media"] <- format(round(mean(ds[[col]]), 4), scientific = FALSE)
    df[col, "Moda"] <- format(round(calcolate_mode(ds[[col]]), 4), scientific = FALSE)
    df[col, "Mediana"] <- format(round(median(ds[[col]]), 4), scientific = FALSE)
    df[col, "Varianza"] <- format(round(var(ds[[col]]), 4), scientific = FALSE)
    df[col, "Dev. Standard"] <- format(round(sd(ds[[col]]), 4), scientific = FALSE)
    df[col, "Quantili"] <- paste(format(round(quantile(ds[[col]], probs = c(0.25, 0.5, 0.75)), 4), scientific = FALSE), collapse = ", ")
    df[col, "Range"] <- format(round(diff(range(ds[[col]])), 4), scientific = FALSE)
    df[col, "IQR"] <- format(round(IQR(ds[[col]]), 4), scientific = FALSE)
  } else {
    df[col, ] <- NA  # Imposta NA se la colonna non è numerica
  }
}

print(df)

# Salva l'intero dataframe in un file .csv ----
output <- "risultati_analisi_univariata.csv"

write.csv(df, file = output, row.names = TRUE)

# Crea una nuova cartella per memorizzare i singoli risultati per feature in file .csv ----

cartella_output <- "analisi_singole_features"

if (!dir.exists(cartella_output)) {
  dir.create(cartella_output)
  cat("Cartella creata:", cartella_output, "\n")
}

for (feature in row.names(df)) {
  output_file <- paste0(cartella_output, "/", "analisi_", feature, ".csv")

  riga <- df[feature, , drop = FALSE]

  write.csv(riga, file = output_file, row.names = TRUE)
}