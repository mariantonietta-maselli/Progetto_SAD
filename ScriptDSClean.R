# Librerie ----
library(data.table)

# Caricamento del dataset ----
ds <- read.csv("datasets/Dataset.csv", header=TRUE, sep=",")

# Estrazione dal dataset della partizione legitimate ----
dsp <- ds[ds$Type == 0,]
dsp$Type <- NULL

# Stampa su csv la partizione legitimate del dataset ridotto ----
fwrite(dsp, "datasets/Dataset_Legitimate.csv")

# Estrazione dal dataset della partizione phishing ----
dsp <- ds[ds$Type == 1,]
dsp$Type <- NULL

# Stampa su csv la partizione phishing del dataset ridotto ----
fwrite(dsp, "datasets/Dataset_Phishing.csv")

# Rimozione delle feature inutili ----
ds$number_of_at_in_url <- NULL
ds$number_of_dollar_in_url <- NULL
ds$number_of_exclamation_in_url <- NULL
ds$number_of_hashtag_in_url <- NULL
ds$having_path <- NULL
ds$having_fragment <- NULL
ds$having_anchor <- NULL
ds$having_dot_in_subdomain <- NULL
ds$having_hyphen_in_subdomain <- NULL
ds$average_number_of_dots_in_subdomain <- NULL
ds$having_repeated_digits_in_domain <- NULL
ds$average_number_of_hyphens_in_subdomain <- NULL
ds$having_special_characters_in_subdomain <- NULL
ds$number_of_special_characters_in_subdomain <- NULL
ds$having_repeated_digits_in_subdomain <- NULL
ds$having_digits_in_domain <- NULL
ds$having_digits_in_subdomain <- NULL
ds$having_special_characters_in_domain <- NULL

# Stampa su csv il dataset con feature ridotte ----
fwrite(ds, "datasets/Dataset_Clean.csv")

# Estrazione dal dataset ridotto, della partizione phishing ----
ds <- read.csv("datasets/Dataset_Clean.csv", header=TRUE, sep=",")
dsp <- ds[ds$Type == 1,]
dsp$Type <- NULL

# Stampa su csv la partizione phishing del dataset ridotto ----
fwrite(dsp, "datasets/Dataset_Clean_Phishing.csv")

# Rimozione delle feature non legate al dominio ----
dsp$url_length <- NULL
dsp$number_of_dots_in_url <- NULL
dsp$having_repeated_digits_in_url <- NULL
dsp$number_of_digits_in_url <- NULL
dsp$number_of_special_char_in_url <- NULL
dsp$number_of_hyphens_in_url <- NULL
dsp$number_of_underline_in_url <- NULL
dsp$number_of_slash_in_url <- NULL
dsp$number_of_questionmark_in_url <- NULL
dsp$number_of_equal_in_url <- NULL
dsp$number_of_percent_in_url <- NULL
dsp$path_length <- NULL
dsp$having_query <- NULL
dsp$entropy_of_url <- NULL

# Stampa su csv il dataset con feature ridotte al dominio ----
fwrite(dsp, "datasets/Dataset_Clean_Phishing_Domain.csv")


# Rimozione outlier per le feature da utilizzare ----
dsi <- dsp

features <- c("domain_length", "entropy_of_domain")

for(colonna in features) {
  col = dsi[[colonna]]
  Q1 = quantile(col, 0.25)
  Q3 = quantile(col, 0.75)
  IQR <- Q3 - Q1
  lower = Q1 - 1.5 * IQR
  upper = Q3 + 1.5 * IQR
  dsi <- subset(dsi, col >= lower & col <= upper)
}

# Stampa su csv il dataset senza outlier ----
fwrite(dsi, "datasets/Dataset_Clean_Phishing_Domain_Inlier.csv")

