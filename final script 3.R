library(tidyverse)
library(ggthemes)
library(readr)

cause_of_death_world_orig <- read_csv("cause_of_death_world.csv")
View(cause_of_death_world_orig)
cause_of_death_world = subset(cause_of_death_world_orig, select = -c(1, 3, 4, 5, 7, 10, 11))
colnames(cause_of_death_world)[1] <- "Death_cause"

death_cause_data_grouped <- group_by(cause_of_death_world, Death_cause)
print(death_cause_data_grouped)
counted_columns <- summarise(death_cause_data_grouped, total=sum(Value))
filtered_counted_columns <- filter(counted_columns, Death_cause != "All causes of death")

top_10 <- filtered_counted_columns %>%
  ungroup() %>%
  slice_max(total, n=10)

plot <- ggplot(top_10, aes(x = reorder(Death_cause, -total), y = total)) +
  geom_bar(stat='identity', fill = 'orchid4') +
  labs(x = "Cause of Death", y = "Number of Deaths", face = 'bold')
plot + coord_flip() + theme_light() + theme(plot.background = element_rect(fill = 'thistle'))

filtered_myocardial <- filter(cause_of_death_world, Death_cause == "Acute myocardial infarction", Year >= 2000, Year <= 2015)
average_year <- filtered_myocardial %>%
  group_by(Year)%>%
  summarise(average_acute_myocardial_infarction = mean(Value))

plot_2 <- ggplot(average_year, aes(x = Year, y = average_acute_myocardial_infarction)) +
  geom_line(color = 'orchid4') +
  labs(x = "Year", y = "Number of Myocardial Infarction")
plot_2 + theme_light() + theme(plot.background = element_rect(fill = 'thistle'))

