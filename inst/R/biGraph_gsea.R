



# clean environment -------------------

rm(list = ls())
gc()

# load libraries ------------------------------

library(data.table)
library(stringr)

library(tidygraph)
library(dplyr)

library(ggplot2)
library(ggrepel)
library(ggraph)
library(ggnewscale)
library(shadowtext)

library(extrafont)


# input data --------------------

path <- "sigkriseis_heatmap.xlsx"

df <- path |> readxl::read_xlsx(sheet = 4) |> setDT()
df <- df |>
  select(Description, geneID)

df$Description = df$Description |> 
    str_remove_all("GOBP") |> 
    str_to_title() |> 
    str_replace_all("_", " ") |> 
    str_squish()



fwrite(
  df, "pathway_diagram.txt",
  row.names = FALSE, quote = FALSE, sep = "\t"
       )

q <- df$geneID |> 
    str_split("\\/") |> 
    lapply(function(x) { data.table("to" = x) }) |> 
    rbindlist(idcol = "from")

q$from <- df[q$from]$Description 

layout <- q |>
    as_tbl_graph() |> 
    mutate(Degree = centrality_degree(mode = 'all')) |>
    create_layout(layout = 'igraph', algorithm = 'kk')

layout$Level <- ifelse(layout$name %in% q$to, "Gene", "Term")
layout$name <- layout$name |> str_wrap(width = 15)



ggraph(layout) + 
    
    geom_edge_link(color = "#97A1A7", edge_width = .2) + 
    
    geom_node_point(
        aes(size = Degree, fill = Level), shape = 21,
        stroke = .2, color = "grey96"
    ) + 
    
    scale_size_continuous(
        range = c(2, 10), 
        guide = guide_legend(
            title = "No. of connections",
            override.aes = list(color = "grey10", stroke = .35)
        )
    ) +
    
    scale_fill_manual(
        values = c(
            "Term" = "#2E2A2B",
            "Gene" = "#DC9445"
        ),
        guide = "none" # guide_legend(override.aes = list(size = 8))
    ) +
    
    # scale_size_manual(
    #     values = c(
    #         "Term" = 10,
    #         "Gene" = 2
    #     ), guide = "none"
    # ) +
    
    new_scale("size") +
    
    geom_text_repel(
        aes(x, y, label = name, size = Degree),
        family = "Calibri", fontface = "bold", 
        color = "grey10", bg.color = "grey96", bg.r = 0.075,
        segment.linetype = "dotted", segment.size = .2,
        max.overlaps = Inf
    ) +

    scale_size_continuous(range = c(2, 3), guide = "none") +
    
    theme_graph(base_family = "Calibri") +
    
    theme(
        legend.position = c(.95, .1),
        legend.title.position = "top",
        plot.margin = margin(20, 20, 20, 20)
    )


# output plot -------------

ggsave(
    plot = gr, filename = "PB_CD4_vs_CD8.jpeg",
    width = 12, height = 12, units = "in", dpi = 600
)





