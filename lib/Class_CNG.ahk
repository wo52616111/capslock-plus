; ===============================================================================================================================
; AutoHotkey wrapper for Cryptography API: Next Generation
;
; Author ....: jNizM
; Released ..: 2016-09-15
; Modified ..: 2021-01-04
; Github ....: https://github.com/jNizM/AHK_CNG
; Forum .....: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=23413
; ===============================================================================================================================


class Crypt
{

	; ===== PUBLIC CLASS / METHODS ==============================================================================================

	class Encrypt
	{

		String(AlgId, Mode := "", String := "", Key := "", IV := "", Encoding := "utf-8", Output := "BASE64")
		{
			try
			{
				; verify the encryption algorithm
				if !(ALGORITHM_IDENTIFIER := Crypt.Verify.EncryptionAlgorithm(AlgId))
					throw Exception("Wrong ALGORITHM_IDENTIFIER", -1)

				; open an algorithm handle.
				if !(ALG_HANDLE := Crypt.BCrypt.OpenAlgorithmProvider(ALGORITHM_IDENTIFIER))
					throw Exception("BCryptOpenAlgorithmProvider failed", -1)

				; verify the chaining mode
				if (CHAINING_MODE := Crypt.Verify.ChainingMode(Mode))
					; set chaining mode property.
					if !(Crypt.BCrypt.SetProperty(ALG_HANDLE, Crypt.Constants.BCRYPT_CHAINING_MODE, CHAINING_MODE))
						throw Exception("SetProperty failed", -1)

				; generate the key from supplied input key bytes.
				if !(KEY_HANDLE := Crypt.BCrypt.GenerateSymmetricKey(ALG_HANDLE, Key, Encoding))
					throw Exception("GenerateSymmetricKey failed", -1)

				; calculate the block length for the IV.
				if !(BLOCK_LENGTH := Crypt.BCrypt.GetProperty(ALG_HANDLE, Crypt.Constants.BCRYPT_BLOCK_LENGTH, 4))
					throw Exception("GetProperty failed", -1)

				; use the key to encrypt the plaintext buffer. for block sized messages, block padding will add an extra block.
				cbInput := Crypt.Helper.StrPutVar(String, pbInput, Encoding)
				if !(CIPHER_LENGTH := Crypt.BCrypt.Encrypt(KEY_HANDLE, pbInput, cbInput, IV, BLOCK_LENGTH, CIPHER_DATA, Crypt.Constants.BCRYPT_BLOCK_PADDING))
					throw Exception("Encrypt failed", -1)

				; convert binary data to string (base64 / hex / hexraw)
				if !(ENCRYPT := Crypt.Helper.CryptBinaryToString(CIPHER_DATA, CIPHER_LENGTH, Output))
					throw Exception("CryptBinaryToString failed", -1)
			}
			catch Exception
			{
				; represents errors that occur during application execution
				throw Exception
			}
			finally
			{
				; cleaning up resources
				if (KEY_HANDLE)
					Crypt.BCrypt.DestroyKey(KEY_HANDLE)

				if (ALG_HANDLE)
					Crypt.BCrypt.CloseAlgorithmProvider(ALG_HANDLE)
			}
			return ENCRYPT
		}
	}


	class Decrypt
	{

		String(AlgId, Mode := "", String := "", Key := "", IV := "", Encoding := "utf-8", Input := "BASE64")
		{
			try
			{
				; verify the encryption algorithm
				if !(ALGORITHM_IDENTIFIER := Crypt.Verify.EncryptionAlgorithm(AlgId))
					throw Exception("Wrong ALGORITHM_IDENTIFIER", -1)

				; open an algorithm handle.
				if !(ALG_HANDLE := Crypt.BCrypt.OpenAlgorithmProvider(ALGORITHM_IDENTIFIER))
					throw Exception("BCryptOpenAlgorithmProvider failed", -1)

				; verify the chaining mode
				if (CHAINING_MODE := Crypt.Verify.ChainingMode(Mode))
					; set chaining mode property.
					if !(Crypt.BCrypt.SetProperty(ALG_HANDLE, Crypt.Constants.BCRYPT_CHAINING_MODE, CHAINING_MODE))
						throw Exception("SetProperty failed", -1)

				; generate the key from supplied input key bytes.
				if !(KEY_HANDLE := Crypt.BCrypt.GenerateSymmetricKey(ALG_HANDLE, Key, Encoding))
					throw Exception("GenerateSymmetricKey failed", -1)

				; convert encrypted string (base64 / hex / hexraw) to binary data
				if !(CIPHER_LENGTH := Crypt.Helper.CryptStringToBinary(String, CIPHER_DATA, Input))
					throw Exception("CryptStringToBinary failed", -1)

				; calculate the block length for the IV.
				if !(BLOCK_LENGTH := Crypt.BCrypt.GetProperty(ALG_HANDLE, Crypt.Constants.BCRYPT_BLOCK_LENGTH, 4))
					throw Exception("GetProperty failed", -1)

				; use the key to decrypt the data to plaintext buffer
				if !(DECRYPT_LENGTH := Crypt.BCrypt.Decrypt(KEY_HANDLE, CIPHER_DATA, CIPHER_LENGTH, IV, BLOCK_LENGTH, DECRYPT_DATA, Crypt.Constants.BCRYPT_BLOCK_PADDING))
					throw Exception("Decrypt failed", -1)

				; receive the decrypted plaintext
				DECRYPT := StrGet(&DECRYPT_DATA, DECRYPT_LENGTH, Encoding)
			}
			catch Exception
			{
				; represents errors that occur during application execution
				throw Exception
			}
			finally
			{
				; cleaning up resources
				if (KEY_HANDLE)
					Crypt.BCrypt.DestroyKey(KEY_HANDLE)

				if (ALG_HANDLE)
					Crypt.BCrypt.CloseAlgorithmProvider(ALG_HANDLE)
			}
			return DECRYPT
		}

	}


	class Hash
	{

		String(AlgId, String, Encoding := "utf-8", Output := "HEXRAW")
		{
			try
			{
				; verify the hash algorithm
				if !(ALGORITHM_IDENTIFIER := Crypt.Verify.HashAlgorithm(AlgId))
					throw Exception("Wrong ALGORITHM_IDENTIFIER", -1)

				; open an algorithm handle
				if !(ALG_HANDLE := Crypt.BCrypt.OpenAlgorithmProvider(ALGORITHM_IDENTIFIER))
					throw Exception("BCryptOpenAlgorithmProvider failed", -1)

				; create a hash
				if !(HASH_HANDLE := Crypt.BCrypt.CreateHash(ALG_HANDLE))
					throw Exception("CreateHash failed", -1)

				; hash some data
				cbInput := Crypt.Helper.StrPutVar(String, pbInput, Encoding)
				if !(Crypt.BCrypt.HashData(HASH_HANDLE, pbInput, cbInput))
					throw Exception("HashData failed", -1)

				; calculate the length of the hash
				if !(HASH_LENGTH := Crypt.BCrypt.GetProperty(ALG_HANDLE, Crypt.Constants.BCRYPT_HASH_LENGTH, 4))
					throw Exception("GetProperty failed", -1)

				; close the hash
				if !(Crypt.BCrypt.FinishHash(HASH_HANDLE, HASH_DATA, HASH_LENGTH))
					throw Exception("FinishHash failed", -1)

				; convert bin to string (base64 / hex)
				if !(HASH := Crypt.Helper.CryptBinaryToString(HASH_DATA, HASH_LENGTH, Output))
					throw Exception("CryptBinaryToString failed", -1)
			}
			catch Exception
			{
				; represents errors that occur during application execution
				throw Exception
			}
			finally
			{
				; cleaning up resources
				if (HASH_HANDLE)
					Crypt.BCrypt.DestroyHash(HASH_HANDLE)

				if (ALG_HANDLE)
					Crypt.BCrypt.CloseAlgorithmProvider(ALG_HANDLE)
			}
			return HASH
		}


		File(AlgId, FileName, Bytes := 1048576, Offset := 0, Length := -1, Encoding := "utf-8", Output := "HEXRAW")
		{
			try
			{
				; verify the hash algorithm
				if !(ALGORITHM_IDENTIFIER := Crypt.Verify.HashAlgorithm(AlgId))
					throw Exception("Wrong ALGORITHM_IDENTIFIER", -1)

				; open an algorithm handle
				if !(ALG_HANDLE := Crypt.BCrypt.OpenAlgorithmProvider(ALGORITHM_IDENTIFIER))
					throw Exception("BCryptOpenAlgorithmProvider failed", -1)

				; create a hash
				if !(HASH_HANDLE := Crypt.BCrypt.CreateHash(ALG_HANDLE))
					throw Exception("CreateHash failed", -1)

				; hash some data
				if !(IsObject(File := FileOpen(FileName, "r", Encoding)))
					throw Exception("Failed to open file: " FileName, -1)
				Length := Length < 0 ? File.Length - Offset : Length
				if ((Offset + Length) > File.Length)
					throw Exception("Invalid parameters offset / length!", -1)
				while (Length > Bytes) && (Dataread := File.RawRead(Data, Bytes))
				{
					if !(Crypt.BCrypt.HashData(HASH_HANDLE, Data, Dataread))
						throw Exception("HashData failed", -1)
					Length -= Dataread
				}
				if (Length > 0)
				{
					if (Dataread := File.RawRead(Data, Length))
					{
						if !(Crypt.BCrypt.HashData(HASH_HANDLE, Data, Dataread))
							throw Exception("HashData failed", -1)
					}
				}

				; calculate the length of the hash
				if !(HASH_LENGTH := Crypt.BCrypt.GetProperty(ALG_HANDLE, Crypt.Constants.BCRYPT_HASH_LENGTH, 4))
					throw Exception("GetProperty failed", -1)

				; close the hash
				if !(Crypt.BCrypt.FinishHash(HASH_HANDLE, HASH_DATA, HASH_LENGTH))
					throw Exception("FinishHash failed", -1)

				; convert bin to string (base64 / hex)
				if !(HASH := Crypt.Helper.CryptBinaryToString(HASH_DATA, HASH_LENGTH, Output))
					throw Exception("CryptBinaryToString failed", -1)
			}
			catch Exception
			{
				; represents errors that occur during application execution
				throw Exception
			}
			finally
			{
				; cleaning up resources
				if (File)
					File.Close()

				if (HASH_HANDLE)
					Crypt.BCrypt.DestroyHash(HASH_HANDLE)

				if (ALG_HANDLE)
					Crypt.BCrypt.CloseAlgorithmProvider(ALG_HANDLE)
			}
			return HASH
		}


		HMAC(AlgId, String, Hmac, Encoding := "utf-8", Output := "HEXRAW")
		{
			try
			{
				; verify the hash algorithm
				if !(ALGORITHM_IDENTIFIER := Crypt.Verify.HashAlgorithm(AlgId))
					throw Exception("Wrong ALGORITHM_IDENTIFIER", -1)

				; open an algorithm handle
				if !(ALG_HANDLE := Crypt.BCrypt.OpenAlgorithmProvider(ALGORITHM_IDENTIFIER, Crypt.Constants.BCRYPT_ALG_HANDLE_HMAC_FLAG))
					throw Exception("BCryptOpenAlgorithmProvider failed", -1)

				; create a hash
				if !(HASH_HANDLE := Crypt.BCrypt.CreateHash(ALG_HANDLE, Hmac, Encoding))
					throw Exception("CreateHash failed", -1)

				; hash some data
				cbInput := Crypt.helper.StrPutVar(String, pbInput, Encoding)
				if !(Crypt.BCrypt.HashData(HASH_HANDLE, pbInput, cbInput))
					throw Exception("HashData failed", -1)

				; calculate the length of the hash
				if !(HASH_LENGTH := Crypt.BCrypt.GetProperty(ALG_HANDLE, Crypt.Constants.BCRYPT_HASH_LENGTH, 4))
					throw Exception("GetProperty failed", -1)

				; close the hash
				if !(Crypt.BCrypt.FinishHash(HASH_HANDLE, HASH_DATA, HASH_LENGTH))
					throw Exception("FinishHash failed", -1)

				; convert bin to string (base64 / hex)
				if !(HMAC := Crypt.Helper.CryptBinaryToString(HASH_DATA, HASH_LENGTH, Output))
					throw Exception("CryptBinaryToString failed", -1)
			}
			catch Exception
			{
				; represents errors that occur during application execution
				throw Exception
			}
			finally
			{
				; cleaning up resources
				if (HASH_HANDLE)
					Crypt.BCrypt.DestroyHash(HASH_HANDLE)

				if (ALG_HANDLE)
					Crypt.BCrypt.CloseAlgorithmProvider(ALG_HANDLE)
			}
			return HMAC
		}


		PBKDF2(AlgId, Password, Salt, Iterations := 4096, KeySize := 256, Encoding := "utf-8", Output := "HEXRAW")
		{
			try
			{
				; verify the hash algorithm
				if !(ALGORITHM_IDENTIFIER := Crypt.Verify.HashAlgorithm(AlgId))
					throw Exception("Wrong ALGORITHM_IDENTIFIER", -1)

				; open an algorithm handle
				if !(ALG_HANDLE := Crypt.BCrypt.OpenAlgorithmProvider(ALGORITHM_IDENTIFIER, Crypt.Constants.BCRYPT_ALG_HANDLE_HMAC_FLAG))
					throw Exception("BCryptOpenAlgorithmProvider failed", -1)

				; derives a key from a hash value
				if !(Crypt.BCrypt.DeriveKeyPBKDF2(ALG_HANDLE, Password, Salt, Iterations, PBKDF2_DATA, KeySize / 8, Encoding))
					throw Exception("CreateHash failed", -1)

				; convert bin to string (base64 / hex)
				if !(PBKDF2 := Crypt.Helper.CryptBinaryToString(PBKDF2_DATA , KeySize / 8, Output))
					throw Exception("CryptBinaryToString failed", -1)
			}
			catch Exception
			{
				; represents errors that occur during application execution
				throw Exception
			}
			finally
			{
				; cleaning up resources
				if (ALG_HANDLE)
					Crypt.BCrypt.CloseAlgorithmProvider(ALG_HANDLE)
			}
			return PBKDF2
		}

	}



	; ===== PRIVATE CLASS / METHODS =============================================================================================


	/*
		CNG BCrypt Functions
		https://docs.microsoft.com/en-us/windows/win32/api/bcrypt/
	*/
	class BCrypt
	{
		static hBCRYPT := DllCall("LoadLibrary", "str", "bcrypt.dll", "ptr")
		static STATUS_SUCCESS := 0


		CloseAlgorithmProvider(hAlgorithm)
		{
			DllCall("bcrypt\BCryptCloseAlgorithmProvider", "ptr", hAlgorithm, "uint", 0)
		}


		CreateHash(hAlgorithm, hmac := 0, encoding := "utf-8")
		{
			if (hmac)
				cbSecret := Crypt.helper.StrPutVar(hmac, pbSecret, encoding)
			NT_STATUS := DllCall("bcrypt\BCryptCreateHash", "ptr",  hAlgorithm
			                                              , "ptr*", phHash
			                                              , "ptr",  pbHashObject := 0
			                                              , "uint", cbHashObject := 0
			                                              , "ptr",  (pbSecret ? &pbSecret : 0)
			                                              , "uint", (cbSecret ? cbSecret : 0)
			                                              , "uint", dwFlags := 0)

			if (NT_STATUS = this.STATUS_SUCCESS)
				return phHash
			return false
		}


		DeriveKeyPBKDF2(hPrf, Password, Salt, cIterations, ByRef pbDerivedKey, cbDerivedKey, Encoding := "utf-8")
		{
			cbPassword := Crypt.Helper.StrPutVar(Password, pbPassword, Encoding)
			cbSalt := Crypt.Helper.StrPutVar(Salt, pbSalt, Encoding)
		
			VarSetCapacity(pbDerivedKey, cbDerivedKey, 0)
			NT_STATUS := DllCall("bcrypt\BCryptDeriveKeyPBKDF2", "ptr",   hPrf
			                                                   , "ptr",   &pbPassword
			                                                   , "uint",  cbPassword
			                                                   , "ptr",   &pbSalt
			                                                   , "uint",  cbSalt
			                                                   , "int64", cIterations
			                                                   , "ptr",   &pbDerivedKey
			                                                   , "uint",  cbDerivedKey
			                                                   , "uint",  dwFlags := 0)

			if (NT_STATUS = this.STATUS_SUCCESS)
				return true
			return false
		}


		DestroyHash(hHash)
		{
			DllCall("bcrypt\BCryptDestroyHash", "ptr", hHash)
		}


		DestroyKey(hKey)
		{
			DllCall("bcrypt\BCryptDestroyKey", "ptr", hKey)
		}


		Decrypt(hKey, ByRef String, cbInput, IV, BCRYPT_BLOCK_LENGTH, ByRef pbOutput, dwFlags)
		{
			VarSetCapacity(pbInput, cbInput, 0)
			DllCall("msvcrt\memcpy", "ptr", &pbInput, "ptr", &String, "ptr", cbInput)

			if (IV != "")
			{
				cbIV := VarSetCapacity(pbIV, BCRYPT_BLOCK_LENGTH, 0)
				StrPut(IV, &pbIV, BCRYPT_BLOCK_LENGTH, Encoding)
			}

			NT_STATUS := DllCall("bcrypt\BCryptDecrypt", "ptr",   hKey
			                                           , "ptr",   &pbInput
			                                           , "uint",  cbInput
			                                           , "ptr",   0
			                                           , "ptr",   (pbIV ? &pbIV : 0)
			                                           , "uint",  (cbIV ? &cbIV : 0)
			                                           , "ptr",   0
			                                           , "uint",  0
			                                           , "uint*", cbOutput
			                                           , "uint",  dwFlags)
			if (NT_STATUS = this.STATUS_SUCCESS)
			{
				VarSetCapacity(pbOutput, cbOutput, 0)
				NT_STATUS := DllCall("bcrypt\BCryptDecrypt", "ptr",   hKey
			                                               , "ptr",   &pbInput
			                                               , "uint",  cbInput
			                                               , "ptr",   0
			                                               , "ptr",   (pbIV ? &pbIV : 0)
			                                               , "uint",  (cbIV ? &cbIV : 0)
			                                               , "ptr",   &pbOutput
			                                               , "uint",  cbOutput
			                                               , "uint*", cbOutput
			                                               , "uint",  dwFlags)
				if (NT_STATUS = this.STATUS_SUCCESS)
				{
					return cbOutput
				}
			}
			return false
		}


		Encrypt(hKey, ByRef pbInput, cbInput, IV, BCRYPT_BLOCK_LENGTH, ByRef pbOutput, dwFlags := 0)
		{
			;cbInput := Crypt.Helper.StrPutVar(String, pbInput, Encoding)

			if (IV != "")
			{
				cbIV := VarSetCapacity(pbIV, BCRYPT_BLOCK_LENGTH, 0)
				StrPut(IV, &pbIV, BCRYPT_BLOCK_LENGTH, Encoding)
			}

			NT_STATUS := DllCall("bcrypt\BCryptEncrypt", "ptr",   hKey
			                                           , "ptr",   &pbInput
			                                           , "uint",  cbInput
			                                           , "ptr",   0
			                                           , "ptr",   (pbIV ? &pbIV : 0)
			                                           , "uint",  (cbIV ? &cbIV : 0)
			                                           , "ptr",   0
			                                           , "uint",  0
			                                           , "uint*", cbOutput
			                                           , "uint",  dwFlags)
			if (NT_STATUS = this.STATUS_SUCCESS)
			{
				VarSetCapacity(pbOutput, cbOutput, 0)
				NT_STATUS := DllCall("bcrypt\BCryptEncrypt", "ptr",   hKey
			                                               , "ptr",   &pbInput
			                                               , "uint",  cbInput
			                                               , "ptr",   0
			                                               , "ptr",   (pbIV ? &pbIV : 0)
			                                               , "uint",  (cbIV ? &cbIV : 0)
			                                               , "ptr",   &pbOutput
			                                               , "uint",  cbOutput
			                                               , "uint*", cbOutput
			                                               , "uint",  dwFlags)
				if (NT_STATUS = this.STATUS_SUCCESS)
				{
					return cbOutput
				}
			}
			return false
		}


		EnumAlgorithms(dwAlgOperations)
		{
			NT_STATUS := DllCall("bcrypt\BCryptEnumAlgorithms", "uint",  dwAlgOperations
			                                                  , "uint*", pAlgCount
			                                                  , "ptr*",  ppAlgList
			                                                  , "uint",  dwFlags := 0)

			if (NT_STATUS = this.STATUS_SUCCESS)
			{
				addr := ppAlgList, BCRYPT_ALGORITHM_IDENTIFIER := []
				loop % pAlgCount
				{
					BCRYPT_ALGORITHM_IDENTIFIER[A_Index, "Name"]  := StrGet(NumGet(addr + A_PtrSize * 0, "uptr"), "utf-16")
					BCRYPT_ALGORITHM_IDENTIFIER[A_Index, "Class"] := NumGet(addr + A_PtrSize * 1, "uint")
					BCRYPT_ALGORITHM_IDENTIFIER[A_Index, "Flags"] := NumGet(addr + A_PtrSize * 1 + 4, "uint")
					addr += A_PtrSize * 2
				}
				return BCRYPT_ALGORITHM_IDENTIFIER
			}
			return false
		}


		EnumProviders(pszAlgId)
		{
			NT_STATUS := DllCall("bcrypt\BCryptEnumProviders", "ptr",   pszAlgId
			                                                 , "uint*", pImplCount
			                                                 , "ptr*",  ppImplList
			                                                 , "uint",  dwFlags := 0)

			if (NT_STATUS = this.STATUS_SUCCESS)
			{
				addr := ppImplList, BCRYPT_PROVIDER_NAME := []
				loop % pImplCount
				{
					BCRYPT_PROVIDER_NAME.Push(StrGet(NumGet(addr + A_PtrSize * 0, "uptr"), "utf-16"))
					addr += A_PtrSize
				}
				return BCRYPT_PROVIDER_NAME
			}
			return false
		}


		FinishHash(hHash, ByRef pbOutput, cbOutput)
		{
			VarSetCapacity(pbOutput, cbOutput, 0)
			NT_STATUS := DllCall("bcrypt\BCryptFinishHash", "ptr",  hHash
			                                              , "ptr",  &pbOutput
			                                              , "uint", cbOutput
			                                              , "uint", dwFlags := 0)

			if (NT_STATUS = this.STATUS_SUCCESS)
				return cbOutput
			return false
		}


		GenerateSymmetricKey(hAlgorithm, Key, Encoding := "utf-8")
		{
			cbSecret := Crypt.Helper.StrPutVar(Key, pbSecret, Encoding)
			NT_STATUS := DllCall("bcrypt\BCryptGenerateSymmetricKey", "ptr",  hAlgorithm
			                                                        , "ptr*", phKey
			                                                        , "ptr",  0
			                                                        , "uint", 0
			                                                        , "ptr",  &pbSecret
			                                                        , "uint", cbSecret
			                                                        , "uint", dwFlags := 0)

			if (NT_STATUS = this.STATUS_SUCCESS)
				return phKey
			return false
		}


		GetProperty(hObject, pszProperty, cbOutput)
		{
			NT_STATUS := DllCall("bcrypt\BCryptGetProperty", "ptr",   hObject
			                                               , "ptr",   &pszProperty
			                                               , "uint*", pbOutput
			                                               , "uint",  cbOutput
			                                               , "uint*", pcbResult
			                                               , "uint",  dwFlags := 0)

			if (NT_STATUS = this.STATUS_SUCCESS)
				return pbOutput
			return false
		}


		HashData(hHash, ByRef pbInput, cbInput)
		{
			NT_STATUS := DllCall("bcrypt\BCryptHashData", "ptr",  hHash
			                                            , "ptr",  &pbInput
			                                            , "uint", cbInput
			                                            , "uint", dwFlags := 0)

			if (NT_STATUS = this.STATUS_SUCCESS)
				return true
			return false
		}


		OpenAlgorithmProvider(pszAlgId, dwFlags := 0, pszImplementation := 0)
		{
			NT_STATUS := DllCall("bcrypt\BCryptOpenAlgorithmProvider", "ptr*", phAlgorithm
			                                                         , "ptr",  &pszAlgId
			                                                         , "ptr",  pszImplementation
			                                                         , "uint", dwFlags)

			if (NT_STATUS = this.STATUS_SUCCESS)
				return phAlgorithm
			return false
		}


		SetProperty(hObject, pszProperty, pbInput)
		{
			bInput := StrLen(pbInput)
			NT_STATUS := DllCall("bcrypt\BCryptSetProperty", "ptr",   hObject
			                                               , "ptr",   &pszProperty
			                                               , "ptr",   &pbInput
			                                               , "uint",  bInput
			                                               , "uint",  dwFlags := 0)

			if (NT_STATUS = this.STATUS_SUCCESS)
				return true
			return false
		}
	}


	class Helper
	{
		static hCRYPT32 := DllCall("LoadLibrary", "str", "crypt32.dll", "ptr")

		CryptBinaryToString(ByRef pbBinary, cbBinary, dwFlags := "BASE64")
		{
			static CRYPT_STRING := { "BASE64": 0x1, "BINARY": 0x2, "HEX": 0x4, "HEXRAW": 0xc }
			static CRYPT_STRING_NOCRLF := 0x40000000

			if (DllCall("crypt32\CryptBinaryToString", "ptr",   &pbBinary
			                                         , "uint",  cbBinary
			                                         , "uint",  (CRYPT_STRING[dwFlags] | CRYPT_STRING_NOCRLF)
			                                         , "ptr",   0
			                                         , "uint*", pcchString))
			{
				VarSetCapacity(pszString, pcchString << !!A_IsUnicode, 0)
				if (DllCall("crypt32\CryptBinaryToString", "ptr",   &pbBinary
			                                             , "uint",  cbBinary
			                                             , "uint",  (CRYPT_STRING[dwFlags] | CRYPT_STRING_NOCRLF)
			                                             , "ptr",   &pszString
			                                             , "uint*", pcchString))
				{
					return StrGet(&pszString)
				}
			}
			return false
		}


		CryptStringToBinary(pszString, ByRef pbBinary, dwFlags := "BASE64")
		{
			static CRYPT_STRING := { "BASE64": 0x1, "BINARY": 0x2, "HEX": 0x4, "HEXRAW": 0xc }

			if (DllCall("crypt32\CryptStringToBinary", "ptr",   &pszString
			                                         , "uint",  0
			                                         , "uint",  CRYPT_STRING[dwFlags]
			                                         , "ptr",   0
			                                         , "uint*", pcbBinary
			                                         , "ptr",   0
			                                         , "ptr",   0))
			{
				VarSetCapacity(pbBinary, pcbBinary, 0)
				if (DllCall("crypt32\CryptStringToBinary", "ptr",   &pszString
				                                         , "uint",  0
				                                         , "uint",  CRYPT_STRING[dwFlags]
				                                         , "ptr",   &pbBinary
				                                         , "uint*", pcbBinary
				                                         , "ptr",   0
				                                         , "ptr",   0))
				{
					return pcbBinary
				}
			}
			return false
		}


		StrPutVar(String, ByRef Data, Encoding)
		{
			if (Encoding = "hex")
			{
				String := InStr(String, "0x") ? SubStr(String, 3) : String
				VarSetCapacity(Data, (Length := StrLen(String) // 2), 0)
				loop % Length
					NumPut("0x" SubStr(String, 2 * A_Index - 1, 2), Data, A_Index - 1, "char")
				return Length
			}
			else
			{
				VarSetCapacity(Data, Length := StrPut(String, Encoding) * ((Encoding = "utf-16" || Encoding = "cp1200") ? 2 : 1) - 1)
				return StrPut(String, &Data, Length, Encoding)
			}
		}

	}


	class Verify
	{

		ChainingMode(ChainMode)
		{
			switch ChainMode
			{
				case "CBC", "ChainingModeCBC": return Crypt.Constants.BCRYPT_CHAIN_MODE_CBC
				case "CFB", "ChainingModeCFB": return Crypt.Constants.BCRYPT_CHAIN_MODE_CFB
				case "ECB", "ChainingModeECB": return Crypt.Constants.BCRYPT_CHAIN_MODE_ECB
				default: return ""
			}
		}


		EncryptionAlgorithm(Algorithm)
		{
			switch Algorithm
			{
				case "AES":                return Crypt.Constants.BCRYPT_AES_ALGORITHM
				case "DES":                return Crypt.Constants.BCRYPT_DES_ALGORITHM
				case "RC2":                return Crypt.Constants.BCRYPT_RC2_ALGORITHM
				case "RC4":                return Crypt.Constants.BCRYPT_RC4_ALGORITHM
				default: return ""
			}
		}


		HashAlgorithm(Algorithm)
		{
			switch Algorithm
			{
				case "MD2":               return Crypt.Constants.BCRYPT_MD2_ALGORITHM
				case "MD4":               return Crypt.Constants.BCRYPT_MD4_ALGORITHM
				case "MD5":               return Crypt.Constants.BCRYPT_MD5_ALGORITHM
				case "SHA1", "SHA-1":     return Crypt.Constants.BCRYPT_SHA1_ALGORITHM
				case "SHA256", "SHA-256": return Crypt.Constants.BCRYPT_SHA256_ALGORITHM
				case "SHA384", "SHA-384": return Crypt.Constants.BCRYPT_SHA384_ALGORITHM
				case "SHA512", "SHA-512": return Crypt.Constants.BCRYPT_SHA512_ALGORITHM
				default: return ""
			}
		}

	}



	; ===== CONSTANTS ===========================================================================================================

	class Constants
	{
		static BCRYPT_ALG_HANDLE_HMAC_FLAG            := 0x00000008
		static BCRYPT_BLOCK_PADDING                   := 0x00000001


		; AlgOperations flags for use with BCryptEnumAlgorithms()
		static BCRYPT_CIPHER_OPERATION                := 0x00000001
		static BCRYPT_HASH_OPERATION                  := 0x00000002
		static BCRYPT_ASYMMETRIC_ENCRYPTION_OPERATION := 0x00000004
		static BCRYPT_SECRET_AGREEMENT_OPERATION      := 0x00000008
		static BCRYPT_SIGNATURE_OPERATION             := 0x00000010
		static BCRYPT_RNG_OPERATION                   := 0x00000020
		static BCRYPT_KEY_DERIVATION_OPERATION        := 0x00000040


		; https://docs.microsoft.com/en-us/windows/win32/seccng/cng-algorithm-identifiers
		static BCRYPT_3DES_ALGORITHM                  := "3DES"
		static BCRYPT_3DES_112_ALGORITHM              := "3DES_112"
		static BCRYPT_AES_ALGORITHM                   := "AES"
		static BCRYPT_AES_CMAC_ALGORITHM              := "AES-CMAC"
		static BCRYPT_AES_GMAC_ALGORITHM              := "AES-GMAC"
		static BCRYPT_DES_ALGORITHM                   := "DES"
		static BCRYPT_DESX_ALGORITHM                  := "DESX"
		static BCRYPT_MD2_ALGORITHM                   := "MD2"
		static BCRYPT_MD4_ALGORITHM                   := "MD4"
		static BCRYPT_MD5_ALGORITHM                   := "MD5"
		static BCRYPT_RC2_ALGORITHM                   := "RC2"
		static BCRYPT_RC4_ALGORITHM                   := "RC4"
		static BCRYPT_RNG_ALGORITHM                   := "RNG"
		static BCRYPT_SHA1_ALGORITHM                  := "SHA1"
		static BCRYPT_SHA256_ALGORITHM                := "SHA256"
		static BCRYPT_SHA384_ALGORITHM                := "SHA384"
		static BCRYPT_SHA512_ALGORITHM                := "SHA512"
		static BCRYPT_PBKDF2_ALGORITHM                := "PBKDF2"
		static BCRYPT_XTS_AES_ALGORITHM               := "XTS-AES"


		; https://docs.microsoft.com/en-us/windows/win32/seccng/cng-property-identifiers
		static BCRYPT_BLOCK_LENGTH                    := "BlockLength"
		static BCRYPT_CHAINING_MODE                   := "ChainingMode"
		static BCRYPT_CHAIN_MODE_CBC                  := "ChainingModeCBC"
		static BCRYPT_CHAIN_MODE_CCM                  := "ChainingModeCCM"
		static BCRYPT_CHAIN_MODE_CFB                  := "ChainingModeCFB"
		static BCRYPT_CHAIN_MODE_ECB                  := "ChainingModeECB"
		static BCRYPT_CHAIN_MODE_GCM                  := "ChainingModeGCM"
		static BCRYPT_HASH_LENGTH                     := "HashDigestLength"
		static BCRYPT_OBJECT_LENGTH                   := "ObjectLength"
	}
}
