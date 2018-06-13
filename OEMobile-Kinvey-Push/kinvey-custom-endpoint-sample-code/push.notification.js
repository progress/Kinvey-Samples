function onRequest(request, response, modules) {
  var logger = modules.logger;
  var push = modules.push;
  var payload = request.body;

  // Checks if JSON object or a property in JSON is empty or not
	function isEmpty(obj) {
		for(var prop in obj) {
			if(obj.hasOwnProperty(prop))
				return false;
		}
		return JSON.stringify(obj) === JSON.stringify({});
	}

  function getPayloadParams(payloadObj) {
    if (isEmpty(payloadObj))
      return null;
    else {
      var payload = {
        isAndroid : payloadObj.hasOwnProperty('Android') ?  true : false,
        isIOS : payloadObj.hasOwnProperty('IOS') ?  true : false,
      }
      return payload;
    }
  }

  function getPlatformObj(payloadObj, platform) {
    if (isEmpty(payloadObj))
      return null;
    else {
      if ( platform == "Android" ) {
        return payloadObj.Android;
      }
      else if ( platform == "IOS" ) {
        return payloadObj.IOS;
      }
    }  
  }

  function getAndroidPayload(payloadObj) {
    if (!isEmpty(payloadObj)) {
      var androidPayload = getPlatformObj(payloadObj, "Android");
      logger.info("Android :" + JSON.stringify(androidPayload));
      if (!isEmpty(androidPayload)) {
        var payload = {
          "_rawPayload" : {}
        }
        var hasNotificationObj = androidPayload.hasOwnProperty('notification') ?  true : false;
        var hasDataObj = androidPayload.hasOwnProperty('data') ?  true : false;
        var notification;
        var data;
        if ( hasNotificationObj && !isEmpty(androidPayload.notification) ) {
          notification = androidPayload.notification;
          payload._rawPayload.notification = notification;
        }  
        if ( hasDataObj && !isEmpty(androidPayload.data) ) {
          data = androidPayload.data;
          payload._rawPayload.data = data;
        }
        // Embed notification title and body in data.msg.
        // This customized payload structure works for Native and Nativescript Android devices
        if (!isEmpty(notification)) {
          var msg = {};
          data = {};
          var hasTitle = notification.hasOwnProperty('title') ?  true : false;
          var hasBody = notification.hasOwnProperty('body') ?  true : false;
          if ( hasTitle )
          	msg.title = notification.title;
          if ( hasBody )
          	msg.body = notification.body;
          data.msg = msg;
          payload._rawPayload.data = data;
        }
        if ( isEmpty(androidPayload.notification) && isEmpty(androidPayload.data) )
          return null;
        return payload;
      }    
    }
    return null;
  }

  function getApsObj(payloadObj) {
    if (!isEmpty(payloadObj)) {
      var iosPayload = getPlatformObj(payloadObj, "IOS");
      if (!isEmpty(iosPayload)) {
        var hasAPSObj = iosPayload.hasOwnProperty('aps') ?  true : false;
        var aps;
        if ( hasAPSObj && !isEmpty(iosPayload.aps) ) {
        aps = iosPayload.aps;
        return aps;
        }
      }
    }
    return null;
  }

  function getExtrasObj(payloadObj) {
    if (!isEmpty(payloadObj)) {
      var iosPayload = getPlatformObj(payloadObj, "IOS");
      if (!isEmpty(iosPayload)) {
        var hasDataObj = iosPayload.hasOwnProperty('data') ?  true : false;
        var data;
        if ( hasDataObj && !isEmpty(iosPayload.data) ) {
        data = iosPayload.data;
        return data;
        }
      }  
    }
    return null;
  }

  var payloadParams = getPayloadParams(payload);

  if ( payloadParams.isAndroid ) {
    var androidPayload = getAndroidPayload(payload);
    logger.info("GCM Payload: " + JSON.stringify(androidPayload));
  }

  if ( payloadParams.isIOS ) {
    var iOSAps = getApsObj(payload);
    var iOSExtras = getExtrasObj(payload);
    logger.info("APNS Payload: " + JSON.stringify(iOSAps));
    logger.info("APNS Payload Extras: " + JSON.stringify(iOSExtras));
  }
	
  if ( payloadParams.isAndroid || payloadParams.isIOS ) {
    push.broadcastPayload(iOSAps, iOSExtras, androidPayload, function(err, result) {
      logger.info('Payload result: ' + JSON.stringify(result));
      logger.info('Payload error: ' + JSON.stringify(err));
    });
  } else {
    logger.info("Android and iOS platforms are only supported.")
  }
	response.complete();
}