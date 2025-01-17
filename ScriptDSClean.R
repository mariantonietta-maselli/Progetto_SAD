# Caricamento del dataset ----
ds <- read.csv("Dataset.csv", header=TRUE, sep=",")

# Estrazione dal dataset della partizione phishing ----
ds <- read.csv("Dataset.csv", header=TRUE, sep=",")
dsp <- ds[ds$Type == 1,]

# Stampa su csv la partizione phishing del dataset ridotto ----
fwrite(dsp, "Dataset_Phishing.csv")

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
ds$average_number_of_hyphens_in_subdomain <- NULL
ds$having_special_characters_in_subdomain <- NULL
ds$number_of_special_characters_in_subdomain <- NULL
ds$having_repeated_digits_in_subdomain <- NULL
ds$having_digits_in_subdomain <- NULL
ds$having_special_characters_in_domain <- NULL

# Stampa su csv il dataset con feature ridotte ----
fwrite(ds, "Dataset_Clean.csv")

# Estrazione dal dataset ridotto, della partizione phishing ----
ds <- read.csv("Dataset_Clean.csv", header=TRUE, sep=",")
dsp <- ds[ds$Type == 1,]

# Stampa su csv la partizione phishing del dataset ridotto ----
fwrite(dsp, "Dataset_Clean_Phishing.csv")