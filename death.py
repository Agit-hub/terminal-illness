import json 
import csv

with open('cause_of_death.json') as file:
    data = json.load(file)

with open('cause_of_death.csv', 'w') as file:
    file.write('Title, Cause of Death, Profession, Death Year, Death Place\n')
    for person in data:
        file.write(f"{person['title']}​​​​;{person['ontology/deathCause_label']}​​​​;{person.get('ontology/profession_label')}​​​​;{person.get('deathYear')}​​​​;{person.get('deathPlace')}​​​​\n")
