; AHK implementation for CNG (https://github.com/jNizM/AHK_CNG)
class bcrypt
{
	static BCRYPT_OBJECT_LENGTH        := "ObjectLength"
	static BCRYPT_HASH_LENGTH          := "HashDigestLength"
	static BCRYPT_ALG_HANDLE_HMAC_FLAG := 0x00000008
	static hBCRYPT := DllCall("LoadLibrary", "str", "bcrypt.dll", "ptr")

	hash(String, AlgID, encoding := "utf-8")
	{
		AlgID         := this.CheckAlgorithm(AlgID)
		ALG_HANDLE    := this.BCryptOpenAlgorithmProvider(AlgID)
		OBJECT_LENGTH := this.BCryptGetProperty(ALG_HANDLE, this.BCRYPT_OBJECT_LENGTH, 4)
		HASH_LENGTH   := this.BCryptGetProperty(ALG_HANDLE, this.BCRYPT_HASH_LENGTH, 4)
		HASH_HANDLE   := this.BCryptCreateHash(ALG_HANDLE, HASH_OBJECT, OBJECT_LENGTH)
		this.BCryptHashData(HASH_HANDLE, STRING, encoding)
		HASH_LENGTH   := this.BCryptFinishHash(HASH_HANDLE, HASH_LENGTH, HASH_DATA)
		hash          := this.CalcHash(HASH_DATA, HASH_LENGTH)
		this.BCryptDestroyHash(HASH_HANDLE)
		this.BCryptCloseAlgorithmProvider(ALG_HANDLE)
		return hash
	}

	hmac(String, Hmac, AlgID, encoding := "utf-8")
	{
		AlgID         := this.CheckAlgorithm(AlgID)
		ALG_HANDLE    := this.BCryptOpenAlgorithmProvider(AlgID, this.BCRYPT_ALG_HANDLE_HMAC_FLAG)
		OBJECT_LENGTH := this.BCryptGetProperty(ALG_HANDLE, this.BCRYPT_OBJECT_LENGTH, 4)
		HASH_LENGTH   := this.BCryptGetProperty(ALG_HANDLE, this.BCRYPT_HASH_LENGTH, 4)
		HASH_HANDLE   := this.BCryptCreateHmac(ALG_HANDLE, HMAC, HASH_OBJECT, OBJECT_LENGTH, encoding)
		this.BCryptHashData(HASH_HANDLE, STRING, encoding)
		HASH_LENGTH   := this.BCryptFinishHash(HASH_HANDLE, HASH_LENGTH, HASH_DATA)
		hash          := this.CalcHash(HASH_DATA, HASH_LENGTH)
		this.BCryptDestroyHash(HASH_HANDLE)
		this.BCryptCloseAlgorithmProvider(ALG_HANDLE)
		return hash
	}

	file(FileName, AlgID, bytes := 1048576, offset := 0, length := -1, encoding := "utf-8")
	{
		AlgID         := this.CheckAlgorithm(AlgID)
		ALG_HANDLE    := this.BCryptOpenAlgorithmProvider(AlgID)
		OBJECT_LENGTH := this.BCryptGetProperty(ALG_HANDLE, this.BCRYPT_OBJECT_LENGTH, 4)
		HASH_LENGTH   := this.BCryptGetProperty(ALG_HANDLE, this.BCRYPT_HASH_LENGTH, 4)
		HASH_HANDLE   := this.BCryptCreateHash(ALG_HANDLE, HASH_OBJECT, OBJECT_LENGTH)
		if !(IsObject(f := FileOpen(filename, "r", encoding)))
			throw Exception("Failed to open file: " filename, -1)
		length := length < 0 ? f.length - offset : length
		if ((offset + length) > f.length)
			throw Exception("Invalid parameters offset / length!", -1)
		f.Pos(offset)
		while (length > bytes) && (dataread := f.RawRead(data, bytes)) {
			this.BCryptHashFile(HASH_HANDLE, DATA, DATAREAD)
			length -= dataread
		}
		if (length > 0) {
			if (dataread := f.RawRead(data, length))
				this.BCryptHashFile(HASH_HANDLE, DATA, DATAREAD)
		}
		f.Close()
		HASH_LENGTH   := this.BCryptFinishHash(HASH_HANDLE, HASH_LENGTH, HASH_DATA)
		hash          := this.CalcHash(HASH_DATA, HASH_LENGTH)
		this.BCryptDestroyHash(HASH_HANDLE)
		this.BCryptCloseAlgorithmProvider(ALG_HANDLE)
		return hash
	}

	pbkdf2(Password, Salt, AlgID, Iterations := 1024, KeySize := 128, encoding := "utf-8")
	{
		AlgID       := this.CheckAlgorithm(AlgID)
		ALG_HANDLE  := this.BCryptOpenAlgorithmProvider(AlgID, this.BCRYPT_ALG_HANDLE_HMAC_FLAG)
		this.BCryptDeriveKeyPBKDF2(ALG_HANDLE, Password, Salt, Iterations, KeySize / 8, PBKDF2_DATA, encoding)
		pbkdf2 := this.CalcHash(PBKDF2_DATA, KeySize / 8)
		this.BCryptCloseAlgorithmProvider(ALG_HANDLE)
		return pbkdf2
	}


	; ===========================================================================================================================
	; Function ...: BCryptOpenAlgorithmProvider
	; Links ......: https://docs.microsoft.com/en-us/windows/win32/api/bcrypt/nf-bcrypt-bcryptopenalgorithmprovider
	; ===========================================================================================================================
	BCryptOpenAlgorithmProvider(ALGORITHM, FLAGS := 0)
	{
		if (NT_STATUS := DllCall("bcrypt\BCryptOpenAlgorithmProvider", "ptr*", BCRYPT_ALG_HANDLE
                                                                     , "ptr",  &ALGORITHM
                                                                     , "ptr",  0
                                                                     , "uint", FLAGS) != 0)
			throw Exception("BCryptOpenAlgorithmProvider: " NT_STATUS, -1)
		return BCRYPT_ALG_HANDLE
	}

	; ===========================================================================================================================
	; Function ...: BCryptGetProperty
	; Links ......: https://docs.microsoft.com/en-us/windows/win32/api/bcrypt/nf-bcrypt-bcryptgetproperty
	; ===========================================================================================================================
	BCryptGetProperty(BCRYPT_HANDLE, PROPERTY, cbOutput)
	{
		if (NT_STATUS := DllCall("bcrypt\BCryptGetProperty", "ptr",   BCRYPT_HANDLE
                                                           , "ptr",   &PROPERTY
                                                           , "uint*", pbOutput
                                                           , "uint",  cbOutput
                                                           , "uint*", cbResult
                                                           , "uint",  0) != 0)
			throw Exception("BCryptGetProperty: " NT_STATUS, -1)
		return pbOutput
	}

	; ===========================================================================================================================
	; Function ...: BCryptCreateHash
	; Links ......: https://docs.microsoft.com/en-us/windows/win32/api/bcrypt/nf-bcrypt-bcryptcreatehash
	; ===========================================================================================================================
	BCryptCreateHash(BCRYPT_ALG_HANDLE, ByRef pbHashObject, cbHashObject)
	{
		VarSetCapacity(pbHashObject, cbHashObject, 0)
		if (NT_STATUS := DllCall("bcrypt\BCryptCreateHash", "ptr",  BCRYPT_ALG_HANDLE
                                                          , "ptr*", BCRYPT_HASH_HANDLE
                                                          , "ptr",  &pbHashObject
                                                          , "uint", cbHashObject
                                                          , "ptr",  0
                                                          , "uint", 0
                                                          , "uint", 0) != 0)
			throw Exception("BCryptCreateHash: " NT_STATUS, -1)
		return BCRYPT_HASH_HANDLE
	}

	BCryptCreateHmac(BCRYPT_ALG_HANDLE, HMAC, ByRef pbHashObject, cbHashObject, encoding := "utf-8")
	{
		VarSetCapacity(pbHashObject, cbHashObject, 0)
		VarSetCapacity(pbSecret, (StrPut(HMAC, encoding) - 1) * ((encoding = "utf-16" || encoding = "cp1200") ? 2 : 1), 0)
		cbSecret := StrPut(HMAC, &pbSecret, encoding) - 1
		if (NT_STATUS := DllCall("bcrypt\BCryptCreateHash", "ptr",  BCRYPT_ALG_HANDLE
                                                          , "ptr*", BCRYPT_HASH_HANDLE
                                                          , "ptr",  &pbHashObject
                                                          , "uint", cbHashObject
                                                          , "ptr",  &pbSecret
                                                          , "uint", cbSecret
                                                          , "uint", 0) != 0)
			throw Exception("BCryptCreateHash: " NT_STATUS, -1)
		return BCRYPT_HASH_HANDLE
	}

	; ===========================================================================================================================
	; Function ...: BCryptHashData
	; Links ......: https://docs.microsoft.com/en-us/windows/win32/api/bcrypt/nf-bcrypt-bcrypthashdata
	; ===========================================================================================================================
	BCryptHashData(BCRYPT_HASH_HANDLE, STRING, encoding := "utf-8")
	{
		VarSetCapacity(pbInput, (StrPut(STRING, encoding) - 1) * ((encoding = "utf-16" || encoding = "cp1200") ? 2 : 1), 0)
		cbInput := StrPut(STRING, &pbInput, encoding) - 1
		if (NT_STATUS := DllCall("bcrypt\BCryptHashData", "ptr",  BCRYPT_HASH_HANDLE
                                                        , "ptr",  &pbInput
                                                        , "uint", cbInput
                                                        , "uint", 0) != 0)
			throw Exception("BCryptHashData: " NT_STATUS, -1)
		return true
	}

	BCryptHashFile(BCRYPT_HASH_HANDLE, pbInput, cbInput)
	{
		if (NT_STATUS := DllCall("bcrypt\BCryptHashData", "ptr",  BCRYPT_HASH_HANDLE
                                                        , "ptr",  &pbInput
                                                        , "uint", cbInput
                                                        , "uint", 0) != 0)
			throw Exception("BCryptHashData: " NT_STATUS, -1)
		return true
	}

	; ===========================================================================================================================
	; Function ...: BCryptFinishHash
	; Links ......: https://docs.microsoft.com/en-us/windows/win32/api/bcrypt/nf-bcrypt-bcryptfinishhash
	; ===========================================================================================================================
	BCryptFinishHash(BCRYPT_HASH_HANDLE, cbOutput, ByRef pbOutput)
	{
		VarSetCapacity(pbOutput, cbOutput, 0)
		if (NT_STATUS := DllCall("bcrypt\BCryptFinishHash", "ptr",  BCRYPT_HASH_HANDLE
                                                          , "ptr",  &pbOutput
                                                          , "uint", cbOutput
                                                          , "uint", 0) != 0)
			throw Exception("BCryptFinishHash: " NT_STATUS, -1)
		return cbOutput
	}

	; ===========================================================================================================================
	; Function ...: BCryptDeriveKeyPBKDF2
	; Links ......: https://docs.microsoft.com/en-us/windows/win32/api/bcrypt/nf-bcrypt-bcryptderivekeypbkdf2
	; ===========================================================================================================================
	BCryptDeriveKeyPBKDF2(BCRYPT_ALG_HANDLE, PASS, SALT, cIterations, cbDerivedKey, ByRef pbDerivedKey, encoding := "utf-8")
	{
		VarSetCapacity(pbDerivedKey, cbDerivedKey, 0)
		VarSetCapacity(pbPass, (StrPut(PASS, encoding) - 1) * ((encoding = "utf-16" || encoding = "cp1200") ? 2 : 1), 0)
		cbPass := StrPut(PASS, &pbPass, encoding) - 1
		VarSetCapacity(pbSalt, (StrPut(SALT, encoding) - 1) * ((encoding = "utf-16" || encoding = "cp1200") ? 2 : 1), 0)
		cbSalt := StrPut(SALT, &pbSalt, encoding) - 1
		if (NT_STATUS := DllCall("bcrypt\BCryptDeriveKeyPBKDF2", "ptr",   BCRYPT_ALG_HANDLE
                                                               , "ptr",   &pbPass
                                                               , "uint",  cbPass
                                                               , "ptr",   &pbSalt
                                                               , "uint",  cbSalt
                                                               , "int64", cIterations
                                                               , "ptr",   &pbDerivedKey
                                                               , "uint",  cbDerivedKey
                                                               , "uint",  0) != 0)
			throw Exception("BCryptDeriveKeyPBKDF2: " NT_STATUS, -1)
		return true
	}

	; ===========================================================================================================================
	; Function ...: BCryptDestroyHash
	; Links ......: https://docs.microsoft.com/en-us/windows/win32/api/bcrypt/nf-bcrypt-bcryptdestroyhash
	; ===========================================================================================================================
	BCryptDestroyHash(BCRYPT_HASH_HANDLE)
	{
		if (NT_STATUS := DllCall("bcrypt\BCryptDestroyHash", "ptr", BCRYPT_HASH_HANDLE) != 0)
			throw Exception("BCryptDestroyHash: " NT_STATUS, -1)
		return true
	}

	; ===========================================================================================================================
	; Function ...: BCryptCloseAlgorithmProvider
	; Links ......: https://docs.microsoft.com/en-us/windows/win32/api/bcrypt/nf-bcrypt-bcryptclosealgorithmprovider
	; ===========================================================================================================================
	BCryptCloseAlgorithmProvider(BCRYPT_ALG_HANDLE)
	{
		if (NT_STATUS := DllCall("bcrypt\BCryptCloseAlgorithmProvider", "ptr",  BCRYPT_ALG_HANDLE
                                                                      , "uint", 0) != 0)
			throw Exception("BCryptCloseAlgorithmProvider: " NT_STATUS, -1)
		return true
	}


	; ===========================================================================================================================
	; For Internal Use Only
	; ===========================================================================================================================
	CheckAlgorithm(ALGORITHM)
	{
		static HASH_ALGORITHM := ["MD2", "MD4", "MD5", "SHA1", "SHA256", "SHA384", "SHA512"]
		for index, value in HASH_ALGORITHM
			if (value = ALGORITHM)
				return Format("{:U}", ALGORITHM)
		throw Exception("Invalid hash algorithm", -1, ALGORITHM)
	}

	CalcHash(Byref HASH_DATA, HASH_LENGTH)
	{
		loop % HASH_LENGTH
			HASH .= Format("{:02x}", NumGet(HASH_DATA, A_Index - 1, "uchar"))
		return HASH
	}
}

; ===============================================================================================================================