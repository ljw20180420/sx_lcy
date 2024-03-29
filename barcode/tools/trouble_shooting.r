#!/usr/bin/env Rscript

library(tidyverse)
library(ggseqlogo)
library(this.path)

#######################################################
# Usage: trouble_shooting.r fqR1 score_thres(default: -Inf)
#######################################################
args <- commandArgs(trailingOnly = TRUE)
fqR1 <- args[1]
score_thres <- -Inf
if (length(args) > 1) {
  score_thres <- as.double(args[2])
}

# load table
idtable <- read_tsv(pipe(sprintf("cut -f8 %s.demultiplex | sed '1i sgRNA' | paste %s.table -", fqR1, fqR1)), col_types = "ciiiciiiiciiiiciic")

# all insertions
idtable |>
  filter(score >= score_thres) |> # filter score larger than score_thres
  mutate(m6 = factor(substring(sgRNA, 15, 15), levels = c("A", "T", "C", "G"))) |>
  mutate(m5 = factor(substring(sgRNA, 16, 16), levels = c("A", "T", "C", "G"))) |>
  mutate(m4 = factor(substring(sgRNA, 17, 17), levels = c("A", "T", "C", "G"))) |>
  mutate(m3 = factor(substring(sgRNA, 18, 18), levels = c("A", "T", "C", "G"))) |>
  mutate(m2 = factor(substring(sgRNA, 19, 19), levels = c("A", "T", "C", "G"))) |>
  mutate(m1 = factor(substring(sgRNA, 20, 20), levels = c("A", "T", "C", "G"))) |>
  mutate(insertion = factor(ref_end1 > cut1 | !is.na(random_insertion) | ref_start2 < cut2, levels = c(FALSE, TRUE), labels = c("not_insertion", "insertion"))) |>
  mutate(templated = factor(ref_end1 > cut1 | ref_start2 < cut2, levels = c(FALSE, TRUE), labels = c("not_templated", "templated"))) |>
  pivot_longer(cols = c(m1, m2, m3, m4, m5, m6), names_to = "pos", values_to = "base") ->
  long_idtable

## insertion
# write tsv
long_idtable |>
  summarise(count = sum(count), .by = c(pos, base, insertion)) |>
  arrange(pos, base, insertion) |>
  write_tsv(sprintf("%s.insertion.tsv", fqR1))
# draw figure
long_idtable |>
  ggplot(aes(base, fill = insertion, weight = count)) +
  facet_wrap(~ pos) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent, expand = c(0,0)) -> ggfig
ggsave(sprintf("%s.insertion.png", basename(fqR1)), path = dirname(fqR1), width = 22, height = 12)

## templated
# write tsv
long_idtable |>
  summarise(count = sum(count), .by = c(pos, base, templated)) |>
  arrange(pos, base, templated) |>
  write_tsv(sprintf("%s.templated.tsv", fqR1))
# draw figure
long_idtable |>
  ggplot(aes(base, fill = templated, weight = count)) +
  facet_wrap(~ pos) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = scales::percent, , expand = c(0,0)) -> ggfig
ggsave(sprintf("%s.templated.png", basename(fqR1)), path = dirname(fqR1), width = 22, height = 12)

