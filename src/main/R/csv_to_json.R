#!/usr/bin/Rscript
library(tidyr)
library(dplyr)
library(jsonlite)
library(stringr)

narrower_from_broader  <- function(df) {
  # narrower uit "inverse" relatie broader
  broaders <- na.omit(distinct(df['broader']))
  for (broad in as.list(broaders$broader)) {
    relation <- subset(df, broader == broad ,
                       select=c(uri, broader))
    narrowers <- as.list(relation["uri"])
    df2 <- data.frame(broad, narrowers)
    names(df2) <- c("uri","narrower")
    df <- bind_rows(df, df2)
  }
  return(df)
}

df <- read.csv(file = "../resources/source/codelijst_sommatie_stoffen_source.csv", sep=",", na.strings=c("","NA"))
# fix voor vctrs_error_incompatible in pubchem column
df <- df %>%
  mutate_all(list(~ str_c("", .)))
# verdubbel rijen met pipe separator
for(col in colnames(df)) {   # for-loop over columns
  df <- df %>%
    separate_rows(col, sep = "\\|")%>%
    distinct()
}
# members van collection uit "inverse" relatie
collections <- na.omit(distinct(df['collection']))
for (col in as.list(collections$collection)) {
  medium <- subset(df, collection == col ,
                   select=c(uri, collection))
  medium_members <- as.list(medium["uri"])
  df2 <- data.frame(col, medium_members)
  names(df2) <- c("uri","member")
  df <- bind_rows(df, df2)
}
# hasTopConcept relatie uit inverse relatie
schemes <- na.omit(distinct(df['topConceptOf']))
for (scheme in as.list(schemes$topConceptOf)) {
  topconceptof <- subset(df, topConceptOf == scheme ,
                         select=c(uri, topConceptOf))
  hastopconcept <- as.list(topconceptof["uri"])
  df2 <- data.frame(scheme, hastopconcept)
  names(df2) <- c("uri","hasTopConcept")
  df <- bind_rows(df, df2)
}
df <- narrower_from_broader(df)

df <- df %>%
  rename("@id" = uri,
         "@type" = type)
write.csv(df,"../resources/be/vlaanderen/omgeving/data/id/conceptscheme/sommatie_stoffen/sommatie_stoffen_separate_rows.csv", row.names = FALSE)
context <- jsonlite::read_json("../resources/source/codelijst_context.json")
df_in_list <- list('@graph' = df, '@context' = context)
df_in_json <- toJSON(df_in_list, auto_unbox=TRUE)
write(df_in_json, "/tmp/sommatie_stoffen.jsonld")

# serialiseer jsonld naar mooie turtle en mooie jsonld
# hiervoor dienen jena cli-tools geinstalleerd, zie README.md
system("riot --formatted=TURTLE /tmp/sommatie_stoffen.jsonld > ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/sommatie_stoffen/sommatie_stoffen.ttl")
system("riot --formatted=JSONLD ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/sommatie_stoffen/sommatie_stoffen.ttl > ../resources/be/vlaanderen/omgeving/data/id/conceptscheme/sommatie_stoffen/sommatie_stoffen.jsonld")
