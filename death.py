import json 
import csv

with open('cause_of_death.json') as file:
    data = json.load(file)

with open('cause_of_death.csv', 'w') as file:
    file.write('Title; death_cause; Occupation; Death_Year; Death_Place\n')
    for person in data:
        file.write(f"{person['title']}​​​​;{person['ontology/deathCause_label']}​​​​;{person.get('ontology/occupation_label')}​​​​;{person.get('ontology/deathYear')}​​​​;{person.get('ontology/deathPlace_label')}​​​​\n")
