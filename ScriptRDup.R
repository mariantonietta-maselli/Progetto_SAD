# Librerie ----
library(data.table)

# Caricamento del sample ----
df <- read.csv("datasets/Dataset_Phishing_Sample_Qwen.csv")

# Conteggio delle righe del sample ----
nrow(df)

# Rimozione delle righe duplicate dal sample ----
dff <- df[!duplicated(df), ]

# Nuovo conteggio delle righe ----
nrow(dff)

# Stampa su csv il sample sintetico senza duplicati ----
fwrite(dff, "datasets/Dataset_Phishing_Sample_Qwen_NoDup.csv")