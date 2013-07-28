#Define MAX_INI_BUFFERSIZE 256
#Define MAX_INI_ENUM_BUFFERSIZE 16000

*** Registry Roots *** 
#Define HKEY_CLASSES_ROOT           -2147483648  && (( HKEY ) 0x80000000 )
#Define HKEY_CURRENT_USER           -2147483647  && (( HKEY ) 0x80000001 )
#Define HKEY_LOCAL_MACHINE          -2147483646  && (( HKEY ) 0x80000002 )
#Define HKEY_USERS                  -2147483645  && (( HKEY ) 0x80000003 )

*** Success Flag
#Define ERROR_SUCCESS               0

*** Registry Value types
#Define REG_NONE					0    && Undefined Type (default)
#Define REG_SZ						1	 && Regular Null Terminated String
#Define REG_BINARY					3    && ??? (unimplemented) 
#Define REG_DWORD					4    && Long Integer value
#Define MULTI_SZ					7	 && Multiple Null Term Strings