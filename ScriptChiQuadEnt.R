# Librerie ----
library(data.table)

# Caricamento del dataset ----
#ds <- read.csv("datasets/Dataset_Clean_Phishing_Domain_Inlier.csv", header=TRUE, sep=",")

# Pre-selezione di un sample randomico del 1% ----
#dss <- ds[sample(nrow(ds), 1194),]
#fwrite(dss, "datasets/Dataset_Phishing_Sample1p.csv")

# Caricamento del sample sintetico ----
#ds <- read.csv("datasets/Dataset_Phishing_Sample_Qwen_NoDup.csv", header=TRUE, sep=",")

# Pre-selezione di un sample sintetico pari a 1% del campione reale ----
#dss <- ds[sample(nrow(ds), 1194),]
#fwrite(dss, "datasets/Dataset_Phishing_Sample_Qwen_NoDup_1p.csv")

# Caricamento del sample ----
dss <- read.csv("datasets/Dataset_Phishing_Sample_Qwen_NoDup_1p.csv", header=TRUE, sep=",")

# Estrazione della colonna di domain_length
entropy <- dss$entropy_of_domain
entropy

# Calcolo del numero di osservazioni
n <- length(entropy)
n

# Calcolo della media
m <- mean(entropy)
m

# Calcolo della deviazione standard
d <- sd(entropy)
d

# Determinazione dei quantili della normale
a <- numeric(4)
for (i in 1:4) {
  a[i] <- qnorm(0.2*i, mean = m, sd = d)
}
a

# Determinazione delle frequenze delle intervalli ----
r <- 5

nint <- numeric(r)

nint[1] <- length(which(entropy<a[1]))
nint[2] <- length(which((entropy>=a[1])&(entropy<a[2])))
nint[3] <- length(which((entropy>=a[2])&(entropy<a[3])))
nint[4] <- length(which((entropy>=a[3])&(entropy<a[4])))
nint[5] <- length(which(entropy>=a[4]))
nint

sum(nint)

# Calcolo del chi quadrato ----
chi2 <- sum(((nint-n*0.2)/sqrt(n*0.2))^2)
chi2

# Calcolo della regione di accettazione ----
r <- 5
k <- 2
alpha <- 0.05

qchisq(alpha/2,df=r-k-1)
qchisq(1-alpha/2,df=r-k-1)