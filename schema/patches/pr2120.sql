-- Fix the typo in the value of last SEGUE1TARGET2 bit (PR #2120).

UPDATE DataConstants
   SET [value] = 0x0000000000000200
WHERE [field] = 'Segue1Target2' AND [name] = 'SEGUE1_SPECPHOTO'

