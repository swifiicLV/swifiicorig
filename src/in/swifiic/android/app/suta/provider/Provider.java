package in.swifiic.android.app.suta.provider;

import java.util.StringTokenizer;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.content.Context;
import android.content.UriMatcher;
import android.database.Cursor;
import android.database.DatabaseUtils;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteQueryBuilder;
import android.net.Uri;
import android.util.Log;

/***
 * 
 * @author abhishek
 * Note: 3rd Jan r file generated 2013 - This class needs significant rework - for now limiting it to 
 * Just provide list of users
 * 
 * Update to the schema will happen based on addition of users or addition of 
 *     apps / change of roles etc. It is expected that multicast blob will deliver this data
 */


// what we expose from Content provider is a query like
// swifiic.suta/users/<appName>/<user list>   - where <user list> entry has role, userId, user name, user alias
// <appName> is variable

public class Provider extends ContentProvider {

	private static final String AUTHORITY = "in.swifiic.android.app.suta";
	private static final String USER_BASE_PATH = "users";
	private static final int USERS = 10;
	public static Provider providerInstance = null;
	private DatabaseHelper dbHelper = null;

    //---for database use---
    private SQLiteDatabase sutaDB;
    private static final String DATABASE_NAME = "SUTA";
    private static final String DB_USR_TABLE = "users";
    private static final String DB_APP_TABLE = "apps";
    private static final String DB_MAP_TABLE = "uamaps";
    
    private static final int DATABASE_VERSION = 1;
    
    private static final String CREATE_TABLE_USER =
            "CREATE TABLE " + DB_USR_TABLE + " (_id INTEGER PRIMARY KEY AUTOINCREMENT, "
                                             + "user_id TEXT NOT NULL, "
            								 + "name TEXT NOT NULL, "
            								 + "alias TEXT NOT NULL UNIQUE); ";
    private static final String CREATE_TABLE_APP =
            "CREATE TABLE " + DB_APP_TABLE + " (_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            								 + "app_id TEXT NOT NULL, "
          									 + "app_name TEXT NOT NULL, "
          									 + "role1 TEXT, "
          									 + "role2 TEXT, "
          									 + "role3 TEXT); ";
    private static final String CREATE_TABLE_MAP = 
    		"CREATE TABLE " + DB_MAP_TABLE + " (app_id INTEGER NOT NULL, "
          									 + "role TEXT NOT NULL, "
          									 + "user_id INTEGER NOT NULL, "
          									 + "FOREIGN KEY (app_id) REFERENCES " + DB_APP_TABLE + "(_id), "
          									 + "FOREIGN KEY (user_id) REFERENCES " + DB_USR_TABLE + "(_id));";
   
    private static class DatabaseHelper extends SQLiteOpenHelper {
        DatabaseHelper(Context context) {
            super(context, DATABASE_NAME, null, DATABASE_VERSION);
        }

        @Override
        public void onCreate(SQLiteDatabase db) 
        {
        	Log.d("onCreate Provider", "Creating table with: " + CREATE_TABLE_USER);
            db.execSQL(CREATE_TABLE_USER);
            Log.d("onCreate Provider", "Creating table with: " + CREATE_TABLE_APP);
            db.execSQL(CREATE_TABLE_APP);
            Log.d("onCreate Provider", "Creating table with: " + CREATE_TABLE_MAP);
            db.execSQL(CREATE_TABLE_MAP);
            
            ContentValues v = new ContentValues();
            
            // refer PopulateTestData.txt
            v.put("user_id", "1");
            v.put("name", "Shivam");
            v.put("alias", "shivam");
            db.insert(DB_USR_TABLE, "", v);
            v.clear();
            
            v.put("user_id", "2"); 
            v.put("name", "Abhishek");
            v.put("alias", "abhishek");
            db.insert(DB_USR_TABLE, "", v);
            v.clear();
            
            v.put("app_id", "1"); 
            v.put("app_name", "msngr");
            v.put("role1", "user");
            db.insert(DB_APP_TABLE, "", v);
            v.clear();
            
            v.put("app_id", "1"); 
            v.put("role", "user");
            v.put("user_id", "1");
            db.insert(DB_MAP_TABLE, "", v);
            v.clear();
            
            v.put("app_id", "1"); 
            v.put("role", "user");
            v.put("user_id", "2");
            db.insert(DB_MAP_TABLE, "", v);
            v.clear();
        }

        @Override
        public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
            Log.w("Content provider database", "Upgrading database from version " + oldVersion + " to " + newVersion +", which will destroy all old data");
            db.execSQL("DROP TABLE IF EXISTS " + DB_USR_TABLE);
            db.execSQL("DROP TABLE IF EXISTS " + DB_APP_TABLE);
            db.execSQL("DROP TABLE IF EXISTS " + DB_MAP_TABLE);
            // TODO add devices and roles table as well
            
            onCreate(db);
        }
        
        // TODO FIXME
        @SuppressWarnings("unused")
		protected void populateSchema(SQLiteDatabase db, String usrs, String apps) {
        	// STUB
        }
    } // class DatabaseHelper
    
    
	private static final UriMatcher sURIMatcher = new UriMatcher(UriMatcher.NO_MATCH);
	static {
	    sURIMatcher.addURI(AUTHORITY, USER_BASE_PATH + "/*", USERS);
	}


	@Override
	public String getType(Uri arg0) {
		int uriType = sURIMatcher.match(arg0);
	    
		switch (uriType) {
	    case USERS:
	    	return "vnd.android.cursor.dir/in.swifiic.android.app.suta.users";
	    default:
	    	throw new IllegalArgumentException("Unknown URI: " + arg0);
	    }
	}


	@Override
	public boolean onCreate() {
	    Context context = getContext();
        dbHelper = new DatabaseHelper(context);
        sutaDB = dbHelper.getWritableDatabase();
        providerInstance = this;
        return (sutaDB == null)? false: true;
	}
	
	// userSchema format - "username|alias;username|alias;..."
	public void loadUserSchema(String userSchema) {
		sutaDB.execSQL("DELETE FROM users WHERE 1=1");
		String userInfo, username, alias;
		ContentValues v = new ContentValues();
		int i = 1;
		StringTokenizer st = new StringTokenizer(userSchema, ";");
		while(st.hasMoreTokens()) {
			userInfo = st.nextToken();
			StringTokenizer st2 = new StringTokenizer(userInfo, "|");
		     while(st2.hasMoreTokens()) {
		    	 username = st2.nextToken();
		    	 alias = st2.nextToken();
		    	 v.put("user_id", i);
		         v.put("name", username);
		         v.put("alias", alias);
		         if(sutaDB.insert(DB_USR_TABLE, "", v) < 0) {
		        	 Log.e("SUTA Provider", "Unable to insert values: " + v.toString());
		         } else {
		        	 Log.d("SUTA Provider", "Successfully to inserted values: " + v.toString());
		         }
		         v.clear();
		         ++i;
		     }
		 }
	}
	
	@Override
	public Cursor query(Uri uri, String[] projection, String selection, String[] selectionArgs, String sortOrder) {
		SQLiteQueryBuilder sqlBuilder = new SQLiteQueryBuilder();
		
		int uriType = sURIMatcher.match(uri);
		String app = uri.getLastPathSegment();
		
		if(USERS == uriType) {	
			
//			sqlBuilder.setTables("apps");
//			projection = new String[]{"app_id"};
//			selection = "app_name=\'" + app +"\'";
//			Log.d("Provider query", "Querying for app_id of app: " + app);			
//			Cursor c1 = sqlBuilder.query(
//		                sutaDB, 
//		                projection, 
//		                selection, 
//		                selectionArgs, 
//		                null, 
//		                null, 
//		                null);
//			c1.moveToFirst();
//			String app_id = c1.getString(0);
//			
//			sqlBuilder.setTables("uamaps INNER JOIN users ON uamaps.user_id=users.user_id");			
//			projection = new String[]{"name", "alias"};
//			// TODO IMPORTANT - right now just return the whole user list... implement app roles in suta hub for this to work
//			// selection = "app_id=\'" + app_id +"\'";
//			selection = null;
//			Log.d("Provider query", "Querying for users of app: " + app);			
//			Cursor c = sqlBuilder.query(
//		                sutaDB, 
//		                projection, 
//		                selection, 
//		                selectionArgs, 
//		                null, 
//		                null, 
//		                sortOrder);
			sqlBuilder.setTables("users");
			projection = new String[]{"name","alias"};
			selection = null;
			Log.d("Provider query", "Querying for app_id of app: " + app);			
			Cursor c1 = sqlBuilder.query(
		                sutaDB, 
		                projection, 
		                selection, 
		                selectionArgs, 
		                null, 
		                null, 
		                null);
			Log.d("Provider query", "Dumping cursor: " + DatabaseUtils.dumpCursorToString(c1));

			c1.setNotificationUri(getContext().getContentResolver(), uri);
			return c1;
		}
        return null;
	}

	// Updates / Deletes  - not needed - Internally the schema is dropped an recreated
	// as triggered from MainActivity so don't override delete, insert, update 
	// unluckily update is abstract in base class 
	public int update(Uri arg0, ContentValues arg1, String arg2, String[] arg3) { return 0; }
	public int delete(Uri arg0, String arg1, String[] arg2) { return 0;	}
	public Uri insert(Uri arg0, ContentValues arg1) { return null; }

}