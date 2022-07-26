



filename = 'create_minidb_dr18.sql'


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
   

#print(tables)
#print(pks)
#print(indexes)
#print(fks)


# now write out each file in mssql syntax

# tables
t = open('mssql_tables.sql', 'w')

for table in tables:
    t.write('\n\n')
    for line in table:
        t.write(line.replace('minidb.', 'dbo.').replace('boolean','bit').replace('character varying', 'varchar').replace('character', 'varchar').replace('plan', 'planname'))

# pks
p = open('mssql_pk.sql', 'w')
for pk in pks:
    p.write('\n\n')
    for line in pk:
        p.write(line.replace('minidb.', 'dbo.').replace('ONLY', '').replace('PRIMARY KEY', 'PRIMARY KEY CLUSTERED'))

i = open('mssql_indexes.sql', 'w')
for idx in indexes:
    i.write('\n\n')
    for line in idx:
        i.write(line.replace('minidb.', 'dbo.').replace('CREATE INDEX', 'CREATE NONCLUSTERED INDEX').replace('USING btree', ''))

ff = open('mssql_fk.sql', 'w')
for fk in fks:
    ff.write('\n\n')
    for line in fk:
        ff.write(line.replace('minidb.', 'dbo.').replace('ONLY',''))





