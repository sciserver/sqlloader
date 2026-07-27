#!/usr/bin/env python3
"""
Fix mssql_pk_0112.sql to add ON [MINIDB] to all 179 primary keys.

For tables with compression:
  WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];

For tables without compression:
  PRIMARY KEY CLUSTERED (cols) ON [MINIDB];
"""

import re

input_file = r'H:\GitHub\sqlloader\dr20\mssql_pk_0112.sql.bak'
output_file = r'H:\GitHub\sqlloader\dr20\mssql_pk_0112.sql'

with open(input_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Pattern 1: Tables WITH compression (need to add ON [MINIDB] after compression clause)
# Match: WITH (DATA_COMPRESSION = PAGE);
# Replace with: WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];
pattern1 = r'WITH \(DATA_COMPRESSION = PAGE\);'
replacement1 = r'WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];'
content = re.sub(pattern1, replacement1, content)

# Pattern 2: Tables WITHOUT compression (need to add ON [MINIDB] before semicolon)
# Match: PRIMARY KEY CLUSTERED (column_list);
# But only if NOT followed by WITH (DATA_COMPRESSION
# Replace with: PRIMARY KEY CLUSTERED (column_list) ON [MINIDB];

# More precise: Find lines with PRIMARY KEY CLUSTERED that end with ); but don't have WITH
# This matches the end of ALTER TABLE...ADD CONSTRAINT lines
pattern2 = r'(PRIMARY KEY CLUSTERED \([^)]+\));(?!\s*WITH)'
replacement2 = r'\1 ON [MINIDB];'
content = re.sub(pattern2, replacement2, content, flags=re.MULTILINE)

# Write the fixed file
with open(output_file, 'w', encoding='utf-8') as f:
    f.write(content)

print(f"Fixed {output_file}")
print(f"  - Added ON [MINIDB] to all primary keys")
print(f"  - Compressed tables: WITH (DATA_COMPRESSION = PAGE) ON [MINIDB];")
print(f"  - Non-compressed tables: PRIMARY KEY CLUSTERED (...) ON [MINIDB];")
