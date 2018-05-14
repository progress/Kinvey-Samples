/*------------------------------------------------------------------------------
    File        : decPwd.p  
    Purpose     : simple password decryption

    Syntax      : run encPwd.p (input  p_cUserID as character,
                                      input  p_cCipherTxtPwd as character,
                                      output p_cRetClrTxtPwd as character). 

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------------*/
  
/* ********************  Call Parameter Definitions  ************************ */
define input  parameter p_cUserID       as character no-undo. 
define input  parameter p_cCipherTxtPwd as character no-undo. 
define output parameter p_cRetClrTxtPwd as character no-undo. 

/* *********************  Module Variable Definitions  ********************** */
define variable m_cRetValue             as character initial "" no-undo.
define variable m_rPP                   as raw no-undo. 
define variable m_mPP                   as memptr no-undo. 
define variable m_rK                    as raw no-undo. 
define variable m_cTmpPP                as character no-undo. 
define variable m_cLastCipher           as character no-undo. 

/* ***********************  Preprocessor Definitions  *********************** */

/* ************************* Procedure Settings ***************************** */

/******************************************************************************/
/******************************************************************************/
/*********               MAIN  (BLOCK-ZERO)                            ********/
/******************************************************************************/
/******************************************************************************/

if ( "aesb1:" = substring(p_cCipherTxtPwd, 1, 6) ) then do:
    m_cLastCipher = security-policy:symmetric-encryption-algorithm.
    security-policy:symmetric-encryption-algorithm = "AES_ECB_256".
    m_cTmpPP = substring(p_cCipherTxtPwd, 7).
    m_rPP = base64-decode(m_cTmpPP).
    m_rK = generate-pbe-key(p_cUserID + chr(6) + string(0x83c0446f)).
    p_cRetClrTxtPwd = get-string(decrypt(m_rPP, m_rK, ?, "AES_ECB_256"),1).
    security-policy:symmetric-encryption-algorithm = m_cLastCipher.
end. else
    m_cRetValue = "Not an encrypted password".

/* Return block-zero status to the caller */
return m_cRetValue.

/******************************************************************************/
/******************************************************************************/
/* ********************  INTERNAL PROCEDURES/FUNCTIONS ********************** */
/******************************************************************************/
/******************************************************************************/

