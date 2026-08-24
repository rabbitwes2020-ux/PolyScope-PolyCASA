# PolyScope & PolyCASA: Minimal 3D-Printed Microscope for Sperm Motility Analysis

This repository contains the source code, CAD files, and sample datasets for **PolyScope** and **PolyCASA**, as presented in the PhD thesis:
> **Title:** A minimal 3D-printed microscope for analysis of micro-swimmer motility and flagellar movement  
> **Author:** Wesley Zhonghua Shao  
> **Institution:** University of Bristol  

---

## 1. Repository Structure
- `/Hardware_CAD/`: 3D printing files (.STL) for PolyScope optical and mechanical modules.
- `/PolyCASA_Matlab/`: Core algorithms for sperm tracking, trajectory reconstruction, and flagellar kinematics analysis.
- `/Demo_Data/`: Sample video sequence and frames for testing the processing pipeline.

---

## 2. Requirements & Dependencies
- **Software:** MATLAB R2021b or later
- **Required Toolboxes:**
  - Image Processing Toolbox
  - Computer Vision Toolbox
  - Signal Processing Toolbox

---

## 3. Quick Start (MATLAB Demonstration)
1. Clone this repository or download it as a ZIP file.
2. Open MATLAB and set the working directory to `/PolyCASA_Matlab/`.
3. Run `main_demo.m` to execute the automated sperm tracking pipeline on the provided sample video in `/Demo_Data/`.

---

## 4. Open-Source Disclaimer & Future Roadmap
The core algorithms in this repository are implemented in MATLAB for scientific validation and prototyping. 
To further enhance accessibility and open-source compliance, long-term development plans include transitioning these tools into a standalone Python/OpenCV package as part of future work.

---

## 5. Citation & Contact
If you use PolyScope or PolyCASA in your research, please cite the original dissertation:
- **Thesis:** *A minimal 3D-printed microscope for analysis of micro-swimmer motility and flagellar movement* (University of Bristol).
- **Contact:** Wesley Zhonghua Shao
