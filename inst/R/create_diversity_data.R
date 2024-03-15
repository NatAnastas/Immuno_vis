



library(data.table)



df = data.table(
    "Sample" = paste0("S", seq_len(5000)),
    "Group" = paste0("W", sample( seq_len(5), 5000, replace = TRUE )),
    "Patient" = paste0("P", sample( seq_len(2), 5000, replace = TRUE ))
)


df$Shannon = ifelse(
    df$Group == "W1", sample(seq(0, 1000, by = .01), 5000), 
    ifelse(
        df$Group == "W3", sample(seq(0, 3000, by = .01), 5000), 
        ifelse(
            df$Group == "W2", sample(seq(0, 500, by = .01), 5000), 
            ifelse(
                df$Group == "W4", sample(seq(0, 1500, by = .01), 5000),
                sample(seq(0, 2000, by = .01), 5000)
            )
        )
    )
)

df$Shannon = ifelse(df$Group == "W3" & df$Patient == "P2", df$Shannon / 2, df$Shannon)
df$Shannon = ifelse(df$Group == "W2" & df$Patient == "P1", 4 * df$Shannon, df$Shannon)



fwrite(
  df, "inst/data/diversity1.txt",
  row.names = FALSE, quote = FALSE, sep = "\t"
)















