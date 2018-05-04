/**
 * Copyright 2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.progress.kinvey.samples.android.push;

import android.content.BroadcastReceiver;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.kinvey.android.Client;
import com.kinvey.android.store.UserStore;
import com.kinvey.java.core.KinveyClientCallback;
import com.progress.kinvey.samples.android.push.R;

public class MainActivity extends AppCompatActivity {

    public Client mKinveyClient = null;
    public static final String TAG = "KINVEY-MAIN-ACTIVITY";
    private TextView tvHello;
    private Button btnLogout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        btnLogout = (Button)findViewById(R.id.btnLogout);

        try {
            mKinveyClient = ((App) getApplication()).getKinveyService();
        } catch ( Exception e ) {
            e.printStackTrace();
        }

        tvHello = (TextView) findViewById(R.id.tvHello);
        tvHello.setVisibility(View.INVISIBLE);
        btnLogout.setVisibility(View.INVISIBLE);
        if ( mKinveyClient != null ){
            if ( mKinveyClient.isUserLoggedIn() ) {
                tvHello.setText("Hello! " + mKinveyClient.getActiveUser().getUsername() + " You are logged in!");
                tvHello.setVisibility(View.VISIBLE);
                mKinveyClient.push(GCMService.class).initialize(getApplication());
                btnLogout.setVisibility(View.VISIBLE);
            } else {
                Intent intent = new Intent(MainActivity.this, LoginActivity.class);
                startActivity(intent);
            }
        }
    }

    public void logout(View view) {
        logout(mKinveyClient);
    }

    public void logout(Client kinveyClient){
        UserStore.logout(kinveyClient, new KinveyClientCallback<Void>() {
            @Override
            public void onSuccess(Void aVoid) {
                Log.i(TAG, "Logout successful");
                Intent intent = new Intent(MainActivity.this, LoginActivity.class);
                startActivity(intent);
            }

            @Override
            public void onFailure(Throwable throwable) {
                Log.i(TAG, "Logout failed", throwable);
            }
        });
    }

}
