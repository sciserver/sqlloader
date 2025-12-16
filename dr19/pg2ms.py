import os

date = "0726"
os.chdir("H:/GitHub/sqlloader/dr19/")

filename = "H:/GitHub/sqlloader/dr19/FIXED_create_minidb_descriptions.sql"

tables = []
indexes = []
fks = []
pks = []

with open(filename) as file:
    lines = file.readlines()

i = 0
while i < len(lines):
    line = lines[i].strip()
    
    # Handle CREATE TABLE statements
    if line.startswith('CREATE TABLE'):
        table = []
        table.append(lines[i])
        i += 1
        
        # Continue reading until we find the closing ');'
        while i < len(lines):
            table.append(lines[i])
            if lines[i].strip().startswith(');'):
                tables.append(table)
                break
            i += 1
    
    # Handle ALTER TABLE statements (PK and FK)
    elif line.startswith('ALTER TABLE'):
        # Skip OWNER statements completely
        if 'OWNER' in line:
            break
        i += 1
    
            
        
        # Read the full ALTER TABLE statement
        alter_statement = []
        alter_statement.append(lines[i])
        i += 1
        
        # Continue reading until we find the semicolon
        while i < len(lines):
            alter_statement.append(lines[i])
            if lines[i].strip().endswith(';'):
                # Determine if this is a PK or FK
                full_statement = ''.join(alter_statement)
                if 'PRIMARY KEY' in full_statement:
                    pks.append(alter_statement)
                elif 'FOREIGN KEY' in full_statement:
                    fks.append(alter_statement)
                break
            i += 1
    
    # Handle CREATE INDEX statements
    elif line.startswith('CREATE INDEX'):
        index = []
        index.append(lines[i])
        i += 1
        
        # Continue reading until we find the semicolon
        while i < len(lines):
            index.append(lines[i])
            if lines[i].strip().endswith(';'):
                indexes.append(index)
                break
            i += 1
    
    else:
        i += 1

print(f"Found {len(tables)} tables")
print(f"Found {len(pks)} primary keys")
print(f"Found {len(indexes)} indexes")
print(f"Found {len(fks)} foreign keys")

# Write out tables
with open(f'mssql_tables_{date}.sql', 'w') as t:
    for table in tables:
        t.write('\n\n')
        for idx, line in enumerate(table):
            if idx == 0:
                s = line.split()
                tablename = s[2].replace('minidb_dr19.dr19_', 'dbo.mos_')
                t.write(f'DROP TABLE IF EXISTS {tablename}\n')
            
            # Apply all the replacements
            converted_line = (line
                .replace('minidb_dr19.dr19_', 'dbo.mos_')
                .replace('boolean', 'bit')
                .replace('character varying', 'varchar')
                .replace('text', 'varchar(500)')
                .replace('character', 'varchar')
                .replace('plan', 'planname')
                .replace('timestamp without time zone', 'datetime')
                .replace('public', '[public]')
                .replace('uuid', 'uniqueidentifier')
                .replace('bit(1)', 'bit')
                .replace('file', '[file]'))
            
            t.write(converted_line)

# Write out primary keys
with open(f'mssql_pk_{date}.sql', 'w') as p:
    for pk in pks:
        p.write('\n\n')
        for line in pk:
            converted_line = (line
                .replace('minidb_dr19.', 'dbo.')
                .replace('ONLY', '')
                .replace('PRIMARY KEY', 'PRIMARY KEY CLUSTERED'))
            p.write(converted_line)

# Write out indexes
with open(f'mssql_indexes_{date}.sql', 'w') as i:
    for idx in indexes:
        i.write('\n\n')
        for line in idx:
            if 'q3c' not in line:
                converted_line = (line
                    .replace('minidb_dr19.', 'dbo.')
                    .replace('CREATE INDEX', 'CREATE NONCLUSTERED INDEX')
                    .replace('USING btree', ''))
                i.write(converted_line)

# Write out foreign keys
with open(f'mssql_fk_{date}.sql', 'w') as ff:
    for fk in fks:
        ff.write('\n\n')
        for line in fk:
            converted_line = (line
                .replace('minidb_dr19.', 'dbo.')
                .replace('ONLY', ''))
            ff.write(converted_line)