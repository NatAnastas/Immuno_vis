

rm(list = ls())
gc()

library(data.table)
library(stringr)

library(ggplot2)

d0 = fread("clonotype-evolution.tsv")

d0$time = d0$time |> factor(levels = c("PRE", "6M", "12M", "18M", "24M"))


# plot 1 --------------------

d1 = d0[which(patient == 13)]

cl = d1[which(time == "PRE"), head(.SD, 10)]$clonotype

d1 = d1[which(clonotype %in% cl)]

library(ggstream)
library(paletteer)

d1 |> 
    ggplot(aes(time, Freq, fill = clonotype)) +
    
    # geom_stream(
    #     geom = "contour",
    #     color = "grey20",
    #     linewidth = 2,
    #     bw = .75,
    #     extra_span = .75,
    #     true_range = "both",
    #     sorting = "inside_out"
    # ) +
    
    geom_stream(
        type = "mirror",
        # geom = "polygon",
        color = "grey96",
        linewidth = .05,
        bw = .75,
        extra_span = .75,
        true_range = "both",
        sorting = "inside_out"
    ) +
    
    geom_vline(
        data = data.table(x = c(1, 2, 3, 4, 5)),
        aes(xintercept = x),
        color = "white", 
        linewidth = 1,
        linetype = "dotted"
    ) +
    
    scale_x_discrete(expand = c(0, 0)) +
    scale_fill_manual(
        values = paletteer_d("ggsci::hallmarks_light_cosmic"),
        guide = guide_legend(nrow = 4)
    ) +
    
    theme_minimal() +
    
    theme(
        legend.position = "bottom",
        legend.title.position = "top",
        
        axis.title.x = element_blank(),
        axis.text.x = element_text(face = "bold"),
        
        panel.grid = element_blank(),
        
        plot.margin = margin(20, 20, 20, 20)
    )


