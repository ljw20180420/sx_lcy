#!/usr/bin/env python

import pandas, seaborn, numpy, more_itertools, matplotlib.pyplot, sys

filename = sys.argv[1]

def pos_base(align_ref, align_seq, cut1, cut2, ref1len):
    align_ref, align_seq = align_ref.rstrip(), align_seq.rstrip()
    pos, poses, shift = 0, [], True
    for base in align_ref:
        if base != '-':
            pos += 1
            if shift and pos == ref1len + 1:
                pos -= ref1len - cut1 + cut2
                shift = False
        poses.append(pos + 0.5 if base == '-' else pos)
    return list(align_ref), list(align_seq), poses

def pos_base_whole(fd, cut1, cut2, ref1len):
    ref_bases, seq_bases, poses = [], [], []
    for _, align_ref, align_seq in more_itertools.batched(fd, 3):
        ref_bases_r, seq_bases_r, poses_r = pos_base(align_ref, align_seq, cut1, cut2, ref1len)
        ref_bases.extend(ref_bases_r)
        seq_bases.extend(seq_bases_r)
        poses.extend(poses_r)
    return pandas.DataFrame({"ref_base": ref_bases, "seq_base": seq_bases, "pos": poses}), sum(numpy.array(list(align_ref.rstrip())) != "-") - (ref1len - cut1) - cut2

fields = filename.split(".")
cut1, cut2, ref1len = int(fields[-3]), int(fields[-2]), int(fields[-1])
with open(filename, "r") as fd:
    base_pos_df, reflen = pos_base_whole(fd, cut1, cut2, ref1len)
    base_pos_df["base_trans"] = [f"{rb}>{sb}" for rb, sb in zip(base_pos_df["ref_base"], base_pos_df["seq_base"])]
    base_pos_df["indelSNP"] = ["insert" if rb == "-" else "delete" if sb == "-" else sb for rb, sb in zip(base_pos_df["ref_base"], base_pos_df["seq_base"])]

    fig, ax = matplotlib.pyplot.subplots()
    seaborn.histplot(data = base_pos_df[(base_pos_df["ref_base"] != base_pos_df["seq_base"]) & (base_pos_df["seq_base"] != '-')], x = "base_trans", multiple = "stack", discrete = True, ax = ax)
    ax.tick_params(axis='x', rotation=30)
    fig.tight_layout()
    fig.savefig(f"{filename}.base_trans.histplot.pdf")

    fig, ax = matplotlib.pyplot.subplots()
    histdata = [base_pos_df[base_pos_df["indelSNP"] == idS]["pos"] for idS in ["A", "C", "G", "T", "delete"]]
    ax.hist(histdata, bins = list(numpy.arange(0.5, 0.5 + reflen + 1)), stacked = True, label = ["A", "C", "G", "T", "delete"], color = ["green", "blue", "yellow", "red", "grey"])
    ax.hist(base_pos_df[base_pos_df["indelSNP"] == "insert"]["pos"], bins = list(numpy.arange(0, reflen + 2)), label = "insert", histtype = "step", color = "black")
    ylim = ax.get_ylim()
    ax.plot([cut1 + 0.5, cut1 + 0.5], list(ylim), ls = "--", c = "black", label='cut')
    ax.plot([cut1 + 3.5, cut1 + 3.5], list(ylim), [cut1 - 16.5, cut1 - 16.5], list(ylim), ls = "--", c = "grey", label='sgRNA')
    ax.set_ylim(ylim)
    handles, labels = ax.get_legend_handles_labels()
    ax.legend(handles[:-1], labels[:-1])
    fig.tight_layout()
    fig.savefig(f"{filename}.indelSNP.histplot.pdf")

tablename = filename.replace(".alg.", ".table.")
indel_df = pandas.read_csv(tablename, sep = '\t')
indel_counts = indel_df["indel_type"].value_counts()
fig, ax = matplotlib.pyplot.subplots()
ax.pie(indel_counts.values, labels=[f"{lb}: {val}" for lb, val in zip(indel_counts.index, indel_counts.values)], autopct='%.1f%%')
fig.tight_layout()
fig.savefig(f"{filename}.indel_type.pieplot.pdf")
