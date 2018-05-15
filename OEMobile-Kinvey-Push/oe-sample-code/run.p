
/*------------------------------------------------------------------------
    File        : custom2.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Mon Feb 19 12:44:46 IST 2018
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE VARIABLE temp AS CHARACTER NO-UNDO.

// Call the Kinvey Custom Endpoint 
request = '~{~"id": ["5ab0bea45ccb1510e9e57494"], "title": "OE Push Notification", "body": "OE Notification body!", "from": "OE Endpoint", "message":"Welcome to OE World"~}'.
RUN push-notification.p(INPUT request).
