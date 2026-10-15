# Flight Delay & Performance Analysis ✈️

**An end-to-end aviation data analytics project using the 2015 U.S. Flight Delays and Cancellations dataset.**

## Project Overview

Flight delays and cancellations affect passenger experience, airline operations, and airport efficiency. This project investigates **which airlines and airports experience the most delays**, how performance varies over time, and what patterns may help improve operational decisions.

The source dataset contains **5,819,079 flight records from 2015**. The analysis uses flight-level data alongside airline and airport reference tables.

## Business Problem

**Which airlines and airports have the highest flight delays, and how does on-time performance vary across carriers, locations, and time periods?**

### Key Business Questions

- Which airlines have the highest arrival-delay rates and average delays?
- Which origin airports have the most departure delays?
- Which destination airports have the most arrival delays?
- How do flight delays vary by month and day of the week?
- What proportion of scheduled flights are cancelled or diverted?
- What reported delay causes contribute the most minutes?

## Dataset

**Source:** [2015 Flight Delays and Cancellations — Kaggle (U.S. Department of Transportation)](https://www.kaggle.com/datasets/usdot/flight-delays)

| Source file | Purpose |
| --- | --- |
| `flights.csv` | Flight dates, routes, departure/arrival delays, cancellations, diversions, and reported delay causes |
| `airlines.csv` | Airline codes and names |
| `airports.csv` | Airport codes, names, and locations |

The underlying flight data originates from the **U.S. Department of Transportation, Bureau of Transportation Statistics**.

## Tools & Technologies

- **Python (Pandas):** Large-file processing, validation, and data preparation.
- **Microsoft Excel:** Data-quality review, summary tables, and pivot-based exploration of manageable extracts.
- **SQL (PostgreSQL):** Relational analysis, aggregation, and airline/airport comparisons.
- **Power BI:** Interactive KPI reporting and visual exploration.

> The technologies above describe the intended end-to-end workflow. Only include code files, Excel workbooks, SQL queries, and dashboards in this repository once those deliverables are complete.

## Data Cleaning & Validation

The initial data audit reconciled all **5,819,079 source flight rows**:

| Flight status | Records |
| --- | ---: |
| Neither cancelled nor diverted | 5,714,008 |
| Cancelled | 89,884 |
| Diverted | 15,187 |
| **Total** | **5,819,079** |

Important analysis rules:

- **Do not treat missing arrival delays as zero.** Cancelled and diverted flights have different reporting semantics from completed flights.
- Exclude cancelled/diverted flights and null delay values when calculating arrival-delay performance for completed flights.
- Analyze cancellation and diversion rates separately using all scheduled flights as the denominator.
- Keep **departure-delay analysis tied to the origin airport** and **arrival-delay analysis tied to the destination airport**.
- Treat delay-cause fields as reported information, not as complete measurements for every flight.
- Check flight counts alongside rates so low-volume carriers or airports do not dominate rankings misleadingly.

## KPI Definitions

| KPI | Definition |
| --- | --- |
| Arrival delay rate (15+ min) | Completed, non-diverted flights arriving at least 15 minutes late ÷ completed, non-diverted flights with a known arrival delay |
| Average arrival delay | Mean `ARRIVAL_DELAY` (minutes) for completed, non-diverted flights with a known arrival delay; early arrivals have negative values |
| Average departure delay | Mean `DEPARTURE_DELAY` (minutes) for non-cancelled flights with a known departure delay |
| Cancellation rate | Cancelled flights ÷ all scheduled flights |
| Diversion rate | Diverted flights ÷ all scheduled flights |
| Flight volume | Count of relevant flight records in each airline, airport, or time-period group |

## Analytics Workflow

1. **Ingest:** Load `flights.csv`, `airlines.csv`, and `airports.csv`.
2. **Validate:** Reconcile row counts, check missing values, and inspect cancellation/diversion flags.
3. **Prepare:** Create clean analysis-ready fields and airline/airport lookups without silently dropping valid source records.
4. **Analyze:** Compare airline and airport performance using rates, average delay minutes, and sample sizes.
5. **Report:** Build Excel summaries, SQL analyses, and Power BI visuals from consistent KPI definitions.
6. **Communicate:** Translate verified findings into operational insights and recommendations.

## Dashboard Scope

The Power BI report is designed to include overall flight volume, arrival-delay rate, average delay, cancellation/diversion rates, airline comparisons, airport comparisons, and monthly trends. Dashboard screenshots and measured findings will be added after the report is validated.

## Project Status

- **Completed:** Source-data audit and row-count reconciliation.
- **To document/publish:** Final cleaned extracts, Excel analysis, SQL queries, Power BI dashboard, and verified airline/airport rankings.

**No airline or airport is labelled “worst” here until its ranking is calculated and checked against the chosen denominator and flight-volume threshold.**

## Reproducing the Analysis

1. Download the three CSV files from the [Kaggle dataset](https://www.kaggle.com/datasets/usdot/flight-delays).
2. Keep the raw source files in a local `data/raw/` folder.
3. Run the project's data preparation and validation scripts when available.
4. Use the resulting analysis-ready extracts for SQL, Excel, and Power BI.

**Note:** The full source data is large, so the GitHub repository can contain scripts, summary outputs, and documentation rather than the full raw `flights.csv`.

## Data Source & Attribution

- Dataset: [2015 Flight Delays and Cancellations (Kaggle)](https://www.kaggle.com/datasets/usdot/flight-delays)
- Original publisher: U.S. Department of Transportation — Bureau of Transportation Statistics.

---

*Project focus: descriptive and diagnostic data analytics, not flight-delay prediction.*
