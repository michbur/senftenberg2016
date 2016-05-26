source("my_ggplot_theme.R")

library(dplyr)
library(reshape2)


qpcr_dat <- reps2[, c(1L:15)] %>% 
  mutate(Cycles = factor(Cycles)) %>% 
  melt(value.name = "Fluorescence") %>% 
  mutate(Cycles = as.numeric(as.character(Cycles)))

qpcr2pp_res <- qpcr2pp(reps2[, c(1L:15)])

qpcr2pp_dat <- data.frame(slot(qpcr2pp_res, "qpcr"))

p1 <- ggplotGrob(ggplot(qpcr_dat, aes(x = Cycles, y = Fluorescence, color = variable, group = variable)) +
  geom_line() +
  scale_color_discrete(guide = FALSE) +
  scale_x_continuous("Cycle") +
  my_theme)

p2 <- ggplotGrob(ggplot(qpcr2pp_dat, aes(x = Cycles, y = lambda)) +
  geom_step() +
  geom_rug(sides="b") +
  scale_y_continuous(expression(lambda)) +
  scale_x_continuous("Cycle", limits = c(1, 45)) +
  my_theme)

max_width = unit.pmax(p1[["widths"]][2:5], p2[["widths"]][2:5])
p1[["widths"]][2:5] <- as.list(max_width)
p2[["widths"]][2:5] <- as.list(max_width)

cairo_ps("./dpcr_figures/qpcr2pp.eps", width = 13, height = 8, onefile = FALSE)
grid.draw(grobTree(rectGrob(gp=gpar(fill=adjustcolor("white", alpha.f = 0))), 
                   grid.arrange(textGrob("A", x = 0.75, y = 0.9, gp=gpar(fontsize=24)), p1, 
                                textGrob("B", x = 0.75, y = 0.9, gp=gpar(fontsize=24)), p2,
                                nrow = 2, ncol = 2, widths = c(0.05, 0.95))))
dev.off()

