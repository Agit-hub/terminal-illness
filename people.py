import json

import csv

with open('cause_of_death.json') as file:
   data = json.load(file)

with open('cause_of_death.csv', 'w') as file:
   file.write('Title, Cause of Death, Profession, Death Year, Death Place\n')
      for person in data:
         file.write(f"{​​​​person['title']}​​​​,{​​​​person['ontology/deathCause_label']}​​​​,{​​​​person.get('ontology/profession_label')}​​​​,{​​​​person.get('deathYear')}​​​​,{​​​​person.get('deathPlace')}​​​​\n")

#gggg

# import json 
# import csv

# with open('cause_of_death.json') as file: 
#    data = json.load(file)

# # Write column headers
# with open('death_cause.csv', 'w') as file:
#    file.write('Title, Cause of Death, Profession, Death Year, Death Place\n') #mention colomns 
# # Write individual dictionaries as lines
#    for person in data: 
#       file.write(f"{person['title']},{person['ontology/deathCause_label']},{person['profession']},{person.get('deathYear')},{person.get('deathYear')}\n") 




# cause_of_death_data = data['deathCause']

# final_death_cause_file = open('final_death_cause_file.csv', 'w')

# csv_writer = csv.writer(final_death_cause_file)
# count = 0 
# for 

#     A_people_data = json.load(A_people_file)

# for profession in profession_data: 
#     if 'profession_type' == profession_data['profession']: 
        
#         # if = (A_people_data['profession'] for x in json.loads(profession_label))
#         for profession in professions:
#             print(profession) 