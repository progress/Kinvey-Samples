function onRequest(request, response, modules) {
    var push = modules.push,
        collectionAccess = modules.collectionAccess;
    var userCollection = collectionAccess.collection('user');
    var logger = modules.logger;

    var from = request.body.hasOwnProperty('from');
    var title = request.body.hasOwnProperty('title');
    var body = request.body.hasOwnProperty('body');
    var data = request.body.hasOwnProperty('data');
    var count = request.body.hasOwnProperty('count');
    var notificationPayload;

    var iOSAps = { alert: title, badge: count, sound: 'default' };
    var iOSExtras = { title: title, body: body };

    function buildMessage() {
        var notificationData = data;
        var nativeMsg = { "title": title, "from": from, "body": body };
        notificationData.msg = nativeMsg;

        var payload = {
            "_rawPayload": {
                "notification": {
                    "title": title,
                    "from": from,
                    "body": body
                },
                "data": notificationData
            }
        };
        return payload;
    }


    if (request.body.hasOwnProperty('id')) {
        var ids = request.body.id;
        logger.info('Sending push notification to [ ' + ids.length + ' ] users');
        for (var i = 0; i < ids.length; i++) {
            userCollection.findOne({ "_id": collectionAccess.objectID(ids[i]) }, function(err, user) {
                if (err) {
                    logger.error('Query failed: ' + err);
                } else {
                    notificationPayload = buildMessage();
                    logger.info("Android Payload : " + JSON.stringify(notificationPayload));
                    logger.info("IOS Payload : " + JSON.stringify(iOSAps));
                    push.sendPayload(user, iOSAps, iOSExtras, notificationPayload, function(err, result) {
                        logger.info('Payload result: ' + JSON.stringify(result));
                        logger.info('Payload error: ' + JSON.stringify(err));
                    });
                }
            });
        }
        logger.info('LOG');
        response.complete();
    } else {
        notificationPayload = buildMessage();
        logger.info(JSON.stringify(notificationPayload));
        push.broadcastPayload(iOSAps, iOSExtras, notificationPayload, function(err, result) {
            logger.info('Payload result: ' + JSON.stringify(result));
            logger.info('Payload error: ' + JSON.stringify(err));
        });
        response.complete();
    }
}