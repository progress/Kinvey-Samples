package com.progress.kinvey.samples.android.push;

/**
 * Created by htirunag on 2/15/2018.
 */


import android.app.NotificationManager;
import android.content.Context;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

import com.kinvey.android.push.KinveyGCMService;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class GCMService extends KinveyGCMService {

    @Override
    public void onMessage(String message) {
        displayNotificationMessage(message);
    }
    @Override
    public void onError(String error) {
        Log.i(TAG, error);
        displayNotificationMessage(error);
    }
    @Override
    public void onDelete(String deleted) {
        Log.i(TAG, deleted);
    }
    @Override
    public void onRegistered(String gcmID) {
        Log.i(TAG, gcmID);
    }
    @Override
    public void onUnregistered(String oldID) {
        Log.i(TAG, oldID);
    }
    //This method will return the WakefulBroadcastReceiver class you define in the next step
    public Class getReceiver() {
        return GCMReceiver.class;
    }

    private void displayNotificationMessage(String message){
        System.out.println(message);
        JSONObject msgJsonObj = null;
        String msgContent = null;
        String msgFrom = null;
        String msgSubject = null;
        String contentTitle = null;

        if ( !isJSONValid(message) ) {
            contentTitle = "Push Notification";
            msgContent = message;
        } else {
            try {
                msgJsonObj = new JSONObject(message);
                msgContent = msgJsonObj.get("body").toString();
                msgFrom = msgJsonObj.get("from").toString();
                msgSubject = msgJsonObj.get("title").toString();
                contentTitle = msgFrom + ": " + msgSubject;
            } catch (JSONException je) {
                contentTitle = "Push Notification";
                msgContent = "Internal error!";
                je.printStackTrace();
            }
        }
        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(this)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(contentTitle)
                .setColor(0xff000080)
                .setContentText(msgContent);

        NotificationManager mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        mNotificationManager.notify(1, mBuilder.build());
    }

    public boolean isJSONValid(String string) {
        try {
            new JSONObject(string);
        } catch (JSONException ex) {
            try {
                new JSONArray(string);
            } catch (JSONException ex1) {
                return false;
            }
        }
        return true;
    }
}
