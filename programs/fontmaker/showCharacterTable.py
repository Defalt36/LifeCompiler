for i in range(0, 256):
    # Convert number to unicode character
    # Note the first 256 numbers are the same for latin1
    character = chr(i)
    
    # Replace unicode control code characters with whitespace
    if 0 <= i <= 31 or 127 <= i <= 159:
        character = ' '
        
    if i % 16 == 15:
        print(character)
    else:
        print(character,end='')
