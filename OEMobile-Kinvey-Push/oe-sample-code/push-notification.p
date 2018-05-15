/*********************************************************************************
  Program:  mobilenotification.p
  Purpose:  Calls kinvey baas api to send mobile notification
  Programmer:  rsankar
  Date:        15/Nov/2017
  Specification:
**********************************************************************************/
USING OpenEdge.Core.String. 
USING OpenEdge.Net.HTTP.*.
USING OpenEdge.Net.URI.
USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Lang.AppError.
/**********************************************************************************
  DEFINITIONS
*********************************************************************************/
DEFINE INPUT PARAMETER lNotificatonBody AS LONGCHAR NO-UNDO.
DEFINE VARIABLE oClient   AS IHttpClient   NO-UNDO.
DEFINE VARIABLE oURI      AS URI           NO-UNDO.
DEFINE VARIABLE oRequest  AS IHttpRequest  NO-UNDO.
DEFINE VARIABLE oResponse AS IHttpResponse NO-UNDO.
DEFINE VARIABLE vResp     AS CHARACTER     NO-UNDO.  
 
LOG-MANAGER:LOGFILE-NAME = "Listen.log".
 
//{com/oerpm/tkt/listen.i}
/**********************************************************************************
  Main Block 
*********************************************************************************/    
oClient = ClientBuilder:Build():KeepCookies(CookieJarBuilder:Build():CookieJar):Client.
oURI = NEW URI('https','<Kinvey Endpoint>').  
oURI:Path = '/rpc/<Kinvey App Id>/custom/<Kinvey Custom Endpoint Name>'.
LOG-MANAGER:WRITE-MESSAGE("INPUT FOR MOBILE Notification:  " + STRING(lNotificatonBody), "mobile_notification").
oRequest = RequestBuilder:Post(oURI,NEW String(lNotificatonBody))
     :AddHeader('Authorization','<Kinvey User's Basic Authorization Token>')
     :AcceptJson()
     :ContentType('application/json')
/*     :WithData(NEW String(lNotificatonBody))*/
     :Request.
oResponse = ResponseBuilder:Build():Response.
oClient:Execute(oRequest,oResponse).
LOG-MANAGER:WRITE-MESSAGE("Mobile notification Status Code:  " + STRING(oResponse:StatusCode), "mobile_notification").
IF oResponse:StatusCode <> 200 
    THEN
    vResp="Mobile notification Request Error:" + STRING(oResponse:StatusCode).
ELSE 
DO:
    IF TYPE-OF(oResponse:Entity, JsonObject) THEN
        DEFINE VARIABLE resp AS LONGCHAR NO-UNDO.
    CAST(oResponse:Entity, JsonObject):Write(resp, TRUE).
    vResp=STRING(resp).
END.
LOG-MANAGER:WRITE-MESSAGE("Mobile notification response:  " + vResp, "mobile_notification").