# GitHub repository of the Master Thesis: Comparing Size Discrimination in Visuomotor and Perceptual Judgements
**Eberhard-Karls Universität Tübingen**

**Author:** Tanja Huber 

**Date:** 11.07.2025

## Repository Structure
### Lab Code
The MATLAB code for the experiment conduction is provided in `\os2401` and `\os2501` for the pilot study and main study, respectively. However, this code is only functional in a laboritory with the required apparatus. 

### Analysis Code
Analysis was conducted in R. The `main.R` file runs all functionalities. 

- [`data/`](data): holds the data collected from participants and the answers to the questionnaire.
- [`plots/`](plots): stores all created figures.
- [`txt/`](txt): stores the main statistical result tables.
- [`src/`](src): includes relevant variables in `variables.R` and all functions, split into `run_` files including smaller functions from `fun_` files and `utils.R`.

## Abbreviations
Both in the code and figures, several abbreviations are used. 
"seminar" and "pilot" both refer to the same data, as the pilot study was collected from a seminar. "main" refers to the main study of the thesis.
The conducted tasks are abbreviated as follows:
- Grasping Task: Grasp, G
- Manual Estimation Task: ManEst, M
- Perceptual Judgement Task: Perc, P
- Perceptual Control Task: Control, C, Experc

"SL" refers to the difference between average large - small target disc apertures.
Other abbreviations are explained in comments in the code as required.

