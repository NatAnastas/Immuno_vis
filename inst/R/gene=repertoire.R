

library(ComplexHeatmap)

library(data.table)
library(stringr)

expr = readRDS(system.file(package = "ComplexHeatmap", "extdata", "gene_expression.rds"))

c_s = data.table(
    "sample" = expr[, 1:24] |> colnames(),
    "cell" = expr[, 1:24] |> colnames() |> str_split_i("_", 2)
)

m = expr[, 1:24] |> as.matrix() |> t() |> scale(scale = TRUE, center = TRUE) |> t()
r_s = expr[, c(25, 26, 27)]


fwrite(
  r_s, "r_s.txt",
  row.names = FALSE, quote = FALSE, sep = "\t"
)




col_ann = HeatmapAnnotation(
    "cell" = c_s$cell,
    simple_anno_size = unit(.75, "lines"),
    col = list(
        cell = c(
            "cell01" = "#358DB9", 
            "cell02" = "#CF4E9C", 
            "cell03" = "#2E2A2B"
        )
    )
)

row_ann = rowAnnotation(
    "Type" = r_s$type,
    simple_anno_size = unit(.75, "lines"),
    col = list(
        Type = c(
            "protein_coding" = "#358DB9", 
            "antisense" = "#CF4E9C", 
            "pseudogene" = "#2E2A2B",
            "others" = "#2F509E"
        )
    )
)

Heatmap(
    m, name = "Repertoire",
    
    border = TRUE,
    
    left_annotation = row_ann,
    top_annotation = col_ann,
    
    row_split = 3, column_split = 3,
    
    clustering_distance_rows = "euclidean", 
    clustering_distance_columns = "euclidean",
    
    clustering_method_rows = "ward.D2",
    clustering_method_columns = "ward.D2",
    
    row_names_gp = gpar(fontsize = 6)
) |> 
    draw(merge_legends = TRUE)
