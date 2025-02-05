<div align="center">

# **PSMB8 Immunoproteasome activation links α-synuclein pathology and cytotoxic T cell immunity in Parkinson's disease**

</div>

🚀 *Investigating the Role of Immunoproteasome PSMB8 in Synucleinopathies* 

## **🧬 Overview**
Parkinson’s disease (PD) is a neurodegenerative disorder characterized by **α-synuclein accumulation and immune dysregulation.** This repository contains **Jupyter Notebooks (Python) and R scripts** used for analyzing **single-cell RNA sequencing (scRNA-seq), and PBMCs related data** to understand the role of **PSMB8 immunoproteasome** in synucleinopathies.

Our findings highlight:
- **Increased PSMB8 immunoproteasome expression** in **PD, MSA, and RBD**.
- **α-Synuclein pathology links immunoproteasome activation** in multiple experimental models.
- **PSMB8 inhibition reduces α-synuclein accumulation, alters immune responses, and enhances neuronal survival**.

## **📂 Repository structure**
```
📁 Immunoproteasome_PD
 ┣ 📜 Fig.1_PBMC.R                 # R script for PBMC analysis (Demographic, RT-qPCR, Western blot data)
 ┣ 📜 Fig.3_sc-RNAseq.ipynb        # Jupyter Notebook for single-cell RNA-seq
 ┣ 📜 Fig.6_ONX0914-Treatment.R    # R script for ONX-0914 immunoproteasome inhibition
 ┣ 📜 README.md                    # Project documentation
```

## **🔍 Key analyses**
### **🧬 Single-cell RNA sequencing (scRNA-seq)**
- **Dataset:** iPSC-derived dopaminergic neurons (wild-type, rotenone-treated, SNCA-A53T mutant)
- **Preprocessing:** Cell filtering, batch correction using **scVI**, clustering via **Leiden algorithm**
- **Findings:** **PSMB8 significantly upregulated in synucleinopathy models (p < 10<sup>-300</sup>)**

### **🧫 PBMCs and NEVs analysis**
- **Peripheral blood mononuclear cells (PBMCs) from HC, RBD, PD & MSA participants**
- **Neuronal Extracellular vesicles (NEVs) from HC, PD, MSA participants**
- **RT-qPCR & Western blot:** Higher **PSMB8 immunoproteasome level in patient samples**
- **PSMB8 activity:** **Enhanced in NEVs** of patients with PD, MSA 

### **🛠️ PSMB8 Immunoproteasome inhibition with ONX-0914**
- **Treatment:** ONX-0914 (PSMB8 inhibitor) in **Human dopaminergic neurons & PBMCs**
- **Effects:**
  - **Reduced α-synuclein accumulation**
  - **Decreased HLA-I expression & cytotoxic T cells**
  - **Restored neuronal survival & decreased oxidative stress**
  - **Non-proteasomal trypsin-like activity enhances α-synuclein clearance**

## **🎓 Authors**
**Huu Dat Nguyen**<sup>1,2,*</sup>, Hoang Bao Tram Tran<sup>1,2</sup>, Thanh Trung Nguyen<sup>1,2</sup>, In Hee Kwak<sup>2,3</sup>, Han-Joon Kim<sup>4</sup>, Hyeo-il Ma<sup>2,3</sup>, **Young Eun Kim**<sup>2,3,†</sup>

<sup>†</sup>Corresponding author  
<sup>*</sup>First author, Lead contact   

## **🏛️ Affiliations**  
<sup>1</sup> Department of Medical Sciences, Hallym University, Chuncheon, Gangwon, South Korea  
<sup>2</sup> Department of Neurology, Hallym University Sacred Heart Hospital, Hallym University, Anyang, Gyeonggi, South Korea  
<sup>3</sup> Hallym Neurological Institute, Hallym University, Anyang, Gyeonggi, South Korea  
<sup>4</sup> Department of Neurology, Seoul National University Hospital, Seoul, South Korea  

## **📧 Contacts**  
🔗 ****Professor Young Eun Kim, MD. PhD.**** – [![ORCID](https://img.shields.io/badge/ORCID-0000--0002--7182--6569-green)](https://orcid.org/0000-0002-7182-6569) | 📧 [Email](mailto:yekneurology@hallym.or.kr)  
🔗 **Huu Dat Nguyen** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; – [![ORCID](https://img.shields.io/badge/ORCID-0000--0003--2491--5566-green)](https://orcid.org/0000-0003-2491-5566) | 📧 [Email](mailto:datneurosci@gmail.com)

## **⚙️ Dependencies & Installation**
```bash
# Clone the repository
git clone https://github.com/datneuro/Immunoproteasome_PD.git
cd Immunoproteasome_PD
```
### **🌟 Acknowledgment**
We extend our sincere appreciation to all the **patients** who generously participated in this study. Your support and willingness to contribute have been invaluable in advancing our research.

Special thanks to the **Ilsong Institute of Life Science, Hallym University**, for their generous support in **α-synuclein expression experiments**. 

We also express our deep gratitude to **Suk-Jun Song, MSc; Lim Jung Hyun, MSc; and Hye Joung Choi, Ph.D.**, from the **LPDN Lab at Hallym University Sacred Heart Hospital**, and **Thi Len Ho, MSc** at **Jeju National University** for their dedication and technical expertise in documentation and research assistance. Your contributions have been instrumental in the success of this project.

## **📜 Citation**
If you use this repository, please cite our work:

> **PSMB8 Immunoproteasome activation links α-synuclein pathology and cytotoxic T cell immunity in Parkinson’s disease**  
> *Submitted to journal*

📜 **License**: GPL-3.0 License  

---

