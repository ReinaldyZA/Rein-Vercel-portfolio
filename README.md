# Reinaldy Zulfananda Arkaan | Data Analyst Portfolio

**Live site:** [rein-vercel-portfolio.vercel.app](https://rein-vercel-portfolio.vercel.app)

A portfolio of data analysis projects from the RevoU Full Stack Data Analytics program and my undergraduate thesis at BINUS University. Each project opens with the finding, then walks through the business question, the method, the recommendations and the original deliverables.

## Thesis

**JakU: classifying Jakarta's air quality with machine learning**
Compared Random Forest, XGBoost and SVM on official ISPU readings using CRISP-DM, then built a Streamlit dashboard with a User-Centered Design process.
XGBoost reached 97.71% test accuracy and 0.9634 macro F1, caught every Unhealthy day in the test set, and the dashboard scored 78.28 on the System Usability Scale.

[Live app](https://jaku-dashboard5-reinzulfarkaan.streamlit.app/) · [Source code](https://github.com/ReinaldyZA/JAKU5)

## Projects

| Project | Tools | Key finding |
| --- | --- | --- |
| What predicts a bad loan at a retail bank | Python, SQL (DuckDB), Tableau | Two pre-approval screens bring the problematic loan rate from 11.1% to 5.0%. |
| Tracking IDR 14.5 billion of uncollected hospital revenue | Tableau | Self-pay patients are 13% of admissions but hold 30% of pending revenue. |
| Finding which credit card customers can safely spend more | Python, scikit-learn | 38% of cardholders were dormant for six months, and only one dormant group is safe to reactivate. |
| Which grocery categories drive revenue, and why | SQL (BigQuery) | Revenue follows units per customer, not customer count. The top four categories bring in 44%. |
| What drives an e-commerce customer's yearly spending | Spreadsheet, regression | Five behavioural variables explain 92.7% of yearly spending. |
| Evaluating twin-date campaigns and a product page A/B test | Spreadsheet, t-test | The new product page lifted average order value by 11% (p < 0.001). |
| Why Corporate profit fell while sales grew | DARCI, issue tree, OBIPR | Furniture is the only category losing ground, down 56.6%. |

## Skills shown

**SQL:** BigQuery, PostgreSQL, DuckDB, joins, CTEs, window functions
**Python:** pandas, matplotlib, seaborn, scikit-learn, XGBoost, Streamlit
**Spreadsheet:** pivot tables, descriptive statistics, hypothesis testing, regression
**Tableau:** dashboard design, LOD expressions, table calculations
**Business analysis:** DARCI, SMART problem statements, issue trees, OBIPR

## Repository structure

```
index.html        Home page
projects/         One case study page per project
assets/           Stylesheet, scripts and images
files/            Original decks (PDF, PPTX), workbooks, SQL and notebooks
vercel.json       Clean URLs for Vercel
```

Built as a static site with plain HTML, CSS and JavaScript, deployed on Vercel.

## Contact

[LinkedIn](https://www.linkedin.com/in/reinaldy-zulfananda-arkaan-30567a179/) · [GitHub](https://github.com/ReinaldyZA)

*Company names in the RevoU projects are fictional and used for educational purposes.*
