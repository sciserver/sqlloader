
# right now this parses the mssql_*.sql files and generates lists of the info needed to generate the IndexMap.sql file
# TODO: actually generate the IndexMap.sql for these tables, etc

from asyncore import write


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
#pk:
#INSERT [dbo].[IndexMap]   VALUES  ('K', 'primary key', 'PhotoObjAll', 'objID', '', 'PHOTO', 'PAGE', 'PHOTO', 1)

def write_pks(_pks):
    for _pk in _pks:
         print(f'INSERT  [dbo].[IndexMap]   VALUES  (\'{_pk[0]}\', \'primary key\', \'{_pk[1]}\', \'{_pk[2]}\', \'\', \'PHOTO\', \'PAGE\', \'PHOTO\', 1)')
#idx:
#INSERT [dbo].[IndexMap]   VALUES ( 'I', 'index', 'TwoMass', 'ra', '', 'PHOTO', 'PAGE', 'PHOTO', 1)
def write_indexes(_indexes):
    for _idx in _indexes:
        print(f'INSERT [dbo].[IndexMap]   VALUES ( \'{_idx[0]}\', \'index\', \'{_idx[1]}\',  \'{_idx[2]}\', \'\', \'PHOTO\', \'PAGE\', \'PHOTO\', 1)')
#fks:
#INSERT IndexMap Values('F','foreign key', 'PhotoObjDR7', 	'dr8objID'	,'PhotoObjAll(objID)'	,'SCHEMA');
# i added the extra columns for compression, etc -- don't know if this is actually needed, will check w ani
def write_fks(_fks):
    for _fk in _fks:
        print(f'INSERT IndexMap Values(\'{_fk[0]}\',\'foreign key\', \'{_fk[1]}\', 	\'{_fk[2]}\'	,\'{_fk[3]}\',	\'SCHEMA\',\'PAGE\',\'SCHEMA\', 1);')





write_pks(pks)
write_indexes(indexes)
write_fks(fks)



