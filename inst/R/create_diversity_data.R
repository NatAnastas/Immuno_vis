



library(data.table)

nobs = 1000

df = data.table(
    "Sample" = paste0("S", seq_len(nobs)),
    "Group" = paste0("W", sample( seq_len(5), nobs, replace = TRUE )),
    "Patient" = paste0("P", sample( seq_len(2), nobs, replace = TRUE ))
)

df = df |> 
  
  split(by = c("Group", "Patient")) |>
  
  lapply(function(q) {
    
    m = sample(seq(10, 30, by = 1), 1)
    
    s = sample(seq(1, 10, by = .01), 1)
    
    q$Shannon = rnorm(nrow(q), m, s) |> round(digits = 4)
    
    return(q)
    
  }) |>
  
  rbindlist()




# df$Shannon = ifelse(
#     df$Group == "W1", sample(seq(0, 1000, by = .01), 5000),
#     ifelse(
#         df$Group == "W3", sample(seq(0, 3000, by = .01), 5000),
#         ifelse(
#             df$Group == "W2", sample(seq(0, 500, by = .01), 5000),
#             ifelse(
#                 df$Group == "W4", sample(seq(0, 1500, by = .01), 5000),
#                 sample(seq(0, 2000, by = .01), 5000)
#             )
#         )
#     )
# )
# 
# df$Shannon = ifelse(df$Group == "W3" & df$Patient == "P2", df$Shannon / 2, df$Shannon)
# df$Shannon = ifelse(df$Group == "W2" & df$Patient == "P1", 4 * df$Shannon, df$Shannon)



fwrite(
  df, "inst/data/diversity1.txt",
  row.names = FALSE, quote = FALSE, sep = "\t"
)

# library(immunarch)
# library(vegan)
# 
# data("immdata")
# 
# index = immdata$data |> length() |> seq_len() |> rep(each = 50)
# 
# immdata_list = immdata$data[index]
# immdata_meta = immdata$meta[index, ]
# 
# names(immdata_list) = paste0( names(immdata_list), "_", rowid(immdata_meta$Sample) )
# immdata_meta$Sample = names(immdata_list)
# 
# 
# immdata_list = immdata_list |>
#   lapply(function(q) {
#     
#     m = ( max(q$Clones) + min(q$Clones) ) / 2
#     
#     s = sd(q$Clones) * 10
#     
#     q$Clones = q$Clones |> rnorm(mean = m, sd = s) |> round()
#     
#     q = q[which(q$Clones >= 1), ]
#     
#     q$Proportion = q$Clones / sum(q$Clones)
#     
#     q = q[order(-q$Clones), ]
#     
#   })
# 
# immdata_meta$Shannon = immdata_list |>
#   lapply(function(q) {
#     
#     diversity(q$Proportion)
#     
#   }) |>
#   unlist() |>
#   round(digits = 4)
# 
# 
# saveRDS(immdata_list, file = "inst/data/immdata.rds")
# 
# fwrite(
#   immdata_meta, "inst/data/diversity2.txt",
#   row.names = FALSE, quote = FALSE, sep = "\t"
# )













