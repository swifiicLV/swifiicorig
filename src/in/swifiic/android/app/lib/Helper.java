package in.swifiic.android.app.lib;

import java.io.StringWriter;

import in.swifiic.android.app.lib.xml.Notification;
import in.swifiic.android.app.lib.xml.Action;

import org.simpleframework.xml.Serializer;
import org.simpleframework.xml.core.Persister;

import android.content.Intent;
import android.content.Context;
import android.util.Log;

public class Helper {

	public static Notification parseNotification(String str) {
        Serializer serializer = new Persister();
        try {
        	Notification notif = serializer.read(Notification.class,str);
        	return notif;
        } catch(Exception e) {
        	// This shoulod not happen unless APP tries a random string 
        	// String given from Generic Service was already tested for success
        }
        return null;
	}
	
	public static String serializeAction(Action act) {
        try {
        	 StringWriter writer = new StringWriter();
        	 Serializer serializer = new Persister();  
       	     serializer.write(act, writer);  

        	 return writer.getBuffer().toString();
        } catch(Exception e) {
        	// This should not happen since Action is a XML serializable object
        }
        return null;
	}
	public static String sendAction(Action act, Context c) {
        try {
        	String msg = serializeAction(act);
            Intent i = new Intent(c, GenericService.class);
            i.setAction(Constants.SEND_MSG_INTENT);
            i.putExtra("action", msg); // msgTextToSend
            c.startService(i);
        } catch(Exception e) {
        	Log.e("sendAction", "Something goofy:" + e.getMessage());
        }
        return null;
	}
}
