# Load required libraries
library(readxl)
library(dplyr)
library(stringr)

# Import data

data <- read_excel("C:/Users/Happyy/Downloads/Quantitative Test_Ikaai India.xlsx", sheet = "Data")

# Extract relevant columns
data <- data %>%
  select(
    Aadhar_Benefits = 33,      # Column AG
    Aadhar_Limitations = 34,   # Column AH
    Aadhar_Challenges = 35     # Column AI
  )

# Convert text to lowercase
data <- data %>%
  mutate(across(everything(), ~str_to_lower(as.character(.))))

# Recode Benefits
data <- data %>%
  mutate(Benefit_Code = case_when(
    str_detect(Aadhar_Benefits, "id proof|identity") ~ "B2",
    str_detect(Aadhar_Benefits, "har kaam|any work") ~ "B1",
    str_detect(Aadhar_Benefits, "yojna|scheme|labh") ~ "B3",
    str_detect(Aadhar_Benefits, "bank|khata") ~ "B4",
    str_detect(Aadhar_Benefits, "crime|bhrashtachar|chori") ~ "B5",
    str_detect(Aadhar_Benefits, "subsidy|lpg|gas") ~ "B6",
    str_detect(Aadhar_Benefits, "school|admission|dakhila") ~ "B7",
    TRUE ~ "Other"
  ))

# Recode Limitations
data <- data %>%
  mutate(Limitation_Code = case_when(
    str_detect(Aadhar_Limitations, "none|no|nahi|don't know") ~ "L2",
    str_detect(Aadhar_Limitations, "leak|privacy|detail") ~ "L1",
    str_detect(Aadhar_Limitations, "wine|galat aadmi") ~ "L3",
    str_detect(Aadhar_Limitations, "miss use|kho") ~ "L4",
    TRUE ~ "Other"
  ))

# Recode Challenges
data <- data %>%
  mutate(Challenge_Code = case_when(
    str_detect(Aadhar_Challenges, "bar bar|visit|line") ~ "C1",
    str_detect(Aadhar_Challenges, "kiraye|badalna") ~ "C2",
    str_detect(Aadhar_Challenges, "print|mistake|gadbadi") ~ "C3",
    str_detect(Aadhar_Challenges, "broker|dalal") ~ "C4",
    str_detect(Aadhar_Challenges, "formalit|paper|proof") ~ "C5",
    str_detect(Aadhar_Challenges, "leak|privacy") ~ "C6",
    str_detect(Aadhar_Challenges, "none|no|kuch nhi") ~ "C7",
    TRUE ~ "Other"
  ))

print(data)

# Load required library
library(dplyr)

# Count frequencies for Benefits
benefit_summary <- data %>%
  group_by(Benefit_Code) %>%
  summarise(Frequency = n()) %>%
  mutate(Percentage = round((Frequency / sum(Frequency)) * 100, 2))

# Count frequencies for Limitations
limitation_summary <- data %>%
  group_by(Limitation_Code) %>%
  summarise(Frequency = n()) %>%
  mutate(Percentage = round((Frequency / sum(Frequency)) * 100, 2))

# Count frequencies for Challenges
challenge_summary <- data %>%
  group_by(Challenge_Code) %>%
  summarise(Frequency = n()) %>%
  mutate(Percentage = round((Frequency / sum(Frequency)) * 100, 2))

# Print summaries
print("Aadhar Benefits Summary")
print(benefit_summary)

print("Aadhar Limitations Summary")
print(limitation_summary)

print("Aadhar Challenges Summary")
print(challenge_summary)

library(ggplot2)
library(dplyr)

# Aadhar Benefits Plot
ggplot(benefit_summary, aes(x = reorder(Benefit_Code, -Frequency), y = Frequency, fill = Benefit_Code)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste0(Percentage, "%")), vjust = -0.5) +
  labs(title = "Aadhar Benefits - Coded Response Distribution",
       x = "Benefit Code",
       y = "Frequency of Responses") +
  theme_minimal() +
  theme(legend.position = "none")

# Aadhar Limitations Plot
ggplot(limitation_summary, aes(x = reorder(Limitation_Code, -Frequency), y = Frequency, fill = Limitation_Code)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste0(Percentage, "%")), vjust = -0.5) +
  labs(title = "Aadhar Limitations - Coded Response Distribution",
       x = "Limitation Code",
       y = "Frequency of Responses") +
  theme_minimal() +
  theme(legend.position = "none")

# Aadhar Challenges Plot
ggplot(challenge_summary, aes(x = reorder(Challenge_Code, -Frequency), y = Frequency, fill = Challenge_Code)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = paste0(Percentage, "%")), vjust = -0.5) +
  labs(title = "Aadhar Challenges - Coded Response Distribution",
       x = "Challenge Code",
       y = "Frequency of Responses") +
  theme_minimal() +
  theme(legend.position = "none")

ggsave("benefits_plot.png", width = 8, height = 6)
ggsave("limitations_plot.png", width = 8, height = 6)
ggsave("challenges_plot.png", width = 8, height = 6)
