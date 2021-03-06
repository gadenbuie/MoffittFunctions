% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pretty_output_functions.R
\name{pretty_model_output}
\alias{pretty_model_output}
\title{Fancy Table Output of Linear, Logistic, and Cox Models}
\usage{
pretty_model_output(fit, model_data, overall_p_test_stat = c("Wald",
  "LR"), title_name = NULL, conf_level = 0.95, est_digits = 3,
  p_digits = 4, output_type = NULL, sig_alpha = 0.05,
  background = "yellow", ...)
}
\arguments{
\item{fit}{lm, glm, or coxph fit (currently only tested on logistic glm fit)}

\item{model_data}{data.frame or tibble  used to create model fits. Used for capturing variable labels, if they exist}

\item{overall_p_test_stat}{"Wald" (default) or "LR"; the test.statistic to pass through to the test.statistic param in car::Anova. Ignored for lm fits.}

\item{title_name}{title to use (will be repeated in first column)}

\item{conf_level}{the confidence level required (default is 0.95).}

\item{est_digits}{number of digits to round OR or HR to (default is 3)}

\item{p_digits}{number of digits to round p values (default is 4)}

\item{output_type}{output type, either NULL (default), "latex", or "html" (making special charaters latex friendly)}

\item{sig_alpha}{the defined significance level for highlighting. Default = 0.05 (Only used if output_type is not NULL)}

\item{background}{background color of significant values, or no highlighting if NULL. Default is "yellow" (Only used if output_type is not NULL)}

\item{...}{other params to pass to \code{pretty_pvalues} (i.e. \code{bold} or \code{italic}) (Only used if output_type is not NULL)}
}
\value{
A tibble with: \code{Name} (if provided), \code{Variable}, \code{Level}, \code{Est/OR/HR (95\% CI)}, \code{P Value} (for categorical variables comparing to reference), \code{Overall P Value} (for categorical variables with 3+ levels).
}
\description{
pretty_model_output() takes a Linear, Logistic, and Cox model fit object and calculate estimates, odds ratios, or hazard ratios, respectively, with confidence intervals. P values are also produced. For categorical variables with 3+ levels overall Type 3 p values are calculated, in addition to p values comparing to the first level (reference).
}
\details{
Model type is determined by \code{fit} class, and also family if glm class. If the class is glm and  binomial or quasibinomial family, then the output is designed for a Logistic model (i.e. Odd Ratios), if the class is coxph the output is designed for a Cox model (i.e. Harzard Ratios), otherwise the output is designed for a linear model or other model where normal coefficient estimates are displayed.
}
\examples{

# Basic linear model example
set.seed(542542522)
ybin <- sample(0:1, 100, replace = TRUE)
y <- rexp(100,.1)
x1 <- rnorm(100)
x2 <- y + rnorm(100)
x3 <- factor(sample(letters[1:4],100,replace = TRUE))
my_data <- data.frame(y, ybin, x1, x2, x3)

# Linear Regression
my_fit <- lm(y ~ x1 + x2 + x3, data = my_data)
pretty_model_output(fit = my_fit, model_data = my_data)

# Logistic Regression
my_fit <- glm(ybin ~ x1 + x2 + x3, data = my_data, family = binomial(link = "logit"))
pretty_model_output(fit = my_fit, model_data = my_data)

# Coxph Regression
my_fit <- survival::coxph(survival::Surv(y, ybin) ~ x1 + x2 + x3, data = my_data)
my_pretty_model_output <- pretty_model_output(fit = my_fit, model_data = my_data)

# Printing of Fancy table in HTML
library(dplyr)
kableExtra::kable(my_pretty_model_output, 'html', caption = 'My Table') \%>\% 
   kableExtra::collapse_rows(c(1:2), row_group_label_position = 'stack')
  
# Real World Examples
data(Bladder_Cancer)
surv_obj <- survival::Surv(Bladder_Cancer$Survival_Months, Bladder_Cancer$Vital_Status == 'Dead')  
my_fit <- survival::coxph(surv_obj ~ Gender + Clinical_Stage_Grouped + PT0N0, data = Bladder_Cancer)
my_output <- pretty_model_output(fit = my_fit, model_data = Bladder_Cancer)
kableExtra::kable(my_output, 'html') \%>\% 
    kableExtra::collapse_rows(c(1:2), row_group_label_position = 'stack')
  
}
