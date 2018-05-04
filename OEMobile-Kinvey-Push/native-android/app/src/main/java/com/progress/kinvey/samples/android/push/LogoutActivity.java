package com.progress.kinvey.samples.android.push;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.kinvey.android.Client;
import com.kinvey.android.store.UserStore;
import com.kinvey.java.core.KinveyClientCallback;

/**
 * Created by htirunag on 2/16/2018.
 */

public class LogoutActivity extends AppCompatActivity {

    protected TextView mMessage;
    protected Button mButtonLogout;

    protected Client kinveyClient;
    public static final String TAG = LogoutActivity.class.getSimpleName();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notifcations);

        if ( kinveyClient == null ) {
            kinveyClient = ((App) getApplication()).getKinveyService();
        }

        mMessage = (TextView) findViewById(R.id.tvMessage);
        mMessage.setText("Welcome! " + kinveyClient.getActiveUser().getUsername());
        mButtonLogout = (Button) findViewById(R.id.btnLogout);
    }

    /**
     * Method to handle Logout button clicks.
     */
    public void logout(View view) {
        logout(kinveyClient);
    }

    public void logout(Client kinveyClient){
        UserStore.logout(kinveyClient, new KinveyClientCallback<Void>() {
            @Override
            public void onSuccess(Void aVoid) {
                Log.i(TAG, "Logout successful");
            }

            @Override
            public void onFailure(Throwable throwable) {
                Log.i(TAG, "Logout failed", throwable);
            }
        });
        LogoutActivity.this.startActivity(new Intent(LogoutActivity.this, MainActivity.class));
        LogoutActivity.this.finish();
    }

}