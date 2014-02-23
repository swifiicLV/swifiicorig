package swifiic.suta;

import in.swifiic.android.app.lib.Helper;
import in.swifiic.android.app.lib.ui.SwifiicActivity;
import in.swifiic.android.app.lib.xml.Notification;
import swifiic.suta.provider.Provider;
import android.os.Bundle;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

public class MainActivity extends SwifiicActivity {

    private final String TAG="SUTA-MainAct";
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    	mDataReceiver= new BroadcastReceiver() {  // this is a must for all applications - hook to get notification from GenericService
            @Override
            public void onReceive(Context context, Intent intent) {
                if (intent.hasExtra("notification")) {
                	String message= intent.getStringExtra("notification");
                	
                    Log.d("MAIN", "TBD XXX -  handle incoming messages" + message);
                    Notification notif = Helper.parseNotification(message);
                    handleNotification(notif);
                } else {
                    Log.d(TAG, "Broadcast Receiver ignoring message - no notification found");
                }
            }
        };
        
    }
    
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int itemId = item.getItemId();
		if (itemId == R.id.settings) {
			Intent selectedSettings = new Intent(this, SettingsActivity.class);
			startActivity(selectedSettings);
			return true;
		}
		else {
			return super.onOptionsItemSelected(item);
		}
    }

    //private AppEndpointContext aeCtx = new AppEndpointContext("Messenger", "0.1", "1");

    protected void handleNotification(Notification notif){
    	// TODO if(notif.getNotificationName().equals("SyncToDevice")) { }
    	// we need these arguments

    	// lastSyncToHubReceivedAtHub
    	// lastMessageReceivedAtHub
    	// lastBillingDetails - free string ...
    	// balance / credit
    	// userAppListLastChangeTimestamp on appHub
    	
    	// userList <u name="" id="" alias="" />...
    	// appList  <app name="" id="" alias=""> <role alias=""> <u id="" /> ... </role> <role...> </app>
    	
    	
    	// Above was the grand goal - now simple impl
    	// userList "name|id|alias;name|id|alias;..."
    	// appList  "appName|appId|appAlias|role1Alias:usrId:usrId:usrId|role2alias:...;
    	
    	String userList = notif.getArgument("userList");
    	String appList = notif.getArgument("appList");
    	if(null == Provider.providerInstance){
    		Log.e(TAG,"No Provider - whatsup...");
    	} else {
    		Provider.providerInstance.loadSchema(userList, appList);
    	}
    	
    }


	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
}
