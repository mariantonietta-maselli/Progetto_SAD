# 1. Caricare il dataset in un dataframe OK
# 2. Creare un dataframe vuoto per memorizzare i risultati delle analisi OK
# 3. Utilizzare il dataframe per memorizzare tuti i passi dell'analisi TODO
# 4. Stampare su un unico file il dataframe OK
# 5. Stampare la singola riga del dataframe su un file dedicato OK


# Caricamento del dataset ----
cat("Caricamento del dataset","\n")
ds <- read.csv("Dataset.csv", header=TRUE, sep=",")

# Definizione intervalli
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

print(df)

# Frequenze e summary ----

breaks <- breaks_lista[[paste0(row, "_breaks")]]

df[row, "Freq. Ass"] <- table(cut(ds[[row]], breaks = breaks))

#df[row, "Freq. Rel"] <-   
#df[row, "Summary"] <- 

# Salva l'intero dataframe in un file .csv ----
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