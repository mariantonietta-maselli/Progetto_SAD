# Librerie----
library(corrplot)
library(data.table)

# Caricamento dataset ----
dataset <- read.csv("datasets/Dataset_Clean_Phishing_Domain.csv", header=TRUE, sep=",")

dataset$Type <- NULL
dataset$having_repeated_digits_in_domain <- NULL

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

cor(dataset$domain_length, dataset$entropy_of_domain)
plot(dataset$domain_length, dataset$number_of_subdomains, 
     xlab = "entropy of domain", ylab = "domain length",
     main = "domain length in funzione di entropy of domain",
     cex = 0.5)

cor(dataset$domain_length, dataset$number_of_subdomains)
plot(dataset$domain_length, dataset$number_of_subdomains, 
     xlab = "entropy of domain", ylab = "domain length",
     main = "domain length in funzione di number of subdomains",
     cex = 0.5)

cor(dataset$domain_length, dataset$number_of_dots_in_domain)
plot(dataset$domain_length, dataset$number_of_dots_in_domain, 
     xlab = "entropy of domain", ylab = "domain length",
     main = "domain length in funzione di number of dots",
     cex = 0.5)


modello <- lm(domain_length ~ number_of_subdomains, data = dataset)
modello

plot(dataset$domain_length, dataset$number_of_subdomains, 
     xlab = "entropy of domain", ylab = "domain length",
     main = "domain length in funzione di number of subdomains",
     cex = 0.5)
abline(modello, col = "red")
