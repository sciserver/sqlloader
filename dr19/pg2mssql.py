

import os


date ="01222025"
print(os.getcwd())



date ="01222025"
filename = f"H:/GitHub/sqlloader/dr19/create_minidb_dr19_rev_{date}.sql"


tables = []
indexes = []
fks = []
pks = []
with open(filename) as file:
   for line in file:
    
    # create tables come first
    if line.startswith('CREATE TABLE'):
        table = []
        table.append(line)
        for line in file:
            if line.startswith(');'):
                table.append(line)
                tables.append(table)
                break
            else:
                table.append(line)

    # next comes the pk's and fk's
    elif line.startswith('ALTER TABLE'): 
        pk = []
        fk = []
        pk.append(line)
        fk.append(line)
        for line in file:
            if (line.find('PRIMARY KEY') != -1):
                pk.append(line)
                pks.append(pk)
                break
            elif (line.find('FOREIGN KEY') != -1): 
                fk.append(line)
                fks.append(fk)
                break
    

    elif line.startswith('CREATE INDEX'):
        # this should just be one line
        # but for consistency...
        index = []
        index.append(line)
        for line in file:

            indexes.append(index)
            break
   
print(tables)
print(pks)
print(indexes)
print(fks)



# now write out each file in mssql syntax

# tables

t = open(f'mssql_tables_{date}.sql', 'w')

for table in tables:
    t.write('\n\n')
    for idx,line in enumerate(table):
        if idx == 0:
            s = line.split()
            tablename = s[2].replace('minidb_dr19.', 'dbo.')
            #print(tablename)
            #print(f'DROP TABLE IF EXISTS {tablename}')
            t.write(f'DROP TABLE IF EXISTS {tablename}\n')
        t.write(line.replace('minidb_dr19.', 'dbo.').replace('boolean','bit').replace('character varying', 'varchar').replace('text', 'varchar(500)').replace('character', 'varchar').replace('plan', 'planname'))

# pks
p = open(f'mssql_pk_{date}.sql', 'w')
for pk in pks:
    p.write('\n\n')
    for line in pk:
        p.write(line.replace('minidb_dr19.', 'dbo.').replace('ONLY', '').replace('PRIMARY KEY', 'PRIMARY KEY CLUSTERED'))

i = open(f'mssql_indexes_{date}.sql', 'w')
for idx in indexes:
    i.write('\n\n')
    for line in idx:
        i.write(line.replace('minidb_dr19.', 'dbo.').replace('CREATE INDEX', 'CREATE NONCLUSTERED INDEX').replace('USING btree', ''))

ff = open(f'mssql_fk_{date}.sql', 'w')
for fk in fks:
    ff.write('\n\n')
    for line in fk:
        ff.write(line.replace('minidb_dr19.', 'dbo.').replace('ONLY',''))
        







