# Librerie----
library(corrplot)
library(data.table)

# Caricamento dataset ----
dataset <- read.csv("datasets/Dataset_Clean_Phishing_Domain.csv", header=TRUE, sep=",")

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

# Scatterplot regressione lineare multipla ----

# Fissa un valore per number_of_subdomains, ad esempio la media
fixed_subdomains <- mean(dataset$number_of_subdomains)

# Calcola i valori previsti per domain_length con il modello
predicted_values <- predict(modello, newdata = data.frame(
  entropy_of_domain = dataset$entropy_of_domain,
  number_of_subdomains = fixed_subdomains
))

# Plot dei dati osservati
plot(dataset$entropy_of_domain, dataset$domain_length, 
     xlab = "Entropy of Domain", ylab = "Domain Length",
     main = "Domain Length in funzione di Entropy of Domain (con outlier)",
     cex = 0.5, col = "skyblue")

# Aggiunge la curva prevista dal modello
lines(sort(dataset$entropy_of_domain), 
      predicted_values[order(dataset$entropy_of_domain)], 
      col = "red", lwd = 2)

# Calcolo residui ----

residui <- resid(modello)

media_residui <- mean(residui)
cat(format(media_residui, scientific = FALSE, trim = TRUE))

valori_previsti <- fitted(modello)
valori_osservati <- dataset$domain_length

# Grafico di densità dei residui
plot(density(residui), 
     main = "Distribuzione dei Residui", 
     xlab = "Residui", ylab = "Densità", 
     col = "skyblue", lwd = 2)