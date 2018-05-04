package com.progress.kinvey.samples.android.push;

import android.support.multidex.MultiDexApplication;
import com.kinvey.android.Client;

/**
 * Created by htirunag on 2/16/2018.
 */

public class App extends MultiDexApplication {

    private Client sharedClient;
    public static final String TAG = "KINVEY-CLIENT";

    @Override
    public void onCreate() {
        super.onCreate();
        sharedClient = new Client.Builder(this.getApplicationContext()).build();
    }

    public Client getKinveyService() {
        return sharedClient;
    }
}

