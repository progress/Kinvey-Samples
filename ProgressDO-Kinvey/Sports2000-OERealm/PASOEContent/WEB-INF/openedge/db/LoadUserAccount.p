/* Loads the .d and .df's to create a user account */
DEF VAR encPwd AS CHAR.

OUTPUT TO LoadUserAccount.out APPEND.
MESSAGE "Loading the user account ".
RUN prodict/load_df.p (INPUT "./db/_seqdefs.df").
RUN prodict/load_seq.p (INPUT "./db/_seqvals.d", INPUT ".").   
RUN prodict/load_d.p (INPUT "_sec-authentication-domain", INPUT "./db/_sec-authentication-domain.d").
RUN prodict/load_d.p (INPUT "_user", INPUT "./db/_user.d").
RUN prodict/load_d.p (INPUT "_sec-role", INPUT "./db/_sec-role.d").
RUN prodict/load_d.p (INPUT "_sec-granted-role", INPUT "./db/_sec-granted-role.d").

/* Encode the clear-text password and store it in _User._U-misc2[1] field using 
   util/encPwd.p so that the clear-text password can be obtained using util/decPwd.p
   in the ValidatePassword (digest) method of the OE Realm Server class */

DEF VAR userName AS CHARACTER.
DEF VAR domain AS CHARACTER.
DEF VAR passwords AS CHARACTER EXTENT 8 INIT
 [ 'password',  'password',  'password',  'password',  'dba1',  'BPSServer',  'RESTClient',  'password' ].
DEF VAR userNum AS INTEGER.
FOR EACH _User:
	if (_User._Domain-name <> '') THEN
		userName = _User._Userid + "@" + _User._Domain-name.
	ELSE
	    userName = _User._Userid .

	if ( _User._User_number <> ? ) THEN DO:
	    MESSAGE "Encrypting password for "  userName.
	    run db/encPwd.p (input userName, passwords[_User._User_number],  output encPwd).
		_User._U-misc2[1] = encPwd.
	END.
	ELSE DO:
	    MESSAGE "User Number was null for " + userName.
	END.
END. 
OUTPUT CLOSE.