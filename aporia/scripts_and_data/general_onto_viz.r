#!/usr/bin/env Rscript

# libraries
library('igraph')
library("RColorBrewer")

# command line args
args = commandArgs(trailingOnly=TRUE)

# import files from command line args
# if generated using ./get_data.py they will be in correct format
nodes <- read.csv('scripts_and_data/nodes_psdo.csv', header=T, as.is=T)
links <- read.csv('scripts_and_data/edges_psdo.csv', header=T, as.is=T)

# create network object from imported data
net <- graph_from_data_frame(d=links, vertices=nodes, directed=T)

# remove loops
net <- simplify(net, remove.multiple = F, remove.loops = T)

# create vector of parent purls
V(net)$purl = nodes$parent.purl

# generate colors for each parent ontology
colr = brewer.pal(length(unique(V(net)$purl)), "Spectral")

# set color vector
V(net)$color <- colr[as.numeric(as.factor(V(net)$purl))]

# set layout
l <- layout_with_fr(net)
# l <- layout_as_tree(net, root=1, mode = 'all')

# plot
# plot(net)

plot(net,
     vertex.label=NA,
     edge.color="black",
     edge.arrow.size=.2,
     layout=l,
     rescale=T,
     vertex.color=V(net)$color,
     vertex.size=nodes$entity.weight*75)

# add legend
legend("bottomleft",
       legend=levels(as.factor(V(net)$purl)),
       fill = colr,
       border = 'black',
       bty = "n", 
       pch=20 ,
       pt.cex = 3,
       cex = 1.5,
       text.col=colr,
       horiz = FALSE,
       inset = c(0, 0))
