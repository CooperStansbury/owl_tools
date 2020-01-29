#!/usr/bin/env Rscript

# libraries
library('igraph')
library("RColorBrewer")

# import files from command line args
# if generated using ./get_data.py they will be in correct format
nodes <- read.csv('nodes.csv', header=T, as.is=T)
links <- read.csv('edges.csv', header=T, as.is=T)

# create network object from imported data
net <- graph_from_data_frame(d=links, vertices=nodes, directed=T)

# create vector of parent purls
V(net)$purl = nodes$parent.purl

# generate colors for each parent ontology
colr = brewer.pal(4, "Spectral")

# set color vector
V(net)$color <- colr[as.numeric(as.factor(V(net)$purl))]

# set layout
# l <- layout_in_circle(net)
# l <- layout_randomly(net)
l <- layout_as_tree(net, root=1, mode = 'all')

# plot
# plot(net)
plot(net,
     vertex.label=V(net)$label,
     vertex.label.color=V(net)$color,
     vertex.label.cex=1,
     vertex.shape='none',
     edge.color="grey",
     edge.arrow.size=.2,
     edge.label=E(net)$type,
     edge.label.cex=1,
     edge.label.color='black',
     layout=l,
     rescale=T)

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
       inset = c(0, .5))
