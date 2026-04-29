install.packages("tidyverse")
library(tidyverse)
# installo e carico tidyverse
install.packages("tidyverse")
library(tidyverse)

# Creo datafame con tibble() e aggiungo tutte le colonne di interesse
#(posso sempre aggiungerne o toglierne a piacimento)
df_flux <- tibble(
  ID_Smithsonian = character(),
  Volcano_Name = character(),
  Site_Name = character(),      
  Measurement_Date = as.Date(character()),
  Flux_Total_Ton_Day = numeric(),
  Flux_Avg = numeric(),
  Flux_Min = numeric(),
  Flux_Max = numeric(),
  Flux_SD = numeric(),
  Lat = numeric(),
  Lon = numeric(),
  Reference = character()
)
# 2. Importo dati copiati (in precedenza copia-incollati su excel)
temp_df <- read.table("clipboard", header = TRUE, sep = "\t", check.names = FALSE)

#sistemo il dataframe (nomi colonne, aggiungo e fillo colonne extra e uniformo la formattazione)
temp_df_clean <- temp_df %>%
  #rinomino
  rename(
    Flux_Min = `Min(g/m2 day)`,
    Flux_Avg = `Avg.(g/m2 day)`,
    Flux_Max = `Max(g/m2 day)`,
    Flux_Total_Ton_Day = `Total flux(tonnes/day)`,
    Measurement_Date = `Date(d/m/y)`
  ) %>%
  #aggiungo colonne mancanti per uniformare i dati al dataframe a cui verranno aggiunti
  mutate(
    ID_Smithsonian = "211040",
    Volcano_Name = "Stromboli",
    Site_Name = "Pizzo sopra La Fossa",
    Reference = "Ingv_2008_Table2",
    Lat = NA_real_, 
    Lon = NA_real_,
    Flux_SD = NA_real_
  ) %>%
  #formattazione valori e rimozioni di segni anomali
  mutate(Measurement_Date = str_trim(str_remove(Measurement_Date, "[a-c]$"))) %>%
  mutate(Measurement_Date = dmy(Measurement_Date)) %>%
  mutate(
    Flux_Avg = ifelse(Flux_Avg == "<1", 0.5, as.numeric(Flux_Avg)),
    Flux_Min = ifelse(Flux_Min == "<1", 0.5, as.numeric(Flux_Min)),
    Flux_Max = ifelse(Flux_Max == "<1", 0.5, as.numeric(Flux_Max))
  ) %>%
  #metto le colonne in ordine
  select(ID_Smithsonian, Volcano_Name, Site_Name, Measurement_Date, Flux_Total_Ton_Day, Flux_Avg, Flux_Min, Flux_Max, Flux_SD, Lat, Lon, Reference)

# aggiungo a df_flux (potevo usare rbind())
df_flux <- bind_rows(df_flux, temp_df_clean)

# 4. Rimuoviamo la variabile temporanea
rm(temp_df, temp_df_clean)
