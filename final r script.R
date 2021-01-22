library("tidyverse")
death_cause_data<-read_csv2('cause_of_death.csv')

library(ggplot2)

library(ggthemes)

# most common death cause
counted_columns<-death_cause_data %>%
  group_by(death_cause) %>%
  count(death_cause)

# other variables 
profession_data_grouped<-group_by(death_cause_data, Occupation)
print(profession_data_grouped)
counted_columns_profession<-count(profession_data_grouped, Occupation)
counted_columns_death_year<-count(profession_data_grouped, Death_Year)
counted_columns_death_place<-count(profession_data_grouped, Death_Place)

# creating a bar graph with top 10 death causes 
top_10_death <-counted_columns %>% ungroup() %>% slice_max(n, n = 10)

plot_1 <- ggplot(top_10_death, aes(x = reorder(death_cause, -n), y = n)) +
  geom_bar(stat='identity', fill = 'orchid4') +
  labs(x = "Cause of Death", y = "Number of Deaths", face = 'bold')
plot_1 + coord_flip() + theme_light() + theme(plot.background = element_rect(fill = 'thistle'))
  
# average age of death over time 
death_age_data <- mutate(death_cause_data, Death_Year = as.numeric(Death_Year)) %>%
  mutate(Birth_Year = as.numeric(Birth_Year)) %>%
  drop_na() %>%
  mutate(death_age = Death_Year - Birth_Year)

filtered_age<-filter(death_age_data, death_age >= 0, death_age <= 150, Death_Year >= 1900, Death_Year <= 2015)

grouped_age<-group_by(filtered_age, Death_Year)
summarise_age<-summarise(grouped_age, age = mean(death_age), n_people = n())

plot_2 <- ggplot(summarise_age, aes(x = Death_Year, y = age)) +
  geom_line(color = 'orchid4') +
  labs(x = "Year", y = "Avaerage Age at Death", face = 'bold')
plot_2 + theme_light() + theme(plot.background = element_rect(fill = 'thistle'))

# myocardial infarction from 2000s
heart_attack_df <- death_cause_data %>% 
  filter(death_cause == 'Myocardial infarction​​​​', Death_Year >= 2000, Death_Year <= 2015) %>%
  group_by(Death_Year) %>% 
  count(death_cause) %>%
  ungroup() %>%
  mutate(Death_Year = as.numeric(Death_Year))

plot_5 <- ggplot(heart_attack_df, aes(x = Death_Year, y = n)) +
  geom_line(color = 'orchid4') +
  labs(x = "Year", y = "Number of Myocardial Infarction Deaths")
plot_5 + theme_light() + theme(plot.background = element_rect(fill = 'thistle'))

# creating a graph for most common deaths of actors 
actors <- death_cause_data %>%
  filter(str_detect(Occupation, fixed('Actor', ignore_case = TRUE))) %>%
  group_by(death_cause) %>%
  count(death_cause) %>%
  ungroup() %>%
  slice_max(n, n = 10)
  
plot_4 <- ggplot(actors, aes(x = reorder(death_cause, -n), y = n)) +
  geom_bar(stat='identity', fill = 'orchid4') +
  labs(x = "Cause of Death", y = "Number of Deaths", face = 'bold')
plot_4 + coord_flip() + theme_light() + theme(plot.background = element_rect(fill = 'thistle')) 
