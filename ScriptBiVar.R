# Librerie----
library(corrplot)

# Caricamento dataset ----
ds <- read.csv("Dataset.csv", header=TRUE, sep=",")

colonne <- c("domain_length", "number_of_dots_in_domain", "number_of_hyphens_in_domain", "number_of_special_characters_in_domain", "number_of_digits_in_domain", "having_repeated_digits_in_domain", "number_of_subdomains", "average_subdomain_length", "number_of_digits_in_subdomain")
dati <- dataset[, colonne]

correlations <- cor(dati)
correlations

corrplot(
  correlations,
  method = "color",                # Usa colori per rappresentare le correlazioni
  col = colorRampPalette(c("darkgreen", "white", "lightblue"))(200),  # Scala colori
  type = "upper",                  # Mostra solo la parte superiore della matrice
  order = "hclust",                # Ordina le variabili in base alla correlazione
  tl.col = "black",                # Colore delle etichette delle variabili
  tl.cex = 0.6,                    # Dimensione del testo delle etichette
  tl.srt = 45,                     # Rotazione delle etichette
  cl.cex = 0.8                     # Dimensione del testo della legenda
)

