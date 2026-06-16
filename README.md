# Next Generation of Policy Frameworks and Modeling

**June 8–19, 2026 · Chulalongkorn University · Bangkok, Thailand**

This repository contains the lecture slides, Dynare/Julia model files, and supporting
material for the two-week course on next-generation monetary policy frameworks and
modeling.

---

## How to use this repository

- Browse the **sessions** below. Each session links to its own folder.
- To **download a single file**, click its link, then use the **Download** (raw) button
  on the file's GitHub page.
- To **download everything at once**, click the green **`Code`** button at the top of the
  repository and choose **Download ZIP**.

---

## Course schedule and sessions

### Week 1 — FPAS Mark II (June 8–12)

Lecture slides introducing the Forecasting and Policy Analysis System (FPAS Mark II),
quarterly projection models, and the Dynare/Julia toolchain.

📁 [FPAS Mark II - Week 1](FPAS%20Mark%20II%20-%20Week%201)

| Topic | Slides (PDF) | Slides (PPTX) |
| --- | --- | --- |
| FPAS overview — Dynare & Julia | [PDF](FPAS%20Mark%20II%20-%20Week%201/Week1_DynareJulia_FPAS.pdf) | [PPTX](FPAS%20Mark%20II%20-%20Week%201/Week1_DynareJulia_FPAS.pptx) |
| Day 2 — Framework | [PDF](FPAS%20Mark%20II%20-%20Week%201/Day2_Framework.pdf) | [PPTX](FPAS%20Mark%20II%20-%20Week%201/Day2_Framework.pptx) |
| Day 3 — QPMs | [PDF](FPAS%20Mark%20II%20-%20Week%201/Day3_QPMs.pdf) | [PPTX](FPAS%20Mark%20II%20-%20Week%201/Day3_QPMs.pptx) |
| Day 4 — Dynare & Julia | [PDF](FPAS%20Mark%20II%20-%20Week%201/Day4_DynareJulia.pdf) | [PPTX](FPAS%20Mark%20II%20-%20Week%201/Day4_DynareJulia.pptx) |
| Day 5 — Capstone | [PDF](FPAS%20Mark%20II%20-%20Week%201/Day5_Capstone.pdf) | [PPTX](FPAS%20Mark%20II%20-%20Week%201/Day5_Capstone.pptx) |

### Week 2 — FPAS Mark II (June 15–19)

Lecture slides covering current conditions assessment, market reference forecasts, risk
taxonomy, policy trade-offs, and monetary policy report communication.

📁 [FPAS Mark II - Week 2](FPAS%20Mark%20II%20-%20Week%202)

| Topic | Slides (PDF) | Slides (PPTX) |
| --- | --- | --- |
| Day 1 — Current Conditions | [PDF](FPAS%20Mark%20II%20-%20Week%202/Week2_Day1_CurrentConditions.pdf) | [PPTX](FPAS%20Mark%20II%20-%20Week%202/Week2_Day1_CurrentConditions.pptx) |
| Day 2 — Market Reference (Case A/B) | [PDF](FPAS%20Mark%20II%20-%20Week%202/Week2_Day2_MarketReference_CaseAB.pdf) | [PPTX](FPAS%20Mark%20II%20-%20Week%202/Week2_Day2_MarketReference_CaseAB.pptx) |
| Day 3 — Taxonomy of Risks | [PDF](FPAS%20Mark%20II%20-%20Week%202/Week2_Day3_Taxonomy_Risks.pdf) | [PPTX](FPAS%20Mark%20II%20-%20Week%202/Week2_Day3_Taxonomy_Risks.pptx) |
| Day 4 — Trade-offs (Dynare & Julia) | [PDF](FPAS%20Mark%20II%20-%20Week%202/Week2_Day4_Tradeoffs_DynareJulia.pdf) | [PPTX](FPAS%20Mark%20II%20-%20Week%202/Week2_Day4_Tradeoffs_DynareJulia.pptx) |
| Day 5 — MPR & Communication | [PDF](FPAS%20Mark%20II%20-%20Week%202/Week2_Day5_MPR_Communication.pdf) | [PPTX](FPAS%20Mark%20II%20-%20Week%202/Week2_Day5_MPR_Communication.pptx) |
| NTSPI Methodology | [PDF](FPAS%20Mark%20II%20-%20Week%202/NTSPI_Methodology_1.pdf) | [PPTX](FPAS%20Mark%20II%20-%20Week%202/NTSPI_Methodology_1.pptx) |
| Risk-Adjusted UIP | [PDF](FPAS%20Mark%20II%20-%20Week%202/Risk-Adjusted%20UIP.pdf) | [PPTX](FPAS%20Mark%20II%20-%20Week%202/Risk-Adjusted%20UIP.pptx) |
| Open ENDOCRED — Armenia | [PDF](FPAS%20Mark%20II%20-%20Week%202/Open_ENDOCRED_Armenia_1.pdf) | [PPTX](FPAS%20Mark%20II%20-%20Week%202/Open_ENDOCRED_Armenia_1.pptx) |

---

## Hands-on model files

Dynare model files (`.mod`), Julia scripts (`.jl`), MATLAB simulation sheets (`.m`), and
solver logs (`.log`) used in the lab sessions. Open `.mod` files with **Dynare** and
`.jl` files with **Julia**.

### Simple ENDOCRED

A minimal closed-economy model with endogenous credibility.

📁 [Simple Endocred](Simple%20Endocred)

| File | Description |
| --- | --- |
| [simple_linear.mod](Simple%20Endocred/simple_linear.mod) | Linear endogenous-credibility model (Dynare) |
| [simple_linear.jl](Simple%20Endocred/simple_linear.jl) | Julia version of the linear model |

### Linear ENDOCRED

Linear and non-linear closed-economy ENDOCRED models, market reference variants, and
Case A/B exercises.

📁 [Linear_ENDOCRED](Linear_ENDOCRED)

| File | Description |
| --- | --- |
| [simple_linear.mod](Linear_ENDOCRED/simple_linear.mod) · [log](Linear_ENDOCRED/simple_linear.log) | Linear ENDOCRED model |
| [simple_linear_endog.mod](Linear_ENDOCRED/simple_linear_endog.mod) · [log](Linear_ENDOCRED/simple_linear_endog.log) | Linear model with endogenous credibility |
| [simple_ENDOCRED.mod](Linear_ENDOCRED/simple_ENDOCRED.mod) · [log](Linear_ENDOCRED/simple_ENDOCRED.log) | Baseline simple ENDOCRED model |
| [endocred_nonlinear_v1.mod](Linear_ENDOCRED/endocred_nonlinear_v1.mod) · [log](Linear_ENDOCRED/endocred_nonlinear_v1.log) | Non-linear ENDOCRED model (v1) |
| [Market_Reference.mod](Linear_ENDOCRED/Market_Reference.mod) · [log](Linear_ENDOCRED/Market_Reference.log) | Market reference forecast |
| [Market_Reference_v1.mod](Linear_ENDOCRED/Market_Reference_v1.mod) · [log](Linear_ENDOCRED/Market_Reference_v1.log) | Market reference (v1) |
| [Market_Reference_v2.mod](Linear_ENDOCRED/Market_Reference_v2.mod) · [log](Linear_ENDOCRED/Market_Reference_v2.log) | Market reference (v2) |
| [Case_A_v1.mod](Linear_ENDOCRED/Case_A_v1.mod) · [log](Linear_ENDOCRED/Case_A_v1.log) | Case A exercise (v1) |
| [Case_B_v1.mod](Linear_ENDOCRED/Case_B_v1.mod) · [log](Linear_ENDOCRED/Case_B_v1.log) | Case B exercise (v1) |
| [simulation_sheet.m](Linear_ENDOCRED/simulation_sheet.m) | MATLAB simulation sheet |

### Open Economy ENDOCRED

Open-economy extension of the ENDOCRED model.

📁 [Open_Economy_Endocred](Open_Economy_Endocred)

| File | Description |
| --- | --- |
| [Endocred_Open_Test_v2.mod](Open_Economy_Endocred/Endocred_Open_Test_v2.mod) | Open-economy ENDOCRED model (test v2) |
| [simulation_sheet.m](Open_Economy_Endocred/simulation_sheet.m) | MATLAB simulation sheet |

### DSGE — Week 2

📁 [DSGE - Week 2](DSGE%20-%20Week%202) — *materials to be added.*

---

*The Better Policy Project*
