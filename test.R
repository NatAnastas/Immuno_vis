library(readxl)
suppressPackageStartupMessages(library(circlize))
library(data.table)


# import data
df <- read_excel("../inst/data/chordDiagram.xlsx") |>
  as.data.frame()


# change df
rownames(df) <- df$IGLJ
df$IGLJ = NULL
df = as.matrix(df)



# Define specific colors for names
grid.col1 = c(IGLJ3 = "#D53E4F",IGLJ2 = "#5E4FA2", IGLJ1 ="#66C2A5")

# Define specific colors for the IGJV sectors
iglj_colors <- c(IGLJ3 = "#D53E4F", IGLJ2 = "#5E4FA2", IGLJ1 ="#66C2A5")

# Extract sector names from the data frame that start with "IGJV"
iglj_sectors <- colnames(df)[startsWith(colnames(df), "IGLJ")]

# Exclude sectors that are already in grid.col1
iglj_sectors <- setdiff(iglj_sectors, names(grid.col1))



# Assign specific colors to the IGJV sectors
for (i in seq_along(iglj_sectors)) {
  grid.col1[iglj_sectors[i]] <- iglj_colors[i]
}


# Extract entity names from the data frame that start with "IGLV"
iglv_entities <- colnames(df)[startsWith(colnames(df), "IGLV")]

# Exclude entities that are already in grid.col1
iglv_entities <- setdiff(iglv_entities, names(grid.col1))



# Assign them the color "grey"
for (entity in iglv_entities) {
  grid.col1[entity] <- "grey10"
}


# chord diagram
# vertical symmetric
circos.clear()
circos.par(start.degree = -90)


# empty track
chordDiagram(df, grid.col = grid.col1, annotationTrack = c("grid", "names"),
             annotationTrackHeight = c(0.01, 0.001),
             preAllocateTracks = list(track.height = 0.1))


# customize labels
circos.track(track.index = 1, panel.fun = function(x, y) {
  circos.text(CELL_META$xcenter, CELL_META$ylim[1], CELL_META$sector.index, 
              facing = "clockwise", niceFacing = TRUE, adj = c(0, 0.5),
              cex = 0.4)
}, bg.border = NA) 

circos.clear()

