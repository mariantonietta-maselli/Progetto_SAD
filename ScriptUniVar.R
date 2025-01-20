# Librerie----
library(openxlsx)
library(dplyr)

wb <- createWorkbook()

# Caricamento del dataset ----
ds <- read.csv("Dataset.csv", header=TRUE, sep=",")

# Definizione intervalli ----
colonne_intervalli <- c("domain_length", "number_of_digits_in_domain", "average_subdomain_length",
                        "entropy_of_domain")

breaks_lista <- list(
  domain_length_breaks = seq(0, 182, by = 10),
  number_of_digits_in_domain_breaks = seq(0, 144, by = 8),
  average_subdomain_length_breaks = seq(0, 110, by = 5),
  entropy_of_domain_breaks = seq(1.386, 4.957, by = 0.3571)
)

# Nomi delle features
row_nomi_features <- names(ds)

# Misure descrittive calcolate per tutte le features (senza tener conto degli intervalli) ----
col_misure_descrittive_univar <- c("Media","Moda","Mediana", "Varianza", 
                               "Dev. Standard", "Quantili", "Range", "IQR")

# Funzione per calcolare la moda ----
calcolate_mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

# Aggiunge un foglio al workbook relativo all'"Analisi univariata"
addWorksheet(wb, "Analisi univariata")

# Imposta la riga di partenza
start_row <- 2
start_col <- 1

# Scrive i nomi delle colonne (le misure) nella prima riga
# Crea un data.frame con "Feature" seguito dai nomi delle misure descrittive per una corretta visualizzazione
col_names <- c("Feature", col_misure_descrittive_univar)

# Scrive i dati nel foglio Excel
writeData(wb, sheet = "Analisi univariata", 
          x = t(as.data.frame(col_names)), 
          startRow = 1, startCol = 1, colNames = FALSE)

for (colonna in row_nomi_features) {
  
  # Calcola le misure descrittive per la feature
  media <- format(round(mean(ds[[colonna]]), 4), scientific = FALSE)
  moda <- format(round(calcolate_mode(ds[[colonna]]), 4), scientific = FALSE)
  mediana <- format(round(median(ds[[colonna]]), 4), scientific = FALSE)
  varianza <- format(round(var(ds[[colonna]]), 4), scientific = FALSE)
  dev_standard <- format(round(sd(ds[[colonna]]), 4), scientific = FALSE)
  quantili <- paste(format(round(quantile(ds[[colonna]], probs = c(0.25, 0.5, 0.75)), 4), scientific = FALSE), collapse = ", ")
  range_val <- format(round(diff(range(ds[[colonna]])), 4), scientific = FALSE)
  iqr <- format(round(IQR(ds[[colonna]]), 4), scientific = FALSE)
  
  # Crea una tabella con i risultati per la feature
  df_temp <- data.frame(
    Feature = colonna,
    Media = media,
    Moda = moda,
    Mediana = mediana,
    Varianza = varianza,
    `Dev. Standard` = dev_standard,
    Quantili = quantili,
    Range = range_val,
    IQR = iqr
  )
  
  # Scrive i valori delle misure nel foglio Excel
  writeData(wb, sheet = "Analisi univariata", 
            x = df_temp, 
            startRow = start_row, startCol = start_col, colNames = FALSE)
  
  # Incrementa la riga per il set successivo di misure
  start_row <- start_row + 1
}

# Frequenze per variabili non divise in intervalli ----
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
  
  # Restituisce entrambe le frequenze in una lista
  list(assolute = frequenze_assolute, relative = frequenze_relative)
})

# Assegna i nomi alle frequenze
names(frequenze_intervalli) <- colonne_intervalli

# Aggiunge il foglio per le frequenze non intervallate
addWorksheet(wb, "Frequenze_non_intervalli")

# Scrive i dati delle frequenze per le variabili senza intervalli
start_row <- 1  # Riga di partenza per la scrittura dei dati

for (colonna in colonne_non_intervalli) {
  # Prendi le frequenze assolute e relative
  frequenze_assolute <- frequenze_non_intervalli[[colonna]]$assolute
  frequenze_relative <- frequenze_non_intervalli[[colonna]]$relative
  
  # Crea un df
  df <- data.frame(
    Valori = names(frequenze_assolute),
    Frequenze_Assolute = as.numeric(frequenze_assolute),
    Frequenze_Relative = round(as.numeric(frequenze_relative), 4)  # Arrotonda le frequenze relative
  )
  
  # Scrive nel foglio Excel il nome della feature e le sue frequenze
  writeData(wb, sheet = "Frequenze_non_intervalli", x = data.frame(Feature = colonna), startRow = start_row, startCol = 1, colNames = FALSE)
  start_row <- start_row + 1  # Aggiungi una riga per separare il nome della feature dai dati
  
  # Scrive la tabella delle frequenze
  writeData(wb, sheet = "Frequenze_non_intervalli", x = df, startRow = start_row, startCol = 1, colNames = TRUE)
  
  # Aggiunge una riga vuota dopo ogni set di dati
  start_row <- start_row + nrow(df) + 2
}

# Aggiunge il foglio per le frequenze intervallate
addWorksheet(wb, "Frequenze_intervalli")

# Scrive i dati delle frequenze per le variabili con intervalli
start_row <- 1  # Reset della riga di partenza per il nuovo foglio

for (colonna in colonne_intervalli) {
  # Recupera gli intervalli associati
  intervalli <- breaks_lista[[paste0(colonna, "_breaks")]]
  
  # Crea le classi per la colonna
  ds[[paste0(colonna, "_classi")]] <- cut(ds[[colonna]], breaks = intervalli, include.lowest = TRUE)
  
  # Calcola le frequenze assolute e relative
  frequenze_assolute <- table(ds[[paste0(colonna, "_classi")]])
  frequenze_relative <- prop.table(frequenze_assolute)
  
  # Crea un df
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

# Funzione di distribuzione empirica ----
# Aggiungi il foglio per le frequenze con intervalli (Distribuzione Cumulativa)
addWorksheet(wb, "Frequenze_intervalli_cumulativa")

# Scrive i dati delle frequenze con intervalli
start_row <- 1  # Riga di partenza per la scrittura dei dati

for (colonna in names(ds)) {
  
  if (colonna %in% colonne_intervalli) {
    # Recupera i breaks associati alla colonna
    intervalli <- breaks_lista[[paste0(colonna, "_breaks")]]
    # Crea le classi della colonna
    ds[[paste0(colonna, "_classi")]] <- cut(ds[[colonna]], breaks = intervalli, include.lowest = TRUE)
    # Calcola frequenze assolute e relative
    frequenze_assolute <- table(ds[[paste0(colonna, "_classi")]])
    frequenze_relative <- prop.table(frequenze_assolute)
    # Calcola la distribuzione cumulativa con cumsum
    distribuzione_cumulativa <- cumsum(frequenze_relative)
    
    # Crea un df
    df <- data.frame(
      Intervallo = names(frequenze_assolute),
      Frequenze_Relative = round(as.numeric(frequenze_relative), 4),
      Distribuzione_Cumulativa = round(as.numeric(distribuzione_cumulativa), 4)
    )
    
    # Scrive nel foglio Excel il nome della feature e le sue frequenze
    writeData(wb, sheet = "Frequenze_intervalli_cumulativa", x = data.frame(Feature = colonna), startRow = start_row, startCol = 1, colNames = FALSE)
    start_row <- start_row + 1  # Aggiungi una riga per separare il nome della feature dai dati
    
    # Scrive la tabella delle frequenze
    writeData(wb, sheet = "Frequenze_intervalli_cumulativa", x = df, startRow = start_row, startCol = 1, colNames = TRUE)
    
    # Aggiunge una riga vuota dopo ogni set di dati
    start_row <- start_row + nrow(df) + 2
  }
}

# Aggiunge il foglio per le frequenze senza intervalli (FDE)
addWorksheet(wb, "Frequenze_FDE")

# Scrive i dati delle frequenze senza intervalli
start_row <- 1  # Reset della riga di partenza per il nuovo foglio

for (colonna in names(ds)) {
  
  if (!(colonna %in% colonne_intervalli) && is.numeric(ds[[colonna]])) {
    
    # Calcola la funzione di distribuzione empirica
    dist_emp <- ecdf(ds[[colonna]])
    valori_unici <- sort(unique(ds[[colonna]]))
    
    # Crea una tabella da scrivere
    df <- data.frame(
      Valore = valori_unici,
      FDE = round(sapply(valori_unici, dist_emp), 4)
    )
    
    # Scrive nel foglio Excel il nome della feature e i valori della FDE
    writeData(wb, sheet = "Frequenze_FDE", x = data.frame(Feature = colonna), startRow = start_row, startCol = 1, colNames = FALSE)
    start_row <- start_row + 1  # Aggiungi una riga per separare il nome della feature dai dati
    
    # Scrive la tabella della FDE
    writeData(wb, sheet = "Frequenze_FDE", x = df, startRow = start_row, startCol = 1, colNames = TRUE)
    
    # Aggiunge una riga vuota dopo ogni set di dati
    start_row <- start_row + nrow(df) + 2
  }
}

# Summary ----

addWorksheet(wb, "Riepilogo_summary")

start_row <- 1  # Riga di partenza per la scrittura dei dati

for (colonna in names(ds)) {
  
  # Calcola il riepilogo statistico con summary()
  summary_stats <- summary(ds[[colonna]])
  
  # Converte il risultato in un dataframe per una scrittura chiara
  df <- data.frame(
    Statistica = names(summary_stats),
    Valore = as.numeric(summary_stats)
  )
  
  # Scrive il nome della colonna nel foglio
  writeData(wb, sheet = "Riepilogo_summary", x = data.frame(Feature = colonna), startRow = start_row, startCol = 1, colNames = FALSE)
  start_row <- start_row + 1  # Riga vuota tra il nome della feature e i dati
  
  # Scrive la tabella delle statistiche summary
  writeData(wb, sheet = "Riepilogo_summary", x = df, startRow = start_row, startCol = 1, colNames = TRUE)
  
  # Aggiunge una riga vuota dopo ogni tabella per leggibilità
  start_row <- start_row + nrow(df) + 2
}

# Salva il workbook
saveWorkbook(wb, "Analisi_univariata.xlsx", overwrite = TRUE)