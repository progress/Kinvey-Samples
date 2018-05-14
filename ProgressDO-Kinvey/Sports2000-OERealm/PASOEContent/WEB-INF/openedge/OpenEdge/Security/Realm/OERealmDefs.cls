/*------------------------------------------------------------------------
    File        : OERealmDefs
    Purpose     : Hold static attribute name and other definitions for
                : use by the OERealm service
    Syntax      : 
    Description : Defines the Realm attribute names that the OE Realm clients
                  will use to query a user attribute
                  For e.g. REST as OE Realm Client uses ATTR_ROLES to query
                  the roles of a user. BPM uses "firstname" to query first name
                  of the user. This file contains default attribute names used
                  by REST, Rollbase and OEBPM. 
    Author(s)   : Progress Software Corporation
    Created     : Thursday July 23 10:41:36 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.Security.Realm.OERealmDefs  :

    /* OpenEdge _User table attributes */
    /* Modify the INITIAL values of properties REALM_ATTR_XXX according to the name of the realm attribute name you want */

    /* Default attribute names for REST and Rollbase */
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_ROLES AS CHARACTER INITIAL "ATTR_ROLES" NO-UNDO GET.
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_ENABLED AS CHARACTER INITIAL "ATTR_ENABLED" NO-UNDO GET.
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_EXPIRED AS CHARACTER INITIAL "ATTR_EXPIRED" NO-UNDO GET.
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_LOCKED AS CHARACTER INITIAL "ATTR_LOCKED" NO-UNDO GET.
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_PASSWD AS CHARACTER INITIAL "ATTR_PASSWORD" NO-UNDO GET.
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_DOMAIN AS CHARACTER INITIAL "ATTR_DOMAIN" NO-UNDO GET.
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_PROPERTIES AS CHARACTER INITIAL "ATTR_PROPERTIES" NO-UNDO GET.
    
    /* Default attribute names for BPM */
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_USERID AS CHARACTER INITIAL "userid" NO-UNDO GET.
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_GIVENNAME AS CHARACTER INITIAL "firstname" NO-UNDO GET.
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_MIDDLEINITIAL AS CHARACTER INITIAL "middlename" NO-UNDO GET.
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_SURNAME AS CHARACTER INITIAL "lastname" NO-UNDO GET.
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_TELEPHONE AS CHARACTER INITIAL "phone" NO-UNDO GET.
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_EMAIL AS CHARACTER INITIAL "email" NO-UNDO GET.
    DEFINE PUBLIC STATIC PROPERTY REALM_ATTR_DESCRIPTION AS CHARACTER INITIAL "description" NO-UNDO GET.

    /*------------------------------------------------------------------------------
        Purpose: Default Constructor                                                                       
        Notes:                                                                        
    ------------------------------------------------------------------------------*/

    CONSTRUCTOR PUBLIC OERealmDefs(  ):
         SUPER ().

    END CONSTRUCTOR.

END CLASS.

