##Clinical Trial Simulator

##Description
The Clinical Trial Simulator is a Shiny web application that enables users to simulate and visualize sample size requirements and statistical power for clinical trials. It supports two trial designs: Parallel and Crossover, and provides insights into the relationships between trial parameters such as effect size, standard deviation, significance level, and power.

##Features
Trial Design Options: Choose between Parallel and Crossover designs.
Customizable Inputs:
Effect Size (difference between groups)
Standard Deviation
Significance Level (α)
Statistical Power (1 - β)
Sample Size (per group)
Simulation Results:
Required sample size per group for the specified parameters.
Power curve visualization for varying effect sizes.
Interactive Visualization: Graphical power curve to explore power dynamics.

##Installation
To run the app locally, ensure you have R and the following packages installed:

shiny
shinythemes
ggplot2
dplyr
pwr

##You can install these packages using:

install.packages(c("shiny", "shinythemes", "ggplot2", "dplyr", "pwr"))

##Usage
Clone or download this repository.
Run the following commands in R to start the app:

library(shiny)
runApp("path/to/clinical_trial_simulator.R")
Adjust the trial design parameters in the sidebar panel and click Simulate to view the results.
How It Works
Trial Design Selection:
Parallel Design assumes independent samples and between-group comparisons.
Crossover Design assumes within-subject comparisons with considerations for treatment period and carryover effects.
Simulation:
Computes the required sample size using the pwr.t.test function.
Plots a power curve showing statistical power across varying effect sizes.
Power Calculation:
Parallel: Based on two independent samples.
Crossover: Accounts for paired data structure.
Files
clinical_trial_simulator.R: Main app script.
README.md: Documentation for the app.
Example
Launch the app, set:

Effect Size: 0.5
Standard Deviation: 1
Significance Level: 0.05
Power: 0.8
Simulate and observe the required sample size per group and the corresponding power curve.

@@License
This project is open-source and available under the MIT License.


##Contributions
Feel free to contribute enhancements or report bugs by submitting an issue or pull request.
