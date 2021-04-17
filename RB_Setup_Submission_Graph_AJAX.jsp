<%@ page import="***.*******.*" %>
<%@ page import="***.*******.i18n.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page errorPage="errorpage.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="locale" uri="/WEB-INF/taglib/locale.tld" %>
<jsp:useBean id="pool" scope="request" type="***.*******.System_Audit_Connection_Pool" />
<jsp:useBean id="formContext" scope="session" class="***.*******.FormContext" />
<jsp:useBean id="Sys_Prop" scope="application" class="***.*******.System_Properties" />
	<%
	Connection        Conn              		= null;
	String            FORM_ACTION          		= request.getParameter("FORM_ACTION" );
	String            Logged_User_ID    		= (String) session.getAttribute("Sys.User_ID" );
	int 			  SYSTEM_PARTITION_ID 		= 1;
	
	
	
	try
	{
	
		if ( !Utilities.isValidRequest(request, Sys_Prop, SYSTEM_PARTITION_ID) )
		{
			session.setAttribute("error", Utilities.ERROR_MESSAGE1);
			Utilities.DisplayPage(out, " top.location='Login.jsp?logout=Yes&s="+System.currentTimeMillis()+"'");
			return;
		}
		
		Conn = pool.getConnection();
		
		SYSTEM_PARTITION_ID 				= (Integer)session.getAttribute("SYSTEM_PARTITION_ID");
	    System_RB    Current_RB             = (System_RB)session.getAttribute("Sys.RB" );
		int SYSTEM_RB_ID = Current_RB.getSYSTEM_RB_ID();
		ArrayList<RB_Setup_Submission_Step> submission_graph = (ArrayList<RB_Setup_Submission_Step>) formContext.getData("SUBMISSION_GRAPH");
		if(submission_graph == null)
		{
			submission_graph = RB_Setup_Submission_Step.Factory_Submission_Graph(Conn, Sys_Prop, Logged_User_ID, SYSTEM_RB_ID, "A");
			if(submission_graph.size() == 0)
			{
				submission_graph = RB_Setup_Submission_Step.Generate_Default_Template(Conn, Sys_Prop, Logged_User_ID, SYSTEM_RB_ID);
			}
			formContext.putData("SUBMISSION_GRAPH", submission_graph);
		}
		
		if (FORM_ACTION != null && FORM_ACTION.equals("DISPLAY_STEP") )
		{
%>
			<table style="width:80%; margin-left:50px; margin-right:50px;">
			<tr>
<%
			for(int i = 0; i < submission_graph.size(); i++)
			{
				RB_Setup_Submission_Step step = submission_graph.get(i);
%>
			<td style="width:10%;">
				<div class="step_holder" style="position:relative; padding-left:10px; padding-right:10px;">
					<a href="#" onclick="javascript:RB_Submission_Graph_Delete(<%=step.getSTEP_ORDER() %>, '<%=step.getSTEP_NAME() %>');"><img style="position:absolute; top:0; right:0;" alt="test" src="images/Delete.png"/></a>
					<table style="width:100%; height:80px;">
					<tr>
					<td colspan="2" style="height:70px;text-align:center;">
					<%=step.getSTEP_NAME() %>
					</td>
					</tr>
					<tr>
					<td style="width:50%; height:10px; background-color:#047D7D;">
					&nbsp;
					</td>
					<td style="background-color:#CCCCCC;">
					&nbsp;
					</td>
					</tr>
					</table>
				</div>
			</td>
<%
			}
			if(submission_graph.size() < 10)
			{
				for(int i = submission_graph.size(); i < 10; i++)
				{
%>
			<td style="width:10%;">
				<div class="empty_step_holder" style="position:relative; padding-left:10px; padding-right:10px;">
					&nbsp;
				</div>
			</td>
<%
				}
			}
%>
			</tr>
			</table>
<%		
		}
		else if (FORM_ACTION != null && FORM_ACTION.equals("DISPLAY_BUTTON") )
		{
%>
	        <table style=" width:100%;">
	        <tr>
			<td style=" width:100%; text-align:right;">
				<table style=" text-align:right; float:right;">
				<tr>
<%
				String auth = (String) formContext.getData("AUTHENICATION_VALIDATED");
				if(auth == null)
				{
%>
				<td>
					<button type="button" class="btn btn-default btn-sm nav-link btn-info" onclick="javascript:System_Authenication_Open('ADD_GRAPH_STEP');"> Authenticate</button>&nbsp;
				</td>    
<%
				}
				if(auth != null && auth.equals ( (String) formContext.getData( "AUTHENICATION_TYPE" ) + session.getId()  ) )
				{
%>             
				<td>
					<button type="button" class="btn btn-default btn-sm nav-link btn-info" onclick="javascript:RB_Submission_Graph_Add_Custom_Step();"> Add Custom Step</button>&nbsp;
				</td>     
<%

					formContext.removeData( "AUTHENICATION_TYPE" );
					formContext.removeData( "AUTHENICATION_VALIDATED" );
				}
%>          
				<td>
					<button type="button" class="btn btn-default btn-sm nav-link btn-info" onclick="javascript:RB_Submission_Graph_Add_Step();"> Add Step</button>&nbsp;
				</td>  
				<td>
					<button type="button" class="btn btn-default btn-sm nav-link btn-info" onclick="javascript:RB_Submission_Graph_Reset_Step();"> Reset Steps</button>&nbsp;
				</td>               
				<td>
					<button type="button" class="btn btn-default btn-sm nav-link btn-info" onclick="javascript:RB_Submission_Graph_Save();"> Save Settings</button>&nbsp;
				</td>
				</tr>
				</table>
			</td>
			</tr>
			</table>
<%
		}
		else if (FORM_ACTION != null && FORM_ACTION.equals("RESET_STEP") )
		{
			RB_Setup_Submission_Step.Delete_All(Conn, Sys_Prop, Logged_User_ID, SYSTEM_RB_ID);
			RB_Setup_Submission_Step.Generate_Default_Template(Conn, Sys_Prop, Logged_User_ID, SYSTEM_RB_ID);
		}
		else if (FORM_ACTION != null && FORM_ACTION.equals("ADD_STEP") )
		{
			ArrayList<String> inactive_steps = RB_Setup_Submission_Step.get_Step_Name_list(Conn, Sys_Prop, Logged_User_ID, SYSTEM_RB_ID, "I");
			ArrayList<RB_Setup_Submission_Step> removed_steps = (ArrayList<RB_Setup_Submission_Step>) formContext.getData("REMOVED_STEPS");
			if(removed_steps != null && removed_steps.size() > 0)
			{
				for(int i = 0; i < removed_steps.size(); i++)
				{
					RB_Setup_Submission_Step step = removed_steps.get(i);
					if(step.getTYPE() == RB_Setup_Submission_Step.PREDEFINED)
					{
						inactive_steps.add(step.getSTEP_ORDER() + "");
						inactive_steps.add(step.getSTEP_NAME());
					}
				}
			}
%>
			<%= Utilities.Popup_Header( "Add Step", "Close_RB_Submission_Graph_Popup();" ) %>
		
			<div style="width:100%; height:100px; padding-left:20px; padding-right:20px;">
			<table>
			<tr>
			<td>
				<span style="font-weight:bold;">Select Predifined Step:</span>
			</td>
			<td>
				<select size="1" name="STEP_NAME" style="font-family: Verdana; font-size: 8pt; " >
<%
				Utilities.LoadDefaultSelectOptionList( out, inactive_steps, null );
%>
				</select>
			</td>
			</tr>
			</table>
			</div>
			<div style="width:95%; height:50px; text-align:right;">
				<button type="button" class="btn btn-default btn-sm nav-link btn-info" onclick="javascript:RB_Submission_Graph_Save_Predefined_Step();">Save</button>
			</div>

		
<%
		}
		else if (FORM_ACTION != null && FORM_ACTION.equals("ADD_CUSTOM_STEP") )
		{
			String STEP_NAME    = "";
			String QUERY_CONTENT = "";
%>

			<%= Utilities.Popup_Header( "Add Custom Step", "Close_RB_Submission_Graph_Popup();" ) %>
		
			<div style="width:100%; height:100px; padding-left:20px; padding-right:20px;">
			<table>
			<tr>
			<td>
				<span style="color:#CC0000;">*</span><b class="nobg">Step Name:</b>&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="STEP_NAME" size="40" maxlength="48" value="<%=STEP_NAME%>">
			</td>
			</tr>
			<tr><td style="text-align:center;"><b class="nobg">Query Content:</b> (Please use only the select command.)</td></tr>
		
			<tr>
			<td style="text-align:center;" >
				<span style="font-size:13px;">
				<textarea id="queryA" cols="115" rows="20" name="QUERY_CONTENT"><%=QUERY_CONTENT%></textarea>
				</span>
			</td>
			</tr>
			</table>
			</div>
			<div style="width:95%; height:50px; text-align:right;">
				<button type="button" class="btn btn-default btn-sm nav-link btn-info" onclick="javascript:return false;">Save</button>
			</div>

		
<%
		}
		else if (FORM_ACTION != null && FORM_ACTION.equals("DELETE_STEP") )
		{
			int ORDER = Integer.parseInt((String) request.getParameter("ORDER"));
			String STEP_NAME = (String) request.getParameter("STEP_NAME");
			if(submission_graph != null)
			{
				int i = ORDER-1;
				RB_Setup_Submission_Step removed_step = submission_graph.get(i);
				if(removed_step.getTYPE() == RB_Setup_Submission_Step.PREDEFINED)
				{
					ArrayList<RB_Setup_Submission_Step> removed_list = (ArrayList<RB_Setup_Submission_Step>) formContext.getData("REMOVED_STEPS");
					if(removed_list == null)
					{
						removed_list = new ArrayList<RB_Setup_Submission_Step>();
					}
					removed_list.add(removed_step);
					formContext.putData("REMOVED_STEPS", removed_list);
				}
				submission_graph.remove(i);
				for(; i < submission_graph.size(); i++)
				{
					RB_Setup_Submission_Step step = submission_graph.get(i);
					step.setSTEP_ORDER(i+1);
				}
			}
		}
		else if (FORM_ACTION != null && FORM_ACTION.equals("SAVE_GRAPH") )
		{
			ArrayList<RB_Setup_Submission_Step> removed_steps = (ArrayList<RB_Setup_Submission_Step>) formContext.getData("REMOVED_STEPS");
			if(removed_steps != null)
			{ 
				for(int i = 0; i < removed_steps.size(); i++)
				{
					RB_Setup_Submission_Step step = removed_steps.get(i);
					step.Delete(Conn, Sys_Prop, Logged_User_ID);
				}
			}
			
			for(int i = 0; i < submission_graph.size(); i++)
			{
				RB_Setup_Submission_Step step = submission_graph.get(i);
				if(step.isExists(Conn, Sys_Prop, Logged_User_ID))
				{
					step.Update(Conn, Sys_Prop, Logged_User_ID, SYSTEM_PARTITION_ID);
				}
				else
				{
					step.Insert(Conn, Sys_Prop, Logged_User_ID);
				}
			}
		}
		else if (FORM_ACTION != null && FORM_ACTION.equals("SAVE_PREDEFINED_STEP") )
		{
			String STEP_NAME = (String) request.getParameter("STEP_NAME");
			RB_Setup_Submission_Step step = RB_Setup_Submission_Step.Find(Conn, Sys_Prop, Logged_User_ID, SYSTEM_RB_ID, STEP_NAME, "I");
			if(step != null)
			{
				step.setSTATUS("A");
				submission_graph.add(step);
			}
			else
			{
				ArrayList<RB_Setup_Submission_Step> removed_steps = (ArrayList<RB_Setup_Submission_Step>) formContext.getData("REMOVED_STEPS");
				if(removed_steps != null && removed_steps.size() > 0)
				{
					for(int i = 0; i < removed_steps.size(); i++)
					{
						step = removed_steps.get(i);
						if(step.getSTEP_NAME().equals(STEP_NAME))
						{
							submission_graph.add(step.getSTEP_ORDER()-1, step);
							removed_steps.remove(i);
							break;
						}
					}
				}
			}
		}
		else if (FORM_ACTION != null && FORM_ACTION.equals("BACK_NAVIGATE") )
		{
			formContext.removeData("SUBMISSION_GRAPH");
			formContext.removeData("REMOVED_STEPS");
		}
%>
		<input type="hidden" name="INDEX" value="0">
		<input type="hidden" name="SCROLL_X" value=0>
		<input type="hidden" name="SCROLL_Y" value=0>
		</div>
<%
	}
	catch ( Exception e )
	{
		System.out.println("Exception = " + e.getMessage());
		e.printStackTrace();
		throw e;
	}
	finally
	{
		if ( Conn != null )
		{
			pool.releaseConnection( Conn);
		}
	}
%>