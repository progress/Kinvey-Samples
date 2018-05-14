 
 /*------------------------------------------------------------------------
    File        : HybridRealm
    Purpose     : Sample OOABL Server class of OERealm
    Syntax      : 
    Description : Singleton class that implements IHybridRealm for use as
                  a single point of authentication for OE Realm Clients
                  viz. OEBPM, REST and Rollbase
    Author(s)   : Progress Software Corporation
    Created     : Thursday July 23 10:41:36 EST 2015
    Notes       : This sample uses OpenEdge database’s _User table for illustration.
                  Users can use any other user account source,
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Security.Realm.IHybridRealm.
USING OpenEdge.Security.Util.*.
USING OpenEdge.Security.Realm.OERealmDefs.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.Security.Realm.HybridRealm IMPLEMENTS IHybridRealm:

    DEFINE PRIVATE VARIABLE m_validateCP AS LOGICAL NO-UNDO INITIAL FALSE.
    DEFINE PRIVATE VARIABLE m_debugMsg AS LOGICAL NO-UNDO INITIAL TRUE.
    DEFINE PRIVATE VARIABLE m_passwd AS CHARACTER NO-UNDO.
    DEFINE PRIVATE VARIABLE m_role AS CHARACTER NO-UNDO.
    DEFINE PRIVATE VARIABLE m_autoUserNum  AS LOGICAL INITIAL YES NO-UNDO.
    DEFINE TEMP-TABLE ttUser LIKE _User.
    
    DEFINE PRIVATE VARIABLE m_spaProps AS CLASS OpenEdge.Security.Util.Properties.
      
    /*------------------------------------------------------------------------------
     Purpose: Default constructor
     Notes: Reads a property file names "spaservice.properties" to intialize:
         1. ValidateCP - If true, the OERealm methods will validate if the request came 
                         from a trusted client by checking for existence of a 
                         sealed client-Principal(C-P)
                       - If false, no such C-P validation will not be performed.  
                       - This serves as an additional layer of security.It is highly
                         recommended that this validation be turned on
                       - In order to turn on this additional security validation:
                         1. The Implementor of OE Realm will create a .cp file using
                         genspacp utility and distribute it to the trusted OERealm Clients.
--------------------------------------------------------------------
The syntax of genspacp is as below:
genspacp -password <text> [-user <text> -role <text> -domain <text> -file <text>]
--------------------------------------------------------------------
                         2. The .cp file will be sealed by the "password" field provided
                            to the utility   
         2. Password  -  The value will be used to validate the incoming C-P
                      -  It must match the value provided while generating .cp using
                         genspacp utility
                      -  It is applicable only when validateCP is true
         3. Role      -  The value must match the role that the incoming C-P contains
                      -  It must match the value provided while generating .cp using
                         genspacp utility
                      -  It is applicable only when validateCP is true
         4. DebugMsg  - If true, debug messages will be logged in server log file
    ------------------------------------------------------------------------------*/
        
    CONSTRUCTOR PUBLIC HybridRealm (  ):
        SUPER ().
        m_spaProps = NEW Properties("spaservice.properties").
        m_validateCP = m_spaProps:GetLogicalProperty("validateCP", ?).
        m_debugMsg = m_spaProps:GetLogicalProperty("DebugMsg", ?).
        IF m_validateCP THEN DO: 
            m_passwd = m_spaProps:GetCharacterProperty("Password", "").
            m_role = m_spaProps:GetCharacterProperty("role", "SpaClient").
        END.
        IF m_debugMsg THEN DO:
            MESSAGE "Loaded property file spaservice.properties".
            MESSAGE "   DebugMsg: " m_passwd.
            IF m_validateCP THEN DO: 
                /* Needed only when validateCP is true */
                MESSAGE "   Password (to be used to validate the incoming C-P): "  m_passwd.
                MESSAGE "   Role: " m_role.
            END.
        END. 
        
    END CONSTRUCTOR.
    
    
    /*------------------------------------------------------------------------------
     Purpose: Returns true if the C-P received in the request is valid, else returns false
     Notes: Uses "password" value configured in spaservice.properties to validate the C-P
    --------------------------------------------------------------------------------- */
    METHOD PROTECTED LOGICAL ValidateClient(  ):
        
        DEFINE VARIABLE result AS LOGICAL NO-UNDO INITIAL FALSE.
        DEFINE VARIABLE hCP AS HANDLE NO-UNDO.
        DEFINE VARIABLE i AS INTEGER NO-UNDO. 

        hCP = SESSION:CURRENT-REQUEST-INFO:GetClientPrincipal().
        IF (? <> hCP) THEN 
        DO:
            MESSAGE "Request contained a C-P".
            result = hCP:VALIDATE-SEAL (m_passwd).
            MESSAGE "Validation with seal: " m_passwd "succeeded".
        END. 
        ELSE
            MESSAGE "Request did not contain a C-P".

        IF result = TRUE THEN 
        DO:
            IF hCP:ROLES <> m_role THEN 
                result = FALSE.
        END.    
        
        RETURN result.

    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: Returns the attribute value of a user
     Notes: 
     INPUT : theUserId - positive user number
                       - In this example it corresponds to _User._User_number.
             attrName  - String name for an attribute to be fetched 
                       - Refer to OERealmDefs for the attribute name that this
                         sample supports
     Throws: 
     Progress.Lang.AppError("Unauthorized client", 1).
     Progress.Lang.AppError("Invalid User Id")             
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC CHARACTER GetAttribute( INPUT theUserId AS INTEGER, INPUT attrName AS CHARACTER ):
        
        DEFINE VARIABLE retVal AS CHARACTER NO-UNDO.
        DEFINE VARIABLE fqUserid    AS CHARACTER NO-UNDO.
        
        IF m_validateCP THEN DO:
            IF THIS-OBJECT:ValidateClient() = FALSE THEN
                UNDO, THROW NEW Progress.Lang.AppError("Unauthorized client", 1).
        END.
        
        IF m_debugMsg THEN 
            MESSAGE "Attempting to get Attribute " attrName " for user number " theUserId.
        FIND FIRST _User WHERE _User._User_number = theUserId NO-ERROR.
        IF AVAILABLE _User THEN DO:
            IF ( _User._Domain-Name = "" ) THEN
                fqUserid = _User._Userid.
            ELSE
                fqUserid = _User._Userid + "@" + _User._Domain-Name.
                
            CASE attrName:
                WHEN OERealmDefs:REALM_ATTR_SURNAME THEN
                    retVal = _User._Surname.
                WHEN OERealmDefs:REALM_ATTR_GIVENNAME THEN 
                    retVal = _User._Given_name.
                WHEN OERealmDefs:REALM_ATTR_TELEPHONE THEN 
                    retVal = _User._Telephone.
                WHEN OERealmDefs:REALM_ATTR_EMAIL THEN 
                    retVal = _User._Email.
                WHEN OERealmDefs:REALM_ATTR_DESCRIPTION THEN 
                    retVal = _User._Description.
                WHEN OERealmDefs:REALM_ATTR_USERID THEN
                    retVal = fqUserid.
                WHEN OERealmDefs:REALM_ATTR_DOMAIN THEN
                    retVal = _User._Domain-Name.
                WHEN OERealmDefs:REALM_ATTR_ENABLED THEN DO:
                    IF ( ? = _User._Disabled OR _User._Disabled = NO ) THEN
                       retVal = "1".      /* Enabled */
                    ELSE
                       retVal = "0".     /* !Enabled */
                END.
                WHEN OERealmDefs:REALM_ATTR_ROLES THEN DO:
                    DEFINE VARIABLE roles   AS CHARACTER NO-UNDO. 
                    DEFINE VARIABLE count   AS  INTEGER INITIAL 0 NO-UNDO. 

                    IF m_debugMsg THEN
                        MESSAGE "Get user roles for user number " theUserId "(" fqUserid ")".
                    roles = ?.
                    FOR EACH _sec-granted-role WHERE _sec-granted-role._grantee = fqUserid :
                        IF ( count = 0 ) THEN
                            roles = "".
                        ELSE
                            roles = roles + ",".
                        roles = roles + _sec-granted-role._Role-name.
                        count = count + 1.
                    END.
                    IF m_debugMsg THEN
                        MESSAGE "Found '" roles "' roles for user-id" theUserId "(" fqUserid ")".
                    retVal = roles.
                END.
                OTHERWISE DO:
                    IF m_debugMsg THEN
                        MESSAGE "Unknown attribute name in GetAttribute:" attrName.
                    retVal = ?.
                END.
            END.
        END.
        ELSE DO:
            IF m_debugMsg THEN
                MESSAGE "Unknown user-id found in GetAttribute:" theUserId.  
            UNDO, THROW NEW Progress.Lang.AppError("Invalid User Id").
        END.
        
        RELEASE _User.
        IF m_debugMsg THEN 
            MESSAGE "Returning " retVal " for attribute value".
        RETURN retVal.
        
    END METHOD.
    
    /*------------------------------------------------------------------------------
     Purpose:Returns all the attributes defined for a user as a comma separeted list
     Notes: 
     INPUT : theUserId - positive user number
                       - In this example it corresponds to _User._User_number.
     Throws: 
     Progress.Lang.AppError("Unauthorized client", 1).
     Progress.Lang.AppError("User not found"). 
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC CHARACTER EXTENT GetAttributeNames( INPUT theUserId AS INTEGER ):
        
        DEFINE VARIABLE results AS CHARACTER EXTENT NO-UNDO.
        DEFINE VARIABLE attrNames AS CHARACTER EXTENT 10 NO-UNDO.
        DEFINE VARIABLE attrVal AS CHARACTER NO-UNDO.
        DEFINE VARIABLE numAttrs AS INTEGER NO-UNDO INITIAL 0.
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        DEFINE VARIABLE fqUserid    AS CHARACTER NO-UNDO. 
        
        IF m_validateCP THEN DO:
            IF THIS-OBJECT:ValidateClient() = FALSE THEN
                UNDO, THROW NEW Progress.Lang.AppError("Unauthorized client", 1).
        END.
        IF m_debugMsg THEN 
            MESSAGE "Getting attributes for user number " theUserId.
        FIND FIRST _User WHERE _User._User_number = theUserId NO-ERROR.
        IF AVAILABLE _User THEN DO:
            IF ( _User._Domain-Name = "" ) THEN
                fqUserid = _User._Userid.
            ELSE
                fqUserid = _User._Userid + "@" + _User._Domain-Name.
                
            /* Check to see what attributes have values */
            attrVal = _User._Surname.
            IF attrVal <> ? THEN DO:
                 numAttrs = numAttrs + 1.
                 attrNames[numAttrs] = OERealmDefs:REALM_ATTR_SURNAME.
            END.
            attrVal = _User._Given_name.
            IF attrVal <> ? THEN DO:
                numAttrs = numAttrs + 1.
                 attrNames[numAttrs] = OERealmDefs:REALM_ATTR_GIVENNAME.
            END.
            attrVal = _User._Telephone.
            IF attrVal <> ? THEN DO:
                numAttrs = numAttrs + 1.
                 attrNames[numAttrs] = OERealmDefs:REALM_ATTR_TELEPHONE.
            END.
            attrVal = _User._Email.
            IF attrVal <> ? THEN DO:
                numAttrs = numAttrs + 1.
                 attrNames[numAttrs] = OERealmDefs:REALM_ATTR_EMAIL.
            END.
            attrVal = _User._Description.
            IF attrVal <> ? THEN DO:
                numAttrs = numAttrs + 1.
                 attrNames[numAttrs] = OERealmDefs:REALM_ATTR_DESCRIPTION.
            END.
            attrVal = _User._Userid.
            IF attrVal <> ? THEN DO:
               numAttrs = numAttrs + 1.
                 attrNames[numAttrs] = OERealmDefs:REALM_ATTR_USERID.
            END.
            attrVal = _User._Domain-Name.
            IF attrVal <> ? THEN DO:
               numAttrs = numAttrs + 1.
                 attrNames[numAttrs] = OERealmDefs:REALM_ATTR_DOMAIN.
            END.
            DO:
                FIND FIRST _sec-granted-role WHERE _sec-granted-role._grantee = fqUserid NO-ERROR.
                IF AVAILABLE _sec-granted-role THEN DO:
                    numAttrs = numAttrs + 1.
                    attrNames[numAttrs] = OERealmDefs:REALM_ATTR_ROLES.
                END.
            END.
            
            IF numAttrs > 0 THEN DO:
                IF m_debugMsg THEN 
                    MESSAGE "Number of attribute names: " numAttrs.
                EXTENT(results) = numAttrs.
                DO i = 1 TO numAttrs:
                    results[i] = attrNames[i].
                    IF m_debugMsg THEN 
                        MESSAGE results[i].
                END.
            END.
        END.
        ELSE   
            UNDO, THROW NEW Progress.Lang.AppError("User not found").
        RELEASE _User.
        RETURN results.
        
    END METHOD.
    /*------------------------------------------------------------------------------
     Purpose:Returns all the user names as character extent
     Notes: 
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC CHARACTER EXTENT GetUserNames(  ):
        
        DEFINE VARIABLE results AS CHARACTER EXTENT NO-UNDO.
        DEFINE VARIABLE num AS INTEGER NO-UNDO INITIAL 0.
        
        IF m_validateCP THEN DO:
            IF THIS-OBJECT:ValidateClient() = FALSE THEN
                UNDO, THROW NEW Progress.Lang.AppError("Unauthorized client", 1).
        END.
            
        /* First count the names */
        FOR EACH _User:
            num = num + 1.
        END. 
        
        EXTENT(results) = num.
        num = 1.
        FOR EACH _User:
            IF ( _User._Domain-Name = "" ) THEN
                results[num] = _User._Userid.
            ELSE
                results[num] = _User._Userid + "@" + _User._Domain-Name.
            num = num + 1.
        END.
        
        RELEASE _User.
        RETURN results.

    END METHOD.
    
    /*------------------------------------------------------------------------------
     Purpose: Returns the fully qualified usernames a matching a query pattern
     Notes: 
     INPUT : queryString - character value which against which the userid should be matched
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC CHARACTER EXTENT GetUserNamesByQuery( INPUT queryString AS CHARACTER ):
        
        DEFINE VARIABLE results AS CHARACTER EXTENT NO-UNDO.
        DEFINE VARIABLE num AS INTEGER NO-UNDO INITIAL 0.
        
        IF m_validateCP THEN DO:
            IF THIS-OBJECT:ValidateClient() = FALSE THEN
                UNDO, THROW NEW Progress.Lang.AppError("Unauthorized client", 1).
        END.
        
        IF m_debugMsg THEN 
            MESSAGE "QueryString = " queryString. 
            
        /* First count the names */
        FOR EACH _User WHERE _User._Userid MATCHES queryString:
            IF m_debugMsg THEN 
                MESSAGE "Match: " _User._Userid + "@" + _User._Domain-Name.
            num = num + 1.
        END. 
        
        IF num = 0 THEN DO:
            IF m_debugMsg THEN 
                MESSAGE "No users found".
            RETURN results.
        END.
        
        EXTENT(results) = num.
        num = 0.
        FOR EACH _User WHERE _User._Userid MATCHES queryString:
            num = num + 1.
            IF ( _User._Domain-Name = "" ) THEN
                results[num] = _User._Userid.
            ELSE
                results[num] = _User._Userid + "@" + _User._Domain-Name.
        END.
        IF m_debugMsg THEN 
            MESSAGE "Found " num " users".
        
        RELEASE _User.
        RETURN results.
        

    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: Returns the fully qualified usernames whose attributes match 
     Notes: 
     INPUT : attrName  - character value representing the attribute name
             attrValue - character value representing the attribute value
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC CHARACTER EXTENT GetUserNamesByQuery( INPUT attrName AS CHARACTER, INPUT attrValue AS CHARACTER ):
        
        DEFINE VARIABLE results AS CHARACTER EXTENT NO-UNDO.
        DEFINE VARIABLE temp AS CHARACTER EXTENT 100 NO-UNDO.
        DEFINE VARIABLE num AS INTEGER NO-UNDO INITIAL 0.
        DEFINE VARIABLE whichAttr AS CHARACTER NO-UNDO.
        DEFINE VARIABLE attrCounter AS INTEGER NO-UNDO.
        
        IF m_validateCP THEN DO:
            IF THIS-OBJECT:ValidateClient() = FALSE THEN
                UNDO, THROW NEW Progress.Lang.AppError("Unauthorized client", 1).
        END.
        
        IF m_debugMsg THEN 
            MESSAGE "Attribute name: " attrName " Attribute value: " attrValue.
        
        /* First count the names */
        FOR EACH _User:
            CASE whichAttr:
                WHEN OERealmDefs:REALM_ATTR_SURNAME THEN
                    IF _User._Surname MATCHES attrValue THEN DO:
                        IF m_debugMsg THEN 
                            MESSAGE "Match: " _User._Userid + "@" + _User._Domain-Name.
                        num = num + 1.
                        IF ( _User._Domain-Name = "" ) THEN
                            results[num] = _User._Userid.
                        ELSE
                            temp[num] = _User._Userid + "@" + _User._Domain-Name.
                    END.
                WHEN OERealmDefs:REALM_ATTR_GIVENNAME THEN 
                    IF _User._Given_name MATCHES attrValue THEN DO:
                        IF m_debugMsg THEN 
                            MESSAGE "Match: " _User._Userid + "@" + _User._Domain-Name.
                        num = num + 1.
                        IF ( _User._Domain-Name = "" ) THEN
                            results[num] = _User._Userid.
                        ELSE
                            temp[num] = _User._Userid + "@" + _User._Domain-Name.
                    END.
                WHEN OERealmDefs:REALM_ATTR_TELEPHONE THEN 
                    IF _User._Telephone MATCHES attrValue THEN DO:
                        IF m_debugMsg THEN 
                            MESSAGE "Match: " _User._Userid + "@" + _User._Domain-Name.
                        num = num + 1.
                        IF ( _User._Domain-Name = "" ) THEN
                            results[num] = _User._Userid.
                        ELSE
                            temp[num] = _User._Userid + "@" + _User._Domain-Name.
                    END.
                WHEN OERealmDefs:REALM_ATTR_EMAIL THEN 
                    IF _User._Email MATCHES attrValue THEN DO:
                        IF m_debugMsg THEN 
                            MESSAGE "Match: " _User._Userid.
                        num = num + 1.
                        IF ( _User._Domain-Name = "" ) THEN
                            results[num] = _User._Userid.
                        ELSE
                            temp[num] = _User._Userid + "@" + _User._Domain-Name.
                    END.
                WHEN OERealmDefs:REALM_ATTR_DESCRIPTION THEN 
                    IF _User._Description MATCHES attrValue THEN DO:
                        IF m_debugMsg THEN 
                            MESSAGE "Match: " _User._Userid + "@" + _User._Domain-Name.
                        num = num + 1.
                        IF ( _User._Domain-Name = "" ) THEN
                            results[num] = _User._Userid.
                        ELSE
                            temp[num] = _User._Userid + "@" + _User._Domain-Name.
                    END.
            END.
        END. 
        
        IF num = 0 THEN DO:
            IF m_debugMsg THEN 
                MESSAGE "No users found".
            RETURN results.
        END.
        
        EXTENT(results) = num.
        DO attrCounter = 1 TO num:
            results[attrCounter] = temp[attrCounter].
        END.
        IF m_debugMsg THEN 
            MESSAGE "Found " num " users".
        
        RELEASE _User.
        RETURN results.
        

    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: Removes an attribute from User account based on unique user number
     Notes: 
     INPUT : theUserId - positive user number
                       - In this example it corresponds to _User._User_number.
             attrName  - String representing the attribute name to be removed
                       - Refer to OERealmDefs for the attribute name that this
                         sample supports
     Throws: 
     Progress.Lang.AppError("Unauthorized client", 1).
     Progress.Lang.AppError("Invalid User Id").            
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL RemoveAttribute( INPUT theUserId AS INTEGER, INPUT attrName AS CHARACTER ):
        
        DEFINE VARIABLE retVal AS LOGICAL NO-UNDO INITIAL TRUE.
        
        IF m_validateCP THEN DO:
            IF THIS-OBJECT:ValidateClient() = FALSE THEN
                UNDO, THROW NEW Progress.Lang.AppError("Unauthorized client", 1).
        END.
        
        IF m_debugMsg THEN 
            MESSAGE "Attempting to remove Attribute " attrName " for user number " theUserId.
        FIND FIRST _User WHERE _User._User_number = theUserId NO-ERROR.
        IF AVAILABLE _User THEN DO:
            CASE attrName:
                WHEN OERealmDefs:REALM_ATTR_SURNAME THEN
                    _User._Surname = ?.
                WHEN OERealmDefs:REALM_ATTR_GIVENNAME THEN 
                    _User._Given_name = ?.
                WHEN OERealmDefs:REALM_ATTR_TELEPHONE THEN 
                    _User._Telephone = ?.
                WHEN OERealmDefs:REALM_ATTR_EMAIL THEN 
                    _User._Email = ?.
                WHEN OERealmDefs:REALM_ATTR_DESCRIPTION THEN 
                    _User._Description = ?.
                OTHERWISE DO:
                    retVal = FALSE.
                    RELEASE _User.
                END.
            END.
        END.
        ELSE   
            UNDO, THROW NEW Progress.Lang.AppError("Invalid User Id").

        RELEASE _User.
        RETURN retVal.

    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: Sets an attribute value for a user
     value
     Notes: 
     INPUT : theUserId - positive user number
                       - In this example it corresponds to _User._User_number.
             attrName  - String representing the attribute name to be removed
                       - Refer to OERealmDefs for the attribute name that this
                         sample supports
             attrValue - value of an attribute
     Throws: 
     Progress.Lang.AppError("Unauthorized client", 1).
     Progress.Lang.AppError("Invalid User Id").          
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL SetAttribute( INPUT theUserId AS INTEGER, INPUT attrName AS CHARACTER, INPUT attrValue AS CHARACTER ):
        
        DEFINE VARIABLE retVal AS LOGICAL NO-UNDO INITIAL TRUE.
        
        IF m_validateCP THEN DO:
            IF THIS-OBJECT:ValidateClient() = FALSE THEN
                UNDO, THROW NEW Progress.Lang.AppError("Unauthorized client", 1).
        END.
        
        IF m_debugMsg THEN 
            MESSAGE "Attempting to set Attribute " attrName " for user number " theUserId " with a value of " attrValue.
        FIND FIRST _User WHERE _User._User_number = theUserId NO-ERROR.
        IF AVAILABLE _User THEN DO:
            CASE attrName:
                WHEN OERealmDefs:REALM_ATTR_SURNAME THEN
                    _User._Surname = attrValue.
                WHEN OERealmDefs:REALM_ATTR_GIVENNAME THEN 
                    _User._Given_name = attrValue.
                WHEN OERealmDefs:REALM_ATTR_TELEPHONE THEN 
                    _User._Telephone = attrValue.
                WHEN OERealmDefs:REALM_ATTR_EMAIL THEN 
                    _User._Email = attrValue.
                WHEN OERealmDefs:REALM_ATTR_DESCRIPTION THEN 
                    _User._Description = attrValue.
                WHEN OERealmDefs:REALM_ATTR_PASSWD THEN DO:
                    MESSAGE "Attempting to set Attribute " attrName " for user number " theUserId " with a value of " attrValue.
                    FIND FIRST _User WHERE _User._User_number = theUserId NO-ERROR.
                    IF AVAILABLE _user THEN DO:
                       BUFFER-COPY _user to ttUser.
                       ttUser._password = ENCODE(attrValue).
                       DELETE _User.
                      BUFFER-COPY ttUser EXCEPT _TenantId TO _User.
                       RELEASE _User.
                       MESSAGE "Successfully  changed password for user with id " theUserId. 
                       RETURN true.
                    END.
                    ELSE DO:
                        MESSAGE "User " theUserId " not found".
                        RETURN false.
                    END. 
                END.                
                OTHERWISE DO:
                    retVal = FALSE.
                    RELEASE _User.
                END.
            END.
        END.
        ELSE   
            UNDO, THROW NEW Progress.Lang.AppError("Invalid User Id").

        RELEASE _User.
        RETURN retVal.

    END METHOD.
    
     /*------------------------------------------------------------------------------
     Purpose: Sets an password for a given user
     Notes: 
     INPUT : theUserId - positive user number
                       - In this example it corresponds to _User._User_number.
             password  - String value to be set as the password
     The incoming request must contain a C-P to perform this operation   
     Throws: 
     Progress.Lang.AppError("Unauthorized client", 1).
     Progress.Lang.AppError("Invalid User Id").             
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL SetAttribute( INPUT theUserId AS INTEGER,  INPUT password AS CHARACTER ):
        
        DEFINE VARIABLE retVal AS LOGICAL NO-UNDO INITIAL TRUE.
        
        IF THIS-OBJECT:ValidateClient() = FALSE THEN
            UNDO, THROW NEW Progress.Lang.AppError("Unauthorized client", 1).
        
        IF m_debugMsg THEN 
            MESSAGE "Attempting to set password for user number " theUserId " with a value of xxxx".
        FIND FIRST _User WHERE _User._User_number = theUserId NO-ERROR.
        IF AVAILABLE _User THEN 
        DO:
            _User._Password = Encode(password).
        END.
        ELSE   
            UNDO, THROW NEW Progress.Lang.AppError("Invalid User Id").

        RELEASE _User.
        RETURN retVal.

    END METHOD.
   


    /*------------------------------------------------------------------------------
     Purpose: validate a password for a given user
     Notes: 
     INPUT : theUserId - positive user number
                       - In this example it corresponds to _User._User_number.
             password  - String value to be set as the password
     Throws: 
     Progress.Lang.AppError("Unauthorized client", 1).
     Progress.Lang.AppError("Invalid User Id").           
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL ValidatePassword( INPUT theUserId AS INTEGER, INPUT password AS CHARACTER ):
        
        DEFINE VARIABLE retVal AS LOGICAL NO-UNDO INITIAL FALSE.      
        
        IF m_validateCP THEN DO:
            IF THIS-OBJECT:ValidateClient() = FALSE THEN
                UNDO, THROW NEW Progress.Lang.AppError("Unauthorized client", 1).
        END.
        
        IF m_debugMsg THEN DO:
            MESSAGE "Validate password using basic".
            MESSAGE "Password: " password.
        END.

        FIND FIRST _User WHERE _User._User_number = theUserId NO-ERROR.
        IF AVAILABLE _User THEN DO:
            IF _User._Password = ENCODE(password) THEN 
                retVal = TRUE.
            ELSE
                RETURN FALSE.
        END.
        ELSE   
            UNDO, THROW NEW Progress.Lang.AppError("Invalid User Id").

        RELEASE _User.
        RETURN retVal.
        
    END METHOD.
    
    /*------------------------------------------------------------------------------
     Purpose: validate a password for a given user using digest
     Notes: 
     INPUT : theUserId - positive user number
                       - In this example it corresponds to _User._User_number.
             digest    - String representing the digest value of the password
             nounce    - String representing the nounce
             timestamp - String representing the timestamp.
             
     NOTE: Digest version of ValidatePassword requires that the passwords be 
     stored in such a way that they can be retrieved as clear text. 
     Since, the _password field of _User table stores password in one way 
     encoded format from which the clear-text password cannot be retrieved, 
     therefore, in this sample, we have encrypted the passwords using 
     db/encPwd.p and stored  in _User._U-misc2[1]. 
     The  encrypted passwords stored thus in the _User._U-misc2[1] can be 
     retrieved as clear-text using db/decPwd.p.
     Please note that this is just a sample implementation, you can store the 
     passwords in any other way of your choice such that it can be recovered
     as a clear-text.

     Throws: 
     Progress.Lang.AppError("Unauthorized client", 1).
     Progress.Lang.AppError("User not found").   
     Progress.Lang.AppError("Old timestamp sent").        
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LOGICAL ValidatePassword( INPUT theUserId AS INTEGER, INPUT digest AS CHARACTER, INPUT nonce AS CHARACTER, INPUT timestamp AS CHARACTER ):
        
        DEFINE VARIABLE retVal AS LOGICAL NO-UNDO INITIAL FALSE.
        DEFINE VARIABLE myDigest AS CHARACTER NO-UNDO.
        DEFINE VARIABLE df AS CHARACTER NO-UNDO. 
        DEFINE VARIABLE remoteTS AS DATETIME-TZ NO-UNDO.
        DEFINE VARIABLE dif AS INT64 NO-UNDO.
        DEFINE VARIABLE hash AS RAW NO-UNDO.
        
        DEFINE VARIABLE clrTxtPwd AS CHARACTER NO-UNDO.
        DEFINE VARIABLE userName AS CHARACTER NO-UNDO.
        DEFINE VARIABLE domain AS CHARACTER NO-UNDO.
        
        IF m_validateCP THEN DO:
            IF THIS-OBJECT:ValidateClient() = FALSE THEN
                UNDO, THROW NEW Progress.Lang.AppError("Unauthorized client", 1).
        END.
        
        FIND FIRST _User WHERE _User._User_number = theUserId NO-ERROR.
        IF AVAILABLE _User THEN DO:
           userName = _User._Userid.
           IF (_User._Domain-name <> '') THEN
              userName = userName + "@" + _User._Domain-name.
           IF m_debugMsg THEN 
              MESSAGE "Decoding password for " userName.              
           IF (_User._U-misc2[1] <> ? ) THEN 
               run db/decPwd.p (userName, _User._U-misc2[1], output clrTxtPwd ).
           ELSE
           DO:
               MESSAGE "Encrypted password not stored in _U-misc2[1] " .
               /* Since encypted password is not stored in _U-misc2[1]
               thus assuming that _Password stores clear-text password 
               which should ideally not be the case */
               clrTxtPwd = _User._Password.
           END.
        END.
        ELSE 
          UNDO, THROW NEW Progress.Lang.AppError("User not found").

        RELEASE _User.
        
        IF m_debugMsg THEN DO: 
            MESSAGE "Validate password using digest".
            MESSAGE "Digest: " digest.
            MESSAGE "Nonce: " nonce.
            MESSAGE "Timestamp: " timestamp.
        END.
        
        df = SESSION:DATE-FORMAT.
        SESSION:DATE-FORMAT = "ymd".
        remoteTS = DATETIME-TZ(timestamp).
        SESSION:DATE-FORMAT = df.
        
        dif = ABSOLUTE(INTERVAL(NOW, remoteTS, "seconds")).
        
        IF dif > 1 THEN
          UNDO, THROW NEW Progress.Lang.AppError("Old timestamp sent").

        myDigest = clrTxtPwd + nonce + timestamp.
        hash = SHA1-DIGEST(myDigest).
        myDigest = BASE64-ENCODE(hash).
        IF m_debugMsg THEN 
            MESSAGE "Computed digest: " myDigest.
        IF myDigest = digest THEN 
            retVal = TRUE.
        ELSE
            retVal = FALSE.
        RETURN retVal.
        
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: validate if the given user exists and if it exists returns the user number
     Notes: 
     INPUT : userName - Fully qualified user name
     Throws: 
     Progress.Lang.AppError("Unauthorized client", 1).
     Progress.Lang.AppError("User not found", 8).
     Progress.Lang.AppError("User number unknown for the user " + userName).
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC INTEGER ValidateUser( INPUT userName AS CHARACTER ):
        
        DEFINE VARIABLE userNum AS INTEGER NO-UNDO.
        DEFINE VARIABLE usernm  AS CHARACTER INITIAL "" NO-UNDO. 
        DEFINE VARIABLE domain  AS CHARACTER INITIAL "" NO-UNDO. 
        usernm = ENTRY(1,userName,"@").
        domain = ENTRY(2,userName,"@") NO-ERROR.
        
        IF m_debugMsg THEN 
            MESSAGE "Validating user " + userName.

        IF m_validateCP THEN DO:       
            IF THIS-OBJECT:ValidateClient() = FALSE THEN
                UNDO, THROW NEW Progress.Lang.AppError("Unauthorized client", 1).
        END.
        FIND FIRST _User WHERE _User._Userid = usernm AND  
                               _User._Domain-Name = domain AND 
                               _User._sql-only-user = NO NO-ERROR.
        IF AVAILABLE _User THEN DO:
            userNum = _User._User_number.
            IF ( ? = userNum AND m_autoUserNum ) THEN DO:
                IF m_debugMsg THEN 
                    MESSAGE "User number unknown for the user " + userName.
                
                /* NOTE: In this sample we throw 
                 * Progress.Lang.AppError("User number unknown for the user " + userName)
                 * when the userNum is UNKNOWN. You may choose not to throw an error and
                 * instead assign a unique numeric number while validating the user. For 
                 * this, uncomment the below code to assign a unique id by using a
                 * Sequence named Next-User-Num. */
                /*
                DEFINE VARIABLE newUserNum      AS INTEGER  NO-UNDO. 
                newUserNum = NEXT-VALUE( Next-User-Num ).
                MESSAGE "Lookup user account issued user" userName "ID number" newUserNum.
                assign _User._User_number = newUserNum.
                userNum = _User._User_number.
                */
                UNDO, THROW NEW Progress.Lang.AppError("User number unknown for the user " + userName).
            END.
            IF m_debugMsg THEN 
                MESSAGE "Returning user num " + STRING(userNum) + " for user " + userName.
            RELEASE _User.
            RETURN userNum.
        END.
        ELSE   
          UNDO, THROW NEW Progress.Lang.AppError("User not found", 8).
    END METHOD.

END CLASS.