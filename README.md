# Transfer learning in the application of predicting influent COD on continuous mec-AD reactor

# Domain-Variant Transfer Learning for Influent COD Soft Sensing (MEC-AD)

Code and notebooks to reproduce the experiments from:

> **Domain-Variant Transfer Learning for Influent Organic Load Monitoring Using an XGBoost Soft Sensor in MEC-Assisted Anaerobic Digestion**  
> H. C. Rutland, J. You, H. Liu, W. Gambier, 2025.

This repository implements a soft sensor for **influent COD** using only standard online signals (e.g., influent/reactor pH, feed & biogas volumes, module current, temperature, methane %, HRT). It evaluates **transfer learning** (warm-start / leaf-revision with XGBoost) between two pilot MEC-AD sites and compares against a **cold-start target-only baseline**. Outputs are discretised into **four operational COD bands** for early-warning control.

---

## What’s here

- `warm_start_transfer_model_training.ipynb` — **Transfer learning** workflow (source-initialized XGBoost, frozen topology with leaf-only adaptation) using the first ~40% of the target site for calibration, evaluating on the remaining ~60%.
- `cold_start_baseline_model_training.ipynb` — **Baseline**: target-only model under the same target-data budget.
- `data_inpection.ipynb` — Basic **data sanity checks/EDA**.
- `requirements.txt` — Python dependencies.

> **Status:** This repo currently provides **Jupyter notebooks** (no CLI). Run them top-to-bottom to reproduce the paper’s figures/tables.

---

## Dataset

The paper uses two ~130–140 day pilot datasets (Brewery and Food/MEC-AD trials). The public release is available at:

- **IEEE DataPort:** `10.21227/r6vm-2n37`

> Download the dataset locally and place it under `./data/` (or edit the first notebook cell where the data path is defined).

**Expected columns** (per paper): online signals such as influent pH, reactor pH, feed volume, biogas volume, module current, reactor temperature, methane %, HRT; daily offline **COD** labels used for training/evaluation. The notebooks bin the continuous COD into four bands (LL/ML/MH/HH) to align with alarm practice.

---

## Environment & setup

```bash
# 1) Create and activate a fresh environment (example uses conda)
conda create -n mecad-cod python=3.10 -y
conda activate mecad-cod

# 2) Install dependencies
pip install -r requirements.txt

# 3) Start Jupyter and open the notebooks
jupyter lab  # or: jupyter notebook
# transfer_learning_influent_COD_mecAD_injection_variation
