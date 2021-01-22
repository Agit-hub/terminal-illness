library("tidyverse")
library(ggplot2)
library(ggthemes)

#make values in table numeric
death_cause_data<-read_csv2('cause_of_death.csv')%>%
  mutate(Death_Year=as.numeric(Death_Year))%>%
  mutate(Birth_Year=as.numeric(Birth_Year))%>%
  drop_na()%>%
  mutate(death_age=Death_Year-Birth_Year)

# top 5 death causes: cumulative
death_cause_5=c('Myocardial infarction','Cancer','Pneumonia','Lung cancer','Stroke')
death_cause_data_grouped<-group_by(death_cause_data, death_cause)%>%
  mutate(decade=floor(Death_Year/10), death_cause=str_remove_all(death_cause,'​'))%>%
  group_by(death_cause, decade)%>%
  summarise(counted_deaths=n())%>%
  mutate(cumulative_deaths=cumsum(counted_deaths))%>%
  filter(!str_detect(death_cause, '\\['))%>%
  #filter(any(str_detect(death_cause, death_cause_5)))%>%
  filter(death_cause%in%death_cause_5)%>%
  mutate(decade=(decade*10))%>%
  filter(decade>=1800)

plot_1<-ggplot(death_cause_data_grouped)+
  aes(x = decade, y = cumulative_deaths, color=death_cause, fill=death_cause)+
  geom_line()+
  labs(title="Cumulative Number of Deaths From 1800", subtitle="For the Top 5 Causes of Death")+
  labs(x="Year", y="Number of Deaths", face='bold')+
  labs(color="Death Cause")
plot_1 + theme_light() + theme(plot.background = element_rect(fill = 'thistle'))
#ggsave('cumulative_deaths.pdf')

# top 5 death causes - by decade
death_cause_5=c('Myocardial infarction','Cancer','Pneumonia','Lung cancer','Stroke')
death_cause_data_grouped<-group_by(death_cause_data, death_cause)%>%
  mutate(decade=floor(Death_Year/10), death_cause=str_remove_all(death_cause,'​'))%>%
  group_by(death_cause, decade)%>%
  summarise(counted_deaths=n())%>%
  filter(!str_detect(death_cause, '\\['))%>%
  #filter(any(str_detect(death_cause, death_cause_5)))%>%
  filter(death_cause%in%death_cause_5)%>%
  mutate(decade=(decade*10))%>%
  filter(decade>=1800)

plot_7<-ggplot(death_cause_data_grouped)+
  aes(x = decade, y = counted_deaths, color=death_cause, fill=death_cause)+
  geom_line()+
  #labs(title="Number of Deaths Per Decade From 1800", subtitle="For the Top 5 Causes of Death")+
  labs(x="Decade", y="Number of Deaths per Decade", face='bold')+
  labs(color="Death Cause")
plot_7 + theme_light() + theme(plot.background = element_rect(fill = 'thistle'))
#ggsave('total_deaths.pdf')

# average age at death, according to birth year, over time
death_cause_data_age<-mutate(death_cause_data, death_age = Death_Year - Birth_Year)%>%
  filter(death_age >= 0, death_age <= 150, Birth_Year >= 1400, Birth_Year <= 2000)%>%
  mutate(decade_of_birth=floor(Birth_Year/10))%>%
  group_by(decade_of_birth)%>%
  mutate(decade_of_birth=(decade_of_birth*10))%>%
  summarise(age = mean(death_age), n_people = n())

plot_2 <- ggplot(death_cause_data_age, aes(x=decade_of_birth, y=age))+
  geom_line(color='orchid4') +
  labs(x ="Decade of Birth", y="Average Age at Death", face='bold')+
  scale_x_continuous(breaks=seq(1400, 2000, by = 50))+
  labs(title="Average Lifespan", subtitle="By Decade of Birth")
plot_2+theme_light()+theme(plot.background=element_rect(fill='thistle'))
#ggsave('avg_wiki_lifepan.pdf')

# average life expectancy at year of birth, over time
life_expectancy_data<-read_csv('life-expectancy.csv')%>%
  filter(Entity=='World')%>%
  mutate(decade=floor(Year/10))%>%
  group_by(decade)%>%
  mutate(decade=decade*10)%>%
  summarise(avg=mean(Life_expectancy))

plot_3 <- ggplot(life_expectancy_data,
                 aes(x=decade, y=avg))+
                 geom_line()
plot_3 + theme_light() + theme(plot.background = element_rect(fill = 'thistle'))

# plot avg wiki age at death and life expectancy at given birth year
plot_4 <- ggplot() + 
  geom_line(data=life_expectancy_data, aes(x=decade, y = avg, color='life expectancy')) + 
  geom_line(data=death_cause_data_age, aes(x=decade_of_birth, y=age, color='life span')) +
  scale_x_continuous(breaks=seq(1400, 2000, by = 100))+
  labs(x ="Decade of Birth", y="Age", face='bold') +
  labs(title="Global Life Expectancy vs Average Lifespan", subtitle="- Life expectancy is worldwide average from Our World in Data
       - Average lifespan is from Wikipedia dataset") +
  theme_light() + theme(plot.background = element_rect(fill = 'thistle'))
#ggsave('appendix_avg_age.pdf')

life_expectancy_data_filtered<-filter(life_expectancy_data, decade >= 1600)
death_cause_data_age_filtered<-filter(death_cause_data_age, decade_of_birth >= 1600)
plot_5 <- ggplot() + 
  geom_line(data=life_expectancy_data_filtered, aes(x=decade, y = avg, color='life expectancy')) + 
  geom_line(data=death_cause_data_age_filtered, aes(x=decade_of_birth, y=age, color='life span')) +
  scale_x_continuous(breaks=seq(1400, 2000, by = 100))+
  labs(x ="Decade of Birth", y="Age", face='bold')+
  #labs(title="Global Life Expectancy vs Average Lifespan", subtitle="- Life expectancy is worldwide average from Our World in Data
      # - Average lifespan is from Wikipedia dataset") +
  theme_light() + theme(plot.background = element_rect(fill = 'thistle'))
#ggsave('avg_age.pdf')

# --------- EXTRA --------- EXTRA --------- EXTRA --------- EXTRA ---------

#life_expectancy_data<-read_csv('life-expectancy.csv')%>%
# filter(Entity=='World')%>%
#group_by(Life_expectancy, Year)%>%
#summarise(avg_life_expectancy=mean(Life_expectancy), n_people = n())

#plot_5<-ggplot(life_expectancy_data,
#aes(x=Year, y=Life_expectancy),
#geom_line())
#plot_5 + theme_light() + theme(plot.background = element_rect(fill = 'thistle'))

#death_cause_data_grouped<-group_by(death_cause_data, death_cause)%>%
  #mutate(decade=floor(Death_Year/10))%>%
  #group_by(death_cause, decade)%>%
  #summarise(counted_deaths=n())%>%

#death_cause_10=c('Myocardial infarction','Cancer','Pneumonia','Lung cancer','Stroke','Suicide','Heart failure', 'Pancreatic cancer', 'Death by natural causes','Homicide')
#top_10_death_causes<-filter(death_cause_data, str_detect(death_cause, death_cause_10))

#profession_data_grouped<-group_by(death_cause_data, Occupation)
#print(profession_data_grouped)
#counted_columns_profession<-count(profession_data_grouped, Occupation)
#counted_columns_death_year<-count(profession_data_grouped, Death_Year)
#counted_columns_death_place<-count(profession_data_grouped, Death_Place)

#aes(x = "death cause", y = "total")
#+ geom_bar(stat = 'death_cause', fun.y = 'n')

# age of death over time
# running sum total (look at rates of change)
# total deaths per top five by decade

#death_age<-death_cause_data[!is.na(as.numeric(as.character(death_cause_data$Death_Year))),]
#death_age<-death_cause_data[!is.na(as.numeric(as.character(death_cause_data$Birth_Year))),]
#death_age<-mutate(death_cause_data_grouped, death_age=Death_Year-Birth_Year)
# dat[!is.na(as.numeric(as.character(dat$y))),]
# words <- c(death_cause_data_grouped, "death_cause") 
# words
# word_count
# wordcount(words)

# summarize(death_cause_data_grouped, summarized_var=sum(death_cause_data_grouped))

#death_cause_10=c('Myocardial infarction','Cancer','Pneumonia','Lung cancer','Stroke','Suicide','Heart failure', 'Pancreatic cancer', 'Death by natural causes','Homicide')