# Transfer Learning Experiment Pipeline

This repository contains an experimental pipeline designed to evaluate whether **transfer learning improves model performance** compared to training **from scratch**, under controlled data budgets.

The pipeline is built around XGBoost classifiers and is structured to ensure **fair, paired comparisons** between scratch and transfer runs.

---

## Overview

The experiment follows three main stages:

1. **Pretraining (source models)**
2. **Baseline evaluation on target data**
3. **Aggregation and visualisation of results**

The core question being tested is:

> **Does initializing a model from a pretrained baseline improve performance when training on a limited amount of new data, compared to training from scratch?**

---

## Conceptual setup

- A **source dataset** is used to pretrain models using only a fraction of available data.
- A **target dataset** is then used for evaluation.
- For each experiment:
  - A **scratch model** is trained only on the target dataset.
  - A **transfer model** is initialized from a pretrained model and further trained on the same target subset.
- Both models are evaluated on the **same holdout split** of the target dataset.

To avoid bias from monotonic trial trends (e.g. data quality changing over time), randomised sampling and splitting are used.

---

## What “dataset” means in results and plots

In result tables and VS plots:

- **`dataset` refers to the test / evaluation dataset**
- It is the dataset on which predictions and metrics are computed
- It does **not** refer to the dataset used for pretraining

Plot encodings:
- **Marker shape** → test / evaluation dataset  
- **Color** → pretraining percentage  
- **x-axis** → scratch performance  
- **y-axis** → transfer performance  

Each point answers:

> *For this evaluation dataset and random seed, does transfer outperform scratch under the same data budget?*

---

## Outputs

### Run summary CSV

All per-run results are written to:

transfer_learning_model_params/baseline/run_summary_across_seeds_and_pretrain_pct.csv


This CSV contains one row per experiment run and includes:
- dataset
- mode (scratch / transfer)
- pretrain percentage
- random seed
- evaluation metrics

Key metrics:
- `holdout_bacc` — balanced accuracy (higher is better)
- `holdout_mae_bins` — MAE in ordinal bin steps (lower is better)
- `holdout_rmse_bins` — RMSE in ordinal bin steps (lower is better)

---

### Pretrained model artifacts

Pretrained models and associated artifacts are stored under:

transfer_learning_model_params/<dataset_tag>/


Each folder typically contains:
- `<tag>_best_model.pkl`
- `<tag>_scaler.pkl`
- `<tag>_feature_cols.pkl`
- `<tag>_bins.npy`
- `<tag>_labels.pkl`

These artifacts are reused during transfer runs.

---

## Pipeline stages

### 1. Pretraining

For each dataset and each chosen percentage:
- A subset of the data is sampled
- The target is discretized into 4 ordered classes (`LL`, `ML`, `MH`, `HH`)
- Features are scaled using `RobustScaler`
- SMOTE is applied only when class counts are sufficient
- An XGBoost classifier is trained
- All artifacts are saved for reuse

> **Note:** Binning strategy must be consistent between pretraining and baseline runs.

---

### 2. Baseline sweep (scratch vs transfer)

For each random seed and each available pretrained artifact:
- A **scratch model** is trained on the target dataset subset
- A **transfer model** continues training from the pretrained booster
- Both models use the same:
  - data split
  - feature set
  - scaling
- Performance is evaluated on the same holdout data

Transfer learning here means **adding trees to an existing XGBoost model**, not neural-network-style weight fine-tuning.

---

### 3. Aggregation and visualisation

Results are aggregated across seeds and pretraining percentages.

VS plots are produced to visualize:
- scratch vs transfer performance
- distribution of outcomes
- how often transfer outperforms scratch

Each VS plot includes:
- a diagonal (transfer = scratch)
- counts of runs where transfer wins vs scratch
- color-coded pretraining percentages
- marker-coded test datasets

---




