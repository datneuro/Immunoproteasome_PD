# Library & color define ----
library(ggpubr)
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)
library(patchwork)
library(ggsignif)
library(ggsci)  
library(cowplot) 
library(ggstatsplot)
library(finalfit)
library(pastecs)



npg_colors <- pal_npg()(4) 
npg_colors
npg_colors = c("#4DBBD5FF","#E64B35FF")

#Import data & EDA-----
load("FACS_data_IP2.RData")
FACS_descriptive <- stat.desc(all_facs, norm = TRUE)
delta_descriptive <- stat.desc(delta_facs, norm = TRUE)

mfi_types <- c("HLA-DR/P/Q in Monocytes", "HLA-DR/P/Q in T cells")

#Violin-Box plot of delta changes ---- 
plot_list<- delta_facs %>%
  split(.$Cell.types) %>%
  lapply(function(data) {
    # Set the y-axis label based on Cell.types
    y_label <- ifelse(unique(data$Cell.types) %in% mfi_types, 
                      "MFI (Median)", 
                      expression(Delta ~ "frequency"))
    y_max <- max(data$Proportion, na.rm = TRUE) * 1.5
    p <- ggplot(data, aes(x = diag, y = Proportion, color = diag, fill = diag)) +
      geom_violin(alpha = 0.2, color = NA) +  
      geom_boxplot(width = 0.2, outlier.shape = NA, alpha = 0.5) + 
      geom_point(position = position_jitter(width = 0.2), size = 5, alpha = 0.5, aes(shape = sex)) + 
      stat_summary(fun.data = "mean_sdl", fun.args = list(mult = 1), geom = "pointrange", size = 1) +  
      labs(y = y_label, x = "") +
      scale_color_manual(values = npg_colors) +
      scale_fill_manual(values = npg_colors) +
      theme_minimal() +
      ggtitle(unique(data$Cell.types)) +
      theme(
        legend.position = "bottom",
        plot.title = element_text(size = rel(3.5),face = "bold"), 
        axis.title.y = element_text(size = rel(3)),        
        axis.title.x = element_text(size = rel(3)),        
        axis.text.x = element_text(size = rel(2.5)),
        axis.text.y = element_text(size = rel(2)) 
      ) +
      ylim((min(data$Proportion, na.rm = TRUE)), y_max)  
    
    
    comparisons <- list(c("HC", "PD"))
    
    for (comp in comparisons) {
      test <- wilcox.test(data$Proportion[data$diag == comp[1]],
                          data$Proportion[data$diag == comp[2]])$p.value
      
      if (!is.na(test)) {
        if (test < 0.01) {
          p <- p + geom_signif(comparisons = list(comp),
                               annotations = "**",
                               textsize = 10,  
                               color = "black")
        } else if (test < 0.05) {
          p <- p + geom_signif(comparisons = list(comp),
                               annotations = "*",
                               textsize = 10,  
                               color = "black")
        }
      }
    }
    return(p)
  })


combined_plot_delta <- wrap_plots(plot_list) +
  plot_layout(ncol = 2, guides = "collect") & theme(legend.position = "none")


legend <- ggplot() +
  geom_point(aes(x = 1, y = 0.85), shape = 16, size = 7, color = "black", alpha = 0.5) +  
  geom_point(aes(x = 1, y = 0.84), shape = 17, size = 7, color = "black", alpha = 0.5) +  
  annotate("text", x = 1.2, y = 0.85, label = "Female", hjust = 0, size = rel(9)) +       
  annotate("text", x = 1.2, y = 0.84, label = "Male", hjust = 0, size = rel(9)) +       
  xlim(0.9, 1.7) + ylim(0.75, 0.95) +  
  theme_void()

final_plot_delta <- cowplot::plot_grid(combined_plot_delta, legend, ncol = 2, rel_widths = c(1, 0.1), rel_heights = c(1, 1))

print(final_plot_delta) #22*22inch PDF





# PAIRPLOTS ---- 
make_pairplot_func <- function(data, column, y_label) {
  y_max <- max(data[[column]], na.rm = TRUE) * 1.5  
  
  ggplot(data = data, aes_string(y = column, x = "Treatment")) + 
    geom_line(aes(group = id, color = Group), alpha = 0.5, show.legend = TRUE) +  
    geom_point(aes(shape = Treatment, color = Group), size = 5,  
               position = position_dodge(width = 0.2), show.legend = TRUE) + 
    facet_wrap(~ Group, nrow = 1, strip.position = "top") +  
    labs(x = "Treatment", y = y_label, color = "Group", shape = "Treatment") + 
    scale_color_manual(values = npg_colors, labels = c("HC", "PD")) +  
    scale_shape_manual(values = c(16, 17)) +  
    theme_classic() +
    theme(
      strip.background = element_blank(),
      strip.text.x = element_blank(),
      axis.title.y = element_text(size = rel(1.5), face = "bold"),
      axis.title.x = element_text(size = rel(1.5), face = "bold"),
      text = element_text(family = "Helvetica"),
      plot.tag = element_text(size = 16, face = "bold"),
      legend.text = element_text(size = 14),  
      legend.key.size = unit(1.5, "cm")
    ) +
    stat_compare_means(
      aes(group = Treatment),
      label = "p.signif",
      method = "wilcox.test",
      paired = TRUE,
      label.y = y_max * 0.8,  
      size = 15, 
      label.x.npc = "center",
      hide.ns = TRUE
    ) +
    coord_cartesian(ylim = c(0, y_max))
}

# Create a mapping of column names to y-axis labels
columns_labels <- list(
  "monocyte" = "Monocyte frequency",
  "hla2.monocyte" = "HLA-DR/P/Q in Monocytes (MFI)",
  "cd56dim" = "CD56dim frequency",
  "cd56bright" = "CD56bright frequency",
  "nkt" = "NKT frequency",
  "t.cell" = "T cell frequency",
  "mfihla_cd3" = "HLA-DR/P/Q in T cells (MFI)",
  "b.cell" = "B cell frequency",
  "cd4" = "CD4 T cell frequency",
  "cd8" = "CD8 T cell frequency"
)

# Generate plots for all specified columns
pair_plots_list <- lapply(names(columns_labels), function(col) {
  make_pairplot_func(all_facs, col, columns_labels[[col]])
})

# Combine all plots using patchwork
combined_plot <- wrap_plots(pair_plots_list, ncol = 2) +  # Keep separation by facet
  plot_annotation(tag_levels = 'a') + 
  plot_layout(guides = "collect") &  # Collect legends
  theme(
    plot.tag = element_text(size = 30, face = "bold"),  
    legend.position = "bottom",  # Place legend at the bottom
    legend.box = "horizontal",  # Arrange legend items horizontally
    legend.text = element_text(size = 20),  # Increase legend text size
    legend.key.size = unit(1.5, "cm"),  # Increase legend symbol size
    legend.title = element_text(size = 20)  # Increase legend title size
  )

# Print the combined plot
print(combined_plot) #Save to portrait figure 25*20 inch 
