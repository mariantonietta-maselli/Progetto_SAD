# Librerie ----
library(corrplot)
library(data.table)

# Caricamento dataset ----
dataset <- read.csv("datasets/Dataset_Clean_Phishing_Domain_Inlier.csv", header=TRUE, sep=",")

# Analisi delle correlazioni ----
correlations <- cor(dataset)

corrplot(
  correlations,
  method = "square",  # Usa colori per rappresentare le correlazioni
  type = "upper",     # Mostra solo la parte superiore della matrice
  order = "hclust",   # Ordina le variabili in base alla correlazione
  tl.col = "black",   # Colore delle etichette delle variabili
  tl.cex = 0.6,       # Dimensione del testo delle etichette
  tl.srt = 45,        # Rotazione delle etichette
  cl.cex = 0.8        # Dimensione del testo della legenda
)

# Regressione lineare ----
# Il modello prevede la lunghezza del dominio in funzione all'entropia dello stesso
modello <- lm(domain_length ~ entropy_of_domain, data = dataset)
modello

risultati <- summary(modello)
risultati

plot(dataset$entropy_of_domain, dataset$domain_length, 
     xlab = "entropy_of_domain", ylab = "domain length",
     main = "domain length in funzione di entropy of domain (con outlier)",
     cex = 0.5, col = "skyblue")
abline(modello, col = "red")

# Calcolo residui ----
residui <- resid(modello)

media_residui <- mean(residui)
cat(format(media_residui, scientific = FALSE, trim = TRUE))

valori_previsti <- fitted(modello)
valori_osservati <- dataset$domain_length