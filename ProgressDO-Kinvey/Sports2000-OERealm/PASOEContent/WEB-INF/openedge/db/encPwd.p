/*------------------------------------------------------------------------------
    File        : encPwd.p  
    Purpose     : simple password encryption

    Syntax      : run encPwd.p (input  p_cUserID as character,
                                      input  p_cClrTxtPwd as character,
                                      output p_cRetPassword as character). 

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------------*/
  
/* ********************  Call Parameter Definitions  ************************ */
define input  parameter p_cUserID       as character no-undo. 
define input  parameter p_cClrTxtPwd    as character no-undo. 
define output parameter p_cRetPassword  as character no-undo. 

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

m_cLastCipher = security-policy:symmetric-encryption-algorithm.
security-policy:symmetric-encryption-algorithm = "AES_ECB_256".
m_rK = generate-pbe-key(p_cUserID + chr(6) + string(0x83c0446f)).
m_mPP = encrypt(p_cClrTxtPwd, m_rK).
p_cRetPassword = "aesb1:" + base64-encode(encrypt(p_cClrTxtPwd, m_rK)).
security-policy:symmetric-encryption-algorithm = m_cLastCipher.

/* Return block-zero status to the caller */
return m_cRetValue.

/******************************************************************************/
/******************************************************************************/
/* ********************  INTERNAL PROCEDURES/FUNCTIONS ********************** */
/******************************************************************************/
/******************************************************************************/

