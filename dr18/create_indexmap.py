
with open('mssql_pk.sql') as file:


    lines = file.read()

    chunks = lines.split("\n\n")

    for chunk in chunks:
       s = chunk.split()
       #print(s)
       if len(s) >= 2:
        tablename = s[2]
        indexname = s[-1].replace('(', '').replace(')','').replace(';','')
        print(tablename)
        print(indexname)
    



