# Load necessary libraries
library(ggplot2)
library(readxl)
library(ggsignif)
library(ggpubr)
library(ggstatsplot)
library(dplyr)
library(ggsci)
library(pROC)
library(finalfit)
library(tidyplots)
library(purrr)

# Import Data----
master_data <- read_excel("pbmc_data_master_sheet.xlsx")

# Demographics Data
demographic_data <- master_data %>% 
  select(-c(Diagnosis, p8_rna, p9_rna, p10_rna, ip_rna, p5_pr, p8_pr, p9_pr, p10_pr, ubi_pr, 
    id, Disease_code, NOTE, umsar1, umsar2, Final_disease_code)) %>% 
  filter(diag %in% c("HC", "PD", "RBD", "MSA"))

explanatory_vars <- colnames(demographic_data %>% select(-diag))
demographics_summary <- summary_factorlist(
  demographic_data, "diag", explanatory_vars,
  p = TRUE, na_include = TRUE, add_dependent_label = TRUE,
  add_col_totals = TRUE, add_row_totals = TRUE
)

# RNA PLOTS ---- 

npg_colors = c("#4DBBD5FF","#00A087FF","#E64B35FF","#3C5488FF")
rna_plot <- function(data, gene_column, diagnosis_column, x_label, y_label) {
  plot <- ggbetweenstats(
    data = data,
    x = {{ diagnosis_column }},
    y = {{ gene_column }},
    plot.type = "box",
    messages = TRUE,
    type = "np",
    xlab = x_label,
    ylab = y_label,
    p.adjust.method = "holm",
    pairwise.comparisons = TRUE,
    digits = "scientific2", 
    theme = theme_classic(),
    centrality.plotting = FALSE,
    centrality.point.args = list(size = 3, color = "darkred", fill = "darkred"),
    centrality.label.args = list(size = 2, segment.linetype = 4, min.segment.length = 0),
    point.args = list(
      position = ggplot2::position_jitterdodge(dodge.width = 0.60),
      alpha = 0.6,
      size = 4,
      stroke = 0,
      na.rm = TRUE
    )) + scale_color_manual(values = npg_colors)
  

return(plot)
}


rna_data <- master_data %>% 
  select(id, diag, p8_rna, p9_rna, p10_rna, ip_rna) %>% 
  filter(diag %in% c("HC", "PD", "RBD", "MSA")) %>% 
  mutate(diag = factor(diag, levels = c("HC", "RBD", "PD", "MSA")))

# RNA plots
psmb8_plot <- rna_plot(rna_data, gene_column = p8_rna, diagnosis_column = diag, x_label = "GROUP", y_label = expression(bold("PSMB8 mRNA (2"^{-Delta*Delta*"C"["t"]}*")")))
psmb9_plot <- rna_plot(rna_data, gene_column = p9_rna, diagnosis_column = diag, x_label = "GROUP", y_label = expression(bold("PSMB9 mRNA (2"^{-Delta*Delta*"C"["t"]}*")")))
psmb10_plot <- rna_plot(rna_data, gene_column = p10_rna, diagnosis_column = diag, x_label = "GROUP", y_label = expression(bold("PSMB10 mRNA (2"^{-Delta*Delta*"C"["t"]}*")")))
ip_plot <- rna_plot(rna_data, gene_column = ip_rna, diagnosis_column = diag, x_label = "GROUP", y_label = expression(bold("Immunoproteasome mRNA (2"^{-Delta*Delta*"C"["t"]}*")")))

# WESTERN BLOT ---
wb <- master_data %>%
  select(id, diag, p8_pr, p9_pr, p10_pr, ubi_pr, p5_pr)

# Define color palette
npg_colors = c("#4DBBD5FF","#00A087FF","#E64B35FF","#3C5488FF")

# Define target list
target_list <- list(
  "ubi_pr" = "K48-Ubiquitinated protein (FC)",
  "p5_pr" = "PSMB5 protein (FC)",
  "p8_pr" = "PSMB8 protein (FC)",
  "p9_pr" = "PSMB9 protein (FC)",
  "p10_pr" = "PSMB10 protein (FC)"
)

# Plot function
plot_western <- function(data, target_list) {
  plots <- list()
  
  for (target in names(target_list)) {
    single_plot <- data %>%
      select(id, diag, all_of(target)) %>%
      tidyplot(x = diag, y = .data[[target]], color = diag) %>%
      add_mean_bar(alpha = 0.4) %>%
      add_sem_errorbar() %>%
      add_data_points_beeswarm() %>%
      add_test_asterisks(method = "wilcox.test", ref.group = "HC", label.size = 3) %>%
      adjust_colors(new_colors = npg_colors) %>%
      adjust_x_axis(title = "") %>%
      adjust_y_axis(title = target_list[[target]], limits = c(0, 4.5)) %>%
      adjust_font(family = "Helvetica", font = 4) %>%
      remove_legend() %>%
      remove_caption() +
      theme(
        axis.text.x = element_text(size = 6, face = "bold", color = "#4d4d4d"),
        axis.title.y = element_text(size = 7, face = "bold")
      )
    
    plots[[target]] <- single_plot
  }
  
  design <- "
  AB#
  CDE"
  
  combine_plots <- patchwork::wrap_plots(
    plots,
    design = design,
    nrow = 2
  )
  
  return(combine_plots)
}

# Generate plots
western_blot_plots <- plot_western(wb, target_list = target_list)

# Display the combined plots
print(western_blot_plots)
