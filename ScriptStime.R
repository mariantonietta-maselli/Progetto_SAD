# Caricamento del sample ----
df <- read.csv("datasets/Dataset_Phishing_Sample1p.csv")

# Estrazione della feature
entropy <- df$entropy_of_domain

# STIMA PUNTUALE ----
# Calcolo dello stima puntuale del valore medio della popolazione
stimamu <- mean(entropy)
stimamu

# Calcolo dello stima puntuale della varianza della popolazione
stimasigma2 <- ((length(entropy)-1)*var(entropy)/length(entropy))
stimasigma2


# STIMA INTERVALLARE ----

# Calcolo del grado di fiducia
alpha <- 1 - 0.99

# Calcolo della lunghezza del campione
n <- length(entropy)


# Calcolo del quantile di student
quantStud <- qt (1 - alpha / 2, df =n -1)
quantStud

# Calcolo dell'intervallo di stima
ldown <- stimamu - quantStud * sd(entropy) / sqrt(n)
ldown

lup <- stimamu + quantStud * sd(entropy) / sqrt(n)
lup