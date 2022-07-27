
# right now this parses the mssql_*.sql files and generates lists of the info needed to generate the IndexMap.sql file
# TODO: actually generate the IndexMap.sql for these tables, etc

pks = []
indexes = []
fks = []

with open('mssql_pk.sql') as file:


    lines = file.read()

    chunks = lines.split("\n\n")


    for chunk in chunks:
       s = chunk.split()
       #print(s)
       if len(s) >= 2:
        tablename = s[2]
        cols = s[-1].replace('(', '').replace(')','').replace(';','')
        #print(tablename)
        #print(cols)
        pk = ['K',tablename, cols]
        pks.append(pk)
    
with open('mssql_indexes.sql') as file:
    lines = file.read()

    chunks = lines.split(";")
    
    for chunk in chunks:
        s = chunk.split()
        #print(s)
        if len(s) >= 2:
            tablename = s[5]
            cols = s[-1].replace('(', '').replace(')','')
            
            # this gets rid of those weird ones with math in them
            if len(cols) <=6:
                idx = ['I', tablename, cols]
                indexes.append(idx)

with open('mssql_fk.sql') as file:
    lines = file.read()

    chunks = lines.split(";")
    
    for chunk in chunks:
        s = chunk.strip().split()
        #print(s)
        if len(s) >= 2:
            tablename = s[2]
            col = s[8].replace('(', '').replace(')','')
            fkcols = s[-1]
            fk = ['F',tablename, col, fkcols]
            fks.append(fk)


'''
print(pks, '\n\n')
print(indexes, '\n\n')
print(fks, '\n\n')
'''

#INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'PhotoObjAll', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)

def write_pks(_pks):
    for _pk in _pks:
         print(f'INSERT  [dbo].[IndexMap]   VALUES  (\'K\', \'primary key\', \'{_pk[1]}\', \'{_pk[2]}\', \'\', \'PHOTO\', \'PAGE\', \'PHOTO\', 1)')


write_pks(pks)



