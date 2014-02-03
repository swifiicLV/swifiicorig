package in.swifiic.android.app.msngr;


import in.swifiic.android.app.lib.AppEndpointContext;
import in.swifiic.android.app.lib.Helper;
import in.swifiic.android.app.lib.Constants;
import in.swifiic.android.app.lib.GenericService;
import in.swifiic.android.app.lib.ui.UserChooserActivity;
import in.swifiic.android.app.lib.xml.Action;
import in.swifiic.android.app.lib.xml.Notification;



import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class TestActivity extends Activity {
    
    private static final int SELECT_USER = 1;
	
    @SuppressWarnings("unused")
	private GenericService mService = null;
    private boolean mBound = false;
    
    private TextView mTextUserList = null;
    private EditText mTextMsgToSend = null;
    // private TextView mResult = null;
    private TextView mTextFromOthers=null;
    
    private AppEndpointContext aeCtx = new AppEndpointContext("Messenger", "0.1", "1");
    
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.test_main, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int itemId = item.getItemId();
		if (itemId == R.id.itemSelectUser) {
			Intent select_neighbor = new Intent(this, UserChooserActivity.class);
			startActivityForResult(select_neighbor, SELECT_USER);
			return true;
		} else {
			return super.onOptionsItemSelected(item);
		}
    }
    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (SELECT_USER == requestCode) {
            if ((data != null)){
            	String name = "none";
            	if (data.hasExtra("name") && data.hasExtra("id")) {
            		name = data.getStringExtra("name") + " | " + data.getStringExtra("id");
            	} else if(data.hasExtra("name")) {
            		name = "*";
            	}
            	mTextUserList.setText(name);
            }
            return;
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.test_activity_msngr);
        
        mTextMsgToSend = (EditText)findViewById(R.id.msgTextToSend);
        mTextUserList = (TextView)findViewById(R.id.usrListToSend);
        // mResult = (TextView)findViewById(R.id.textResult); TODO - Change scroll view to a list view for incoming messages
        // and then use this for "tick" etc.
        mTextFromOthers=(TextView)findViewById(R.id.textMessages);
        
        // assign an action to the ping button
        Button b = (Button)findViewById(R.id.buttonSendMsg);
        b.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
            	if(mTextUserList.getText().equals("Select User")) {
            		Context context = getApplicationContext();
            		Toast toast = Toast.makeText(context, "Select a user first!", Toast.LENGTH_SHORT);
            		toast.setGravity(Gravity.TOP, 0, 50);
            		toast.show();
            	}
            	else {
            		sendMsg();            		
            	}
            }
        });
    }
    
	@Override
	protected void onDestroy() {
        // unbind from service
        if (mBound) {
            // unbind from the MsngrService
            unbindService(mConnection);
            mBound = false;
        }
        
		super.onDestroy();
	}
	
    @Override
    protected void onPause() {
        super.onPause();
        
        // unregister the receiver for the DATA_UPDATED intent
        unregisterReceiver(mDataReceiver);
    }

    @Override
    protected void onResume() {
        super.onResume();
        
        if (!mBound) {
            // bind to the MsngrService
            bindService(new Intent(this, GenericService.class), mConnection, Context.BIND_AUTO_CREATE);
            mBound = true;
        }
        
        // register an receiver for NEWMSG_RECEIVED intent generated by the MsngrService
        IntentFilter filter = new IntentFilter(Constants.NEWMSG_RECEIVED);
        registerReceiver(mDataReceiver, filter);
        
        // update the displayed result
        // updateResult(); - XXX
    }

    private ServiceConnection mConnection = new ServiceConnection() {
        public void onServiceConnected(ComponentName name, IBinder service) {
            mService = ((GenericService.LocalBinder)service).getService();
        }

        public void onServiceDisconnected(ComponentName name) {
            mService = null;
        }
    };
    
    static final String XML_PDU_HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
    		"<PDU xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" " +
    		"xsi:noNamespaceSchemaLocation=\"AppHub.xsd\"\n";
    /**
     * TBD XXX using context helper / preferences get UserId; deviceId, appVer etc.
     *     XXX Generate XML properly - instead of hardcoding
     */
    private void sendMsg() {
        Intent i = new Intent(this, GenericService.class);
        i.setAction(Constants.SEND_MSG_INTENT);
        Action act = new Action("SendMessage", aeCtx);
        act.addArgument("message", mTextMsgToSend.getText().toString());
        act.addArgument("userList", mTextUserList.getText().toString()); // TODO - may need to convert user name to userId for uniqueness
                                                              // SUTA implementation + Library will help solve it
        String msg = Helper.serializeAction(act);
        		
        i.putExtra("action", msg); // msgTextToSend
        if(null != msg) startService(i);
    }
    
//    /** this is a ack for delivery of msg to appHub TBD - add logic for tick etc.**/
//    private void updateResult() {
//        runOnUiThread(new Runnable() {
//            public void run()
//            {
//                if (mService != null) {
//                    String text = mService.getLastMessage(); // TBD XXX
//                    if(null != text)
//                    	mResult.setText("D"); // TBD XXX the UI is not correctly organized for now
//                }
//            }
//        });
//    }
//    
    private BroadcastReceiver mDataReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.hasExtra("notification")) {
            	String message= intent.getStringExtra("notification");
                Log.d("MAIN", "TBD XXX -  handle incoming messages" + message);
                Notification notif = Helper.parseNotification(message);
                String textToUpdate = notif.getArgument("message");
              
                mTextFromOthers.append(textToUpdate);
            } else {
                // update the displayed result
                //updateResult(); TODO - Update result ui
            }
        }
    };
}
