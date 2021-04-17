package ***.*******; // hide package name 

import java.util.*;
import java.sql.*;

public class RB_Setup_Submission_Step 
{
    /************************************************************/
    /*  Member Variables                                        */
    /************************************************************/
	private int SYSTEM_RB_ID;
	private int STEP_ORDER;
	private String STEP_NAME;
	private String STATUS;
	private int TYPE;
	private String QUERY_CONTENT;
	private ArrayList<String> template_list1;
	private HashMap<String, String> template_list2;
	
	//getter
	
	public int getSYSTEM_RB_ID() 
	{
		return SYSTEM_RB_ID;
	}
	public int getSTEP_ORDER() 
	{
		return STEP_ORDER;
	}
	public String getSTEP_NAME() 
	{
		return STEP_NAME;
	}
	public String getSTATUS() 
	{
		return STATUS;
	}
	public int getTYPE() 
	{
		return TYPE;
	}
	public String getQUERY_CONTENT() 
	{
		return QUERY_CONTENT;
	}
	public ArrayList<String> getTemplate_list1() 
	{
		return template_list1;
	}
	public HashMap<String, String> getTemplate_list2() 
	{
		return template_list2;
	}
	
	//setter

	public void setSYSTEM_RB_ID(int SYSTEM_RB_ID) 
	{
		this.SYSTEM_RB_ID = SYSTEM_RB_ID;
	}
	public void setSTEP_ORDER(int STEP_ORDER) 
	{
		this.STEP_ORDER = STEP_ORDER;
	}
	public void setSTEP_NAME(String STEP_NAME) 
	{
		this.STEP_NAME = STEP_NAME;
	}
	public void setSTATUS(String STATUS) 
	{
		this.STATUS = STATUS;
	}
	public void setTYPE(int TYPE) 
	{
		this.TYPE = TYPE;
	}
	public void setQUERY_CONTENT(String QUERY_CONTENT) 
	{
		this.QUERY_CONTENT = QUERY_CONTENT;
	}
	public void setTemplate_list1(ArrayList<String> template_list1) 
	{
		this.template_list1 = template_list1;
	}
	public void setTemplate_list2(HashMap<String, String> template_list2) 
	{
		this.template_list2 = template_list2;
	}
	
	//Type of step
	public static final int PREDEFINED = 1;
	public static final int CUSTOM = 2;
	
	public RB_Setup_Submission_Step
	(
		int SYSTEM_RB_ID,
		int STEP_ORDER,
		String STEP_NAME,
		String STATUS,
		int TYPE,
		String QUERY_CONTENT
	) 
	{
		this.SYSTEM_RB_ID = SYSTEM_RB_ID;
		this.STEP_ORDER = STEP_ORDER;
		this.STEP_NAME = STEP_NAME;
		this.STATUS = STATUS;
		this.TYPE = TYPE;
		this.QUERY_CONTENT = QUERY_CONTENT;
	}
	
	public static ArrayList<RB_Setup_Submission_Step> Factory_Submission_Graph
    (
        Connection 			Conn, 
        System_Properties 	Sys_Prop,
        String            	Logged_User_ID,
        int					SYSTEM_RB_ID,
        String				STATUS
    )
    {
    	
        PreparedStatement 					ppstmt 			= 	null;
        String 								strSQL;
        ResultSet 							rset 			= 	null;
        ArrayList<RB_Setup_Submission_Step> 	list			= 	new ArrayList<RB_Setup_Submission_Step>(); 
        
        try
        {
            strSQL = "SELECT "+
                     "     RSGT.STEP_ORDER, RSGT.STEP_NAME, RSGT.STATUS, RSGT.TYPE, RSGT.QUERY_CONTENT " +
		             " FROM " +
		             "     RB_SUBMISSION_STEP_TEMPLATE RSGT " +
		             " WHERE " +
                     "     RSGT.SYSTEM_RB_ID = " + SYSTEM_RB_ID;
             if(STATUS != null)
             {
             	strSQL += "     AND RSGT.STATUS = '" + STATUS + "' ";
             }
		     
             strSQL += " ORDER BY RSGT.STEP_ORDER ";
        	
            ppstmt = Conn.prepareStatement(strSQL, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rset = ppstmt.executeQuery();
            while (rset.next())
            {
            	list.add(new RB_Setup_Submission_Step(SYSTEM_RB_ID, rset.getInt(1), rset.getString(2), rset.getString(3), rset.getInt(4), rset.getString(5)));
            }
            
            rset.close();
            rset = null;
            ppstmt.close();
            ppstmt = null;

        } 
        catch (Exception e)
        {
            System_Event.logException(Conn, Sys_Prop, e, "RB_Setup_Submission_Step.java", Logged_User_ID);
            e.printStackTrace();
        } 
        finally
        {
        	try
        	{
	            if (rset != null)
	                rset.close();
	            if (ppstmt != null)
	                ppstmt.close();
        	}
        	catch ( Exception e )
        	{
        	}
        }
        return list;
    }
	
	public static RB_Setup_Submission_Step Find
    (
        Connection 			Conn, 
        System_Properties 	Sys_Prop,
        String            	Logged_User_ID,
        int					SYSTEM_RB_ID,
        String				STEP_NAME,
        String				STATUS
    )
    {
    	
        PreparedStatement 					ppstmt 			= 	null;
        String 								strSQL;
        ResultSet 							rset 			= 	null;
        RB_Setup_Submission_Step 			step			= 	null; 
        
        try
        {
            strSQL = "SELECT "+
                     "     RSGT.SYSTEM_RB_ID, RSGT.STEP_ORDER, RSGT.STEP_NAME, RSGT.STATUS, RSGT.TYPE, RSGT.QUERY_CONTENT " +
		             " FROM " +
		             "     RB_SUBMISSION_STEP_TEMPLATE RSGT " +
		             " WHERE " +
                     "     RSGT.SYSTEM_RB_ID = " + SYSTEM_RB_ID;
            if(STEP_NAME != null)
            {
            	strSQL += "     AND RSGT.STEP_NAME = '" + STEP_NAME + "' ";
            }
			if(STATUS != null)
			{
				strSQL += "     AND RSGT.STATUS = '" + STATUS + "' ";
			}
			
            ppstmt = Conn.prepareStatement(strSQL, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rset = ppstmt.executeQuery();
            while (rset.next())
            {
            	step = new RB_Setup_Submission_Step(rset.getInt(1), rset.getInt(2), rset.getString(3), rset.getString(4), rset.getInt(5), rset.getString(6));
            }
            
            rset.close();
            rset = null;
            ppstmt.close();
            ppstmt = null;

        } 
        catch (Exception e)
        {
            System_Event.logException(Conn, Sys_Prop, e, "RB_Setup_Submission_Step.java", Logged_User_ID);
            e.printStackTrace();
        } 
        finally
        {
        	try
        	{
	            if (rset != null)
	                rset.close();
	            if (ppstmt != null)
	                ppstmt.close();
        	}
        	catch ( Exception e )
        	{
        	}
        }
        return step;
    }
	
	public static ArrayList<RB_Setup_Submission_Step> Generate_Default_Template
    (
        Connection 			Conn, 
        System_Properties 	Sys_Prop,
        String            	Logged_User_ID,
        int					SYSTEM_RB_ID
    )
    {
		ArrayList<RB_Setup_Submission_Step> list = new ArrayList<RB_Setup_Submission_Step>();
        try
        {
        	System_RB rb = System_RB.Find_RB(Conn, Sys_Prop, Logged_User_ID, SYSTEM_RB_ID);
        	ArrayList<String> step_list = new ArrayList<String>();
        	
        	if(rb != null)
        	{
        		switch(rb.getTYPE())
        		{
        		case System_RB.IRB:
        			step_list = new ArrayList<String>();
        			step_list.add("Submission Received");
        			step_list.add("Analyst Assigned");
        			step_list.add("Analyst Checklist Complete");
        			step_list.add("Review Process Assigned");
        			step_list.add("Reviewer(s) Assigned");
        			step_list.add("All Reviewer(s) Complete");
        			step_list.add("Submission Items Reviewed/Approved");
        			step_list.add("Submission Outcome Assigned");
        			step_list.add("Response Letter Generated");
        			step_list.add("Submission Completed");
        			
        			for(int i = 0; i < step_list.size(); i++)
        			{
        				RB_Setup_Submission_Step submission_step = new RB_Setup_Submission_Step(SYSTEM_RB_ID, i + 1, step_list.get(i), "A", RB_Setup_Submission_Step.PREDEFINED, "");
        				if(!submission_step.isExists(Conn, Sys_Prop, Logged_User_ID))
        				{
        					submission_step.Insert(Conn, Sys_Prop, Logged_User_ID);
        				}
        				list.add(submission_step);
        			}
        			break;
        		}
        	}

        } 
        catch (Exception e)
        {
            System_Event.logException(Conn, Sys_Prop, e, "RB_Setup_Submission_Step.java", Logged_User_ID);
            e.printStackTrace();
        }
        
        return list;
    }

	public void Insert
    (
        Connection              Conn,
        System_Properties       Sys_Prop,
        String                  Logged_User_ID
    )
    {

        Statement                   Stmt = null;
        PreparedStatement           ppstmt = null;
        String                      strSQL;

        try
        {
        	String dateFunction = Utilities.db_date_str(Sys_Prop);
            strSQL  = "INSERT INTO RB_SUBMISSION_STEP_TEMPLATE ( " +
				      "    SYSTEM_RB_ID, STEP_ORDER, STEP_NAME, STATUS, TYPE, QUERY_CONTENT, " +
					  "    ID_CREATED, DATE_CREATED, ID_MODIFIED, DATE_MODIFIED ) " +
                      "VALUES ( ?,?,?,?,?,?, ?, " + dateFunction + ", ?, " + dateFunction + ")";
            ppstmt = Conn.prepareStatement(strSQL);
            ppstmt.setInt(1, SYSTEM_RB_ID);
            ppstmt.setInt(2, STEP_ORDER);
			ppstmt.setString(3, STEP_NAME);
			ppstmt.setString(4, STATUS);
            ppstmt.setInt(5, TYPE);
			ppstmt.setString(6, QUERY_CONTENT);
			ppstmt.setString(7, Logged_User_ID);
			ppstmt.setString(8, Logged_User_ID);
			
            ppstmt.execute( );
            ppstmt.close();
            ppstmt = null;
        }
        catch ( SQLException e )
        {
            System_Event.logException ( Conn, Sys_Prop, e, "RB_Setup_Submission_Step.java", Logged_User_ID  );
            e.printStackTrace();
        }
        finally
        {
            try
            {
                if ( Stmt != null )
                    Stmt.close();
                if ( ppstmt != null )
                    ppstmt.close();
            }
            catch ( SQLException e )
            {
            }

        }

    }

    public void Update
    (
        Connection              Conn,
        System_Properties       Sys_Prop,
        String                  Logged_User_ID,
        int						SYSTEM_PARTITION_ID
    )
    {
        PreparedStatement           ppstmt = null;
        String                      strSQL;

        try
        {
        	strSQL  = "UPDATE RB_SUBMISSION_STEP_TEMPLATE SET " +
        			  "		STEP_ORDER = ?, STATUS = ?,  QUERY_CONTENT = ?, " +
        	          "     ID_MODIFIED = ?, DATE_MODIFIED  = " + Utilities.db_date_str(Sys_Prop) +
        	          "WHERE " +
        	          "     SYSTEM_RB_ID = ? "+
        	          "     AND STEP_NAME = ? ";

            ppstmt = Conn.prepareStatement(strSQL.toString());
			ppstmt.setInt(1, STEP_ORDER);
			ppstmt.setString(2, STATUS);
			ppstmt.setString(3, QUERY_CONTENT);
			ppstmt.setString(4, Logged_User_ID);
            ppstmt.setInt(5, SYSTEM_RB_ID);  
            ppstmt.setString(6, STEP_NAME);               
            
            ppstmt.execute();
            ppstmt.close();
            ppstmt = null;
        }
        catch ( SQLException e )
        {
            System_Event.logException ( Conn, Sys_Prop, e, "RB_Setup_Submission_Step.java", Logged_User_ID  );
            e.printStackTrace();
        }
        finally
        {

            try
            {
                if ( ppstmt != null )
                   ppstmt.close();
            }
            catch ( SQLException e )
            {
            }
        }
    }
    
    public void Delete
    (
        Connection              Conn,
        System_Properties       Sys_Prop,
        String                  Logged_User_ID
    )
    {
        PreparedStatement           ppstmt = null;
        String                      strSQL;

        try
        {
        	if(TYPE == CUSTOM)
    		{
        		strSQL  = "DELETE RB_SUBMISSION_STEP_TEMPLATE WHERE SYSTEM_RB_ID = ? AND STEP_NAME = ? ";
    		}
        	else
            {
        		strSQL  = "UPDATE RB_SUBMISSION_STEP_TEMPLATE SET STATUS = 'I' WHERE SYSTEM_RB_ID = ? AND STEP_NAME = ? ";
            }
            ppstmt = Conn.prepareStatement(strSQL);
            ppstmt.setInt(1, SYSTEM_RB_ID);
            ppstmt.setString(2, STEP_NAME);
            ppstmt.execute( );
            ppstmt.close();
            ppstmt = null;
        }
        catch ( SQLException e )
        {
            System_Event.logException ( Conn, Sys_Prop, e, "RB_Setup_Submission_Step.java", Logged_User_ID  );
            e.printStackTrace();
        }
        finally
        {
			try
			{
				if (ppstmt != null)
					ppstmt.close();
			}
			catch ( SQLException e )
			{
			}
        }

    }
    
    public static void Delete_All
    (
        Connection              Conn,
        System_Properties       Sys_Prop,
        String                  Logged_User_ID,
        int						SYSTEM_RB_ID
    )
    {
        PreparedStatement           ppstmt = null;
        String                      strSQL;

        try
        {
    		strSQL  = "DELETE RB_SUBMISSION_STEP_TEMPLATE WHERE SYSTEM_RB_ID = ? ";
            ppstmt = Conn.prepareStatement(strSQL);
            ppstmt.setInt(1, SYSTEM_RB_ID);
            ppstmt.execute( );
            ppstmt.close();
            ppstmt = null;
        }
        catch ( SQLException e )
        {
            System_Event.logException ( Conn, Sys_Prop, e, "RB_Setup_Submission_Step.java", Logged_User_ID  );
            e.printStackTrace();
        }
        finally
        {
			try
			{
				if (ppstmt != null)
					ppstmt.close();
			}
			catch ( SQLException e )
			{
			}
        }

    }
    
    public boolean isExists
    (
            Connection              Conn,
            System_Properties       Sys_Prop,
            String                  Logged_User_ID
    )
    {
    	
        PreparedStatement 					ppstmt 			= 	null;
        String 								strSQL;
        ResultSet 							rset 			= 	null;
        boolean 	isExists			= 	false; 
        
        try
        {
            strSQL = "SELECT "+
                     "     1 " +
		             "FROM " +
		             "     RB_SUBMISSION_STEP_TEMPLATE " +
		             "WHERE " +
                     "     SYSTEM_RB_ID = " + SYSTEM_RB_ID +
                     "     AND STEP_ORDER = " + STEP_ORDER +
                     "     AND STEP_NAME = '" + STEP_NAME + "'";
        	
            ppstmt = Conn.prepareStatement(strSQL, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rset = ppstmt.executeQuery();
            if (rset.next())
            {
            	isExists = true;
            }
            
            rset.close();
            rset = null;
            ppstmt.close();
            ppstmt = null;

        } 
        catch (Exception e)
        {
            System_Event.logException(Conn, Sys_Prop, e, "RB_Setup_Submission_Step.java", Logged_User_ID);
            e.printStackTrace();
        } 
        finally
        {
        	try
        	{
	            if (rset != null)
	                rset.close();
	            if (ppstmt != null)
	                ppstmt.close();
        	}
        	catch ( Exception e )
        	{
        	}
        }
        return isExists;
    }
    
    public static ArrayList<String> get_Step_Name_list
    (
        Connection 			Conn, 
        System_Properties 	Sys_Prop,
        String            	Logged_User_ID,
        int					SYSTEM_RB_ID,
        String				STATUS
    )
    {
    	
        PreparedStatement 					ppstmt 			= 	null;
        String 								strSQL;
        ResultSet 							rset 			= 	null;
        ArrayList<String> 	list			= 	new ArrayList<String>(); 
        
        try
        {
            strSQL = "SELECT "+
                     "     RSGT.STEP_ORDER, RSGT.STEP_NAME " +
		             " FROM " +
		             "     RB_SUBMISSION_STEP_TEMPLATE RSGT " +
		             " WHERE " +
                     "     RSGT.SYSTEM_RB_ID = " + SYSTEM_RB_ID;
             if(STATUS != null)
             {
             	strSQL += "     AND RSGT.STATUS = '" + STATUS + "' ";
             }
		     
             strSQL += " ORDER BY RSGT.STEP_ORDER ";
        	
            ppstmt = Conn.prepareStatement(strSQL, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rset = ppstmt.executeQuery();
            while (rset.next())
            {
            	list.add(rset.getString(1));
            	list.add(rset.getString(2));
            }
            
            rset.close();
            rset = null;
            ppstmt.close();
            ppstmt = null;

        } 
        catch (Exception e)
        {
            System_Event.logException(Conn, Sys_Prop, e, "RB_Setup_Submission_Step.java", Logged_User_ID);
            e.printStackTrace();
        } 
        finally
        {
        	try
        	{
	            if (rset != null)
	                rset.close();
	            if (ppstmt != null)
	                ppstmt.close();
        	}
        	catch ( Exception e )
        	{
        	}
        }
        return list;
    }
}
