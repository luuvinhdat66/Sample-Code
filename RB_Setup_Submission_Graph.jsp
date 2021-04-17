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
    Connection        Conn              = null;
    String   	      FORM_MODE         = request.getParameter("FORM_MODE");
    String   	      tab               = request.getParameter("tab");
    String            Logged_User_ID    = (String)session.getAttribute("Sys.User_ID" );

    String            content           =  "";

	int               SYSTEM_PARTITION_ID  = (Integer)session.getAttribute("SYSTEM_PARTITION_ID");	
    int 			  SYSTEM_RB_ID 		   = Utilities.getWhoAmI( session );


    if ( !Utilities.isValidRequest(request, Sys_Prop, SYSTEM_PARTITION_ID) )
    {
        session.setAttribute("error", Utilities.ERROR_MESSAGE1);
        Utilities.DisplayPage(out, " top.location='Login.jsp?logout=Yes&s="+System.currentTimeMillis()+"'");
        return;
    }




    try
    {

        Conn = pool.getConnection();
%>
	<!DOCTYPE html>
	<html>
	<head>
	<title>Setup Submission Process Status Display</title>
	<%
		Utilities.addPagescript( out, session, null );
	%>
	
	<script src="js/common_showAjax.js"></script>
	<script src="js/date_popup.js"></script>
	<script src="js/date-picker.js"></script>
	<script src="js/date_val.js"></script>
	<script src="js/common.js"></script>
	<script src="js/RB_Setup_Submission_Graph.js"></script>
	<script src="js/System_Authenication.js"></script>
    
	<SCRIPT>

    window.onresize= resizeDiv;
    function resizeDiv()
    {
		var main       = document.getElementById('main');
    	var container  = document.getElementById('tbl-container');

		var divTop = findPosY(main);
    	var divTopContainer = findPosY(container);

    	var divLeft = findPosX(main);
    	var divLeftContainer = findPosX(container);
		if ( typeof( window.innerWidth ) == 'number' )
		{
			my_height = window.innerHeight;
        	my_width = window.innerWidth;
		}else if ( document.documentElement &&
           ( document.documentElement.clientWidth ||
             document.documentElement.clientHeight ) )
		{
			my_height = document.documentElement.clientHeight;
        	my_width = document.documentElement.clientWidth;
		}
		else if ( document.body &&
          ( document.body.clientWidth || document.body.clientHeight ) )
        {
			my_height = document.body.clientHeight;
        	my_width = document.body.clientWidth;
        }
        main.style.height = my_height - divTop;
        main.style.width = my_width - divLeft;
        if(container != null)
        container.style.height = my_height - divTopContainer  - 0  ;
        main.style.width = my_width - divLeftContainer;
    }

    function handleError()
    {
        document.documentElement.style.overflow = 'hidden';
        setDivStyle('selector', 'visible');
        setDivStyle('main', 'visible');
        resizeDiv();
        startTime ( <%=Sys_Prop.getTimeoutTimer(SYSTEM_PARTITION_ID, session)%> );
<%
        if ( session.getAttribute("Sys.ERROR") != null  )
        {
%>
            System_Alert_Error('',  "<%=(String)session.getAttribute("Sys.ERROR")%>" );
            <%=(session.getAttribute("Sys.ERROR_FOCUS") != null) ? (String)session.getAttribute("Sys.ERROR_FOCUS") : "" %>
<%
            session.removeAttribute( "Sys.ERROR" );
            session.removeAttribute( "Sys.ERROR_FOCUS" );
        }
%>

    }
    

    $(document).ready(function() {
        Handle_Back_Click();
    })
</script>

</head>
<body onLoad="handleError()">
<form method="POST" action="RB_Setup_Setup_Submission_Graph_Post.jsp" name="THEFORM"  >
	<%@ include file="INC_System_Popup.jsp" %>
	<%@ include file="INC_System_Timeout.jsp" %>
	<div id="selector">
<%
        App_Header.DisplayHeader( out, Conn, Sys_Prop, session, false, false );
    	App_Header_Banner.DisplayBanner( out, Conn, Sys_Prop, Logged_User_ID, null, "Setup Submission Process Status Display", true, session );

%>
		<div id="button_menu"></div>
		<script>
		RB_Submission_Graph_Show_Button();
		</script>
    </div>
    
	<div>
		<span style="font-weight: bold;">Click to remove steps in board Submission Process Status display:</span>
	</div>
	
    <div id="main" style="width:100%; text-align:center;"></div>
    <script>
    RB_Submission_Graph_Show_Step();
    </script>
    
    <input type="hidden" name="FORM_ACTION" value="SUBMIT">
    <input type="hidden" name="INDEX" value="0">
    <input type="hidden" name="SCROLL_X" value=0>
    <input type="hidden" name="SCROLL_Y" value=0>
	<input type="hidden" name="FORM_ID" value="0">
	<input type="hidden" name="INSTITUTION_ID" value="0"> 
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
</form>
</body>
</html>