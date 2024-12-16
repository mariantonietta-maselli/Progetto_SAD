# Librerie ----
library(openxlsx)

# Caricamento del dataset ----
cat("Caricamento del dataset","\n")
ds <- read.csv("Dataset.csv", header=TRUE, sep=",")

# Definizione intervalli ----
#TODO: eventualmente modificare range di intervalli e scegliere come dividere o non dividere features
colonne_intervalli <- c("url_length", "number_of_digits_in_url", "number_of_special_char_in_url",
                        "number_of_slash_in_url", "number_of_questionmark_in_url","domain_length",
                        "number_of_dots_in_domain", "number_of_hyphens_in_domain",
                        "number_of_special_characters_in_domain", "number_of_digits_in_domain",
                        "number_of_subdomains", "average_subdomain_length",
                        "number_of_digits_in_subdomain", "entropy_of_url", "entropy_of_domain")

breaks_lista <- list(
  url_length_breaks = c(11, 25, 50, 75, 100, 125, 150, 175, 191),
  number_of_digits_in_url_breaks = c(-1, 25, 50, 75, 100, 125, 144),
  number_of_special_char_in_url_breaks = c(3, 9, 15, 25, 50, 75),
  number_of_slash_in_url_breaks = c(2, 5, 10, 15, 20, 25, 30),
  number_of_questionmark_in_url_breaks = c(-1, 3, 6, 9, 12, 15, 17),
  domain_length_breaks = c(-1,14,21,50,100,182),
  number_of_dots_in_domain_breaks = c(-1,1,3,10,28),
  number_of_hyphens_in_domain_breaks = c(-1,0,1,5,23),
  number_of_special_characters_in_domain_breaks = c(-1,0,5,15,47),
  number_of_digits_in_domain_breaks = c(-1,0,10,50,144),
  number_of_subdomains_breaks = c(-1,2,5,10,27),
  average_subdomain_length_breaks = c(-1,3,8,20,110),
  number_of_digits_in_subdomain_breaks = c(-1,0,5,15,44),
  entropy_of_domain_breaks = seq(1.386, 4.957, by = 0.3571),
  entropy_of_url_breaks = seq(2.649, 5.866, by = 0.2683) 
)

# Nomi delle features
row_nomi_features <- names(ds)

# Misure descrittive calcolate per tutte le features senza intervalli ----
col_misure_descrittive_univar <- c("Media","Moda","Mediana", "Varianza", 
                               "Dev. Standard", "Quantili", "Range", "IQR")

# Creazione dataframe vuoto per ospitare i risultati ----
df <- data.frame(matrix(ncol = length(misure_descrittive_univar),
                         nrow = length(nomi_features)))
row.names(df) <- nomi_features
colnames(df) <- col_misure_descrittive_univar

# Funzione per calcolare la moda ----
calcolate_mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

# Loop per calcolare le misure descrittive ----
# Per una visualizzazione più chiara si sono arrotondati i valori a 4 cifre decimali
for (row in nomi_features) {
    df[row, "Media"] <- format(round(mean(ds[[row]]), 4), scientific = FALSE)
    df[row, "Moda"] <- format(round(calcolate_mode(ds[[row]]), 4), scientific = FALSE)
    df[row, "Mediana"] <- format(round(median(ds[[row]]), 4), scientific = FALSE)
    df[row, "Varianza"] <- format(round(var(ds[[row]]), 4), scientific = FALSE)
    df[row, "Dev. Standard"] <- format(round(sd(ds[[row]]), 4), scientific = FALSE)
    df[row, "Quantili"] <- paste(format(round(quantile(ds[[row]], probs = c(0.25, 0.5, 0.75)), 4), scientific = FALSE), collapse = ", ")
    df[row, "Range"] <- format(round(diff(range(ds[[row]])), 4), scientific = FALSE)
    df[row, "IQR"] <- format(round(IQR(ds[[row]]), 4), scientific = FALSE)
}

# Salva l'intero dataframe in un file .csv ----
#TODO salvarlo in un file .xlsx e accodare i risultati dell'analisi delle frequenze, non so se sia possibile
output <- "risultati_analisi_univariata.csv"

write.csv(df, file = output, row.names = TRUE)

# Crea una nuova cartella per memorizzare i singoli risultati per feature in file .csv ----

cartella_output <- "analisi_singole_features"

if (!dir.exists(cartella_output)) {
  dir.create(cartella_output)
}

for (feature in row.names(df)) {
  output_file <- paste0(cartella_output, "/", "analisi_", feature, ".csv")
  
  riga <- df[feature, , drop = FALSE]
  
  write.csv(riga, file = output_file, row.names = TRUE)
}

# Calcolo misure descrittive rimanenti non visualizzabili tramite dataframe ----

# Frequenze per variabili non divise in intervalli
# Trova le colonne senza intervalli
colonne_non_intervalli <- setdiff(row_nomi_features, colonne_intervalli)

# Calcola frequenze assolute e relative 
frequenze_non_intervalli <- lapply(colonne_non_intervalli, function(col) {
  frequenze_assolute <- table(ds[[col]])
  frequenze_relative <- prop.table(frequenze_assolute)
  list(assolute = frequenze_assolute, relative = frequenze_relative)
})

# Assegna i nomi alle frequenze
names(frequenze_non_intervalli) <- colonne_non_intervalli

# Frequenze per variabili divise in intervalli
frequenze_intervalli <- lapply(colonne_intervalli, function(colonna) {
  # Recupera gli intervalli associati
  intervalli <- breaks_lista[[paste0(colonna, "_breaks")]]
  
  # Crea le classi della colonna
  ds[[paste0(colonna, "_classi")]] <- cut(ds[[colonna]], breaks = intervalli, include.lowest = TRUE)
  
  # Calcola le frequenze assolute e relative
  frequenze_assolute <- table(ds[[paste0(colonna, "_classi")]])
  frequenze_relative <- prop.table(frequenze_assolute)
  
  # Ritorna entrambe le frequenze in una lista
  list(assolute = frequenze_assolute, relative = frequenze_relative)
})

# Assegna i nomi alle frequenze
names(frequenze_intervalli) <- colonne_intervalli

# Output analisi delle frequenze su file .xlsx
#TODO: provare ad accodare tutto in un unico .xlsx

# Creazione del workbook ----
wb <- createWorkbook()

# Aggiungi il foglio per le frequenze non intervallate
addWorksheet(wb, "Frequenze_non_intervalli")

# Scrivi i dati delle frequenze per le variabili non intervallo
start_row <- 1  # Riga di partenza per la scrittura dei dati

for (colonna in colonne_non_intervalli) {
  # Prendi le frequenze assolute e relative
  frequenze_assolute <- frequenze_non_intervalli[[colonna]]$assolute
  frequenze_relative <- frequenze_non_intervalli[[colonna]]$relative
  
  # Crea una tabella da scrivere
  df <- data.frame(
    Valori = names(frequenze_assolute),
    Frequenze_Assolute = as.numeric(frequenze_assolute),
    Frequenze_Relative = round(as.numeric(frequenze_relative), 4)  # Arrotonda le frequenze relative
  )
  
  # Scrivi nel foglio Excel il nome della feature e le sue frequenze
  writeData(wb, sheet = "Frequenze_non_intervalli", x = data.frame(Feature = colonna), startRow = start_row, startCol = 1, colNames = FALSE)
  start_row <- start_row + 1  # Aggiungi una riga per separare il nome della feature dai dati
  
  # Scrivi la tabella delle frequenze
  writeData(wb, sheet = "Frequenze_non_intervalli", x = df, startRow = start_row, startCol = 1, colNames = TRUE)
  
  # Aggiungi una riga vuota dopo ogni set di dati
  start_row <- start_row + nrow(df) + 2
}

# Aggiungi il foglio per le frequenze intervallate
addWorksheet(wb, "Frequenze_intervalli")

# Scrivi i dati delle frequenze per le variabili intervallo
start_row <- 1  # Reset della riga di partenza per il nuovo foglio

for (colonna in colonne_intervalli) {
  # Recupera gli intervalli associati
  intervalli <- breaks_lista[[paste0(colonna, "_breaks")]]
  
  # Crea le classi per la colonna
  ds[[paste0(colonna, "_classi")]] <- cut(ds[[colonna]], breaks = intervalli, include.lowest = TRUE)
  
  # Calcola le frequenze assolute e relative
  frequenze_assolute <- table(ds[[paste0(colonna, "_classi")]])
  frequenze_relative <- prop.table(frequenze_assolute)
  
  # Crea una tabella da scrivere
  df <- data.frame(
    Intervallo = names(frequenze_assolute),
    Frequenze_Assolute = as.numeric(frequenze_assolute),
    Frequenze_Relative = round(as.numeric(frequenze_relative), 4)  # Arrotonda le frequenze relative
  )
  
  # Scrivi nel foglio Excel il nome della feature e le sue frequenze
  writeData(wb, sheet = "Frequenze_intervalli", x = data.frame(Feature = colonna), startRow = start_row, startCol = 1, colNames = FALSE)
  start_row <- start_row + 1  # Aggiungi una riga per separare il nome della feature dai dati
  
  # Scrivi la tabella delle frequenze
  writeData(wb, sheet = "Frequenze_intervalli", x = df, startRow = start_row, startCol = 1, colNames = TRUE)
  
  # Aggiungi una riga vuota dopo ogni set di dati
  start_row <- start_row + nrow(df) + 2
}

# Salva il workbook in un file chiamato "Analisi_frequenze.xlsx" nella directory di lavoro
saveWorkbook(wb, "Analisi_frequenze.xlsx", overwrite = TRUE)

# Funzione di distribuzione empirica ----
#TODO

# Summary
#TODO
