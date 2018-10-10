<%@ page buffer="none" autoFlush="true" %>
<%@ include file="../authenticate.jsp" %>


<%@ page import="java.sql.* "%>
<%@ page import="com.infinitecampus.prism.* "%>
<%@ page import="com.infinitecampus.user.User" %>
<%@ page import="com.infinitecampus.utility.*" %>
<%@ page import="com.infinitecampus.system.*" %>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ include file="srsPath.jsp" %>



<%

// variables that already defined because of imports
// appName
// baseURL


	Connection con = Prism.getConnection(appName);

	String calendarID = Prism.getCookie(request, "calendarID");
	String districtID = Prism.getCookie(request, "districtID");
	String schoolID = Prism.getCookie(request, "schoolID");
	String sectionID = Prism.getCookie(request, "sectionID");
	String structureID = Prism.getCookie(request, "structureID");
    String endYear = Prism.getCookie(request, "endYear");

	Object contextID = (String) session.getAttribute("contextID");
	Object contextIDType = (String) session.getAttribute("contextIDType");

	CampusApp newurl = Prism.getApp(appName);

	Object sessUser = session.getAttribute("user"); //this line needed for later Campus versions

	String tempUser = sessUser.toString();
	int userIndexStart = tempUser.indexOf("userID:") + 7;
	int userIndexEnd = tempUser.indexOf(" ", userIndexStart);
	String userID = tempUser.substring(userIndexStart,userIndexEnd);
	
	int unIndexStart = tempUser.indexOf("username:") + 9;
	int unIndexEnd = tempUser.indexOf(" ", unIndexStart);
	String username = tempUser.substring(unIndexStart,unIndexEnd);

    //variables used when assembling the droplist lists
	String schoolID2 = null;
	String SchoolName = null;
	String GradeLevelValue = null;
	
	//variables to gather the choices the user has made and concat them into the URL
	String incidentIDValue = request.getParameter("IncidentList");
	String roomNameValue = request.getParameter("Rooms");
    String eventNameValue = request.getParameter("IncidentList"); 
	String reschDateValue = request.getParameter("reschDate");
    String appByValue = request.getParameter("appBy"); 	
    String commentsValue = request.getParameter("comments"); 	
	String rValue = request.getParameter("render");
		
	//variables needed for SQL statements to work
	String SQL2 = null;
	ResultSet result2 = null;
	String SQL1 = null;
	ResultSet result1 = null;
	
	//variables needed for page to know itself and call the right report
	String dir = "Behavior-BEPRDN0001/";
	String srsReportName = "LunchDetentionNotice-BEREDR0009";
	String jspPageName = "LunchDetentionNotice-BEREDR0009";

	
%>

<SCRIPT LANGUAGE="JavaScript">

function log(message) {
    if (!log.window_ || log.window_.closed) {
        var win = window.open("", null, "width=1000,height=100," +
                              "scrollbars=yes,resizable=yes,status=no," +
                              "location=no,menubar=no,toolbar=no");
        if (!win) return;
        var doc = win.document;
        doc.write("<html><head><title>URL</title></head>" +
                  "<body></body></html>");
        doc.close();
        log.window_ = win;
    }
    var logLine = log.window_.document.createElement("div");
    logLine.appendChild(log.window_.document.createTextNode(message));
    log.window_.document.body.appendChild(logLine);
}

</SCRIPT>

<%

	try
	{
	

		if (request.getParameter("callrspassthru") != null)
		{

		// Resolve null parameter

		//if (personValue.equals("null")) {
		//personValue = ":isnull=True";
		//}
		//else {personValue = "=" + personValue;}
		
		String ext = rValue.substring(0,3);
		String render = rValue.substring(3,rValue.length());

		//Build ReportServer URL
		String commentsValue2 = commentsValue.replaceAll(" ","%20");
		String appByValue2 = appByValue.replaceAll(" ","%20");
		
		String url = path+dir+srsReportName+"&personID="+contextID+"&calendarID="+calendarID+"&incidentID="+incidentIDValue+"&rescheduleDt="+reschDateValue+
						"&appBy="+appByValue2+"&comments="+commentsValue2+"&room="+roomNameValue;
		url += "&rs%3AFormat="+render+"";

		//Launch report		

		//out.println("<script>log('"+url+"');</script>");
		response.sendRedirect(pagePath+"/rsPassThruMulti.jsp?url="+URLEncoder.encode(url)+"&ext="+ ext +"&srsReportName="+ srsReportName + "");

		}
%>


<HTML>
<HEAD>
	<BASE HREF="<%= baseURL %>"/>
	<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
	<TITLE>Report</TITLE>
	<LINK rel="stylesheet" href="styles/lens.css" type="text/css"/>
	<SCRIPT LANGUAGE="JavaScript">


		var studentArray = new Array();

<%

%>

		
	</SCRIPT>
	
	</SCRIPT>
<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
  <script src="//code.jquery.com/jquery-1.10.2.js"></script>
  <script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script>
  $(function() {
    $( "#datepicker" ).datepicker();
  });
  </script>		
</HEAD>


<BODY bgcolor="#E0E0E0" topmargin="4" leftmargin="4">
<FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
 
<%	
	} //ends the try block

	catch(Exception ex)
	{

	System.out.println("error occurred" + ex.getMessage());
		out.println("<b>"+ex.getMessage()+"</b>"); out.flush();
		throw ex;
	}

%>


	<FORM name = 'rsPass' action="<%= pagePath %><%= jspPageName %>.jsp?callrspassthru=true" method="post""> <!--(this version works for most districts-->
	
	<TABLE cellpadding="0" cellspacing="0" width="640">
		<TR>
		<TD class="wizardHeader" width="100%" style="height: 21px;">Lunch Detention Notice</TD>
		</TR>
		
		<TR>
		<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;font-size: 10px; font-weight: bold;" valign="top">
		  <span style="font-size: 8pt">Print a Lunch Detention Notice for the selected student.</span>
		  		  <p><span style="color:red"><strong>*Report requires a Behavior Event with a Lunch Detention resolution.</strong></span><BR/></TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"></TD>
		</TR>
	</TABLE>
	
        <TR>
			<TD class="detailFormColumn" style="padding-top: 10px;">
              <p>
                <%

			Statement db2 = con.createStatement();
			int newRecords2 = 0;
		    SQL2 = "select distinct bh.incidentID " +
					", CONVERT(VARCHAR(10),bh.incidentdate,110) + ' ' + bh.eventName as EventName " +
					" from v_BehaviorDetail as bh with (nolock) " +
					" inner join person as p with (nolock) on p.personID = bh.personID " +
					" inner join [identity] as id with (nolock) on id.identityID = p.currentIdentityID " +
					" inner join enrollment as e with (nolock) on e.personID = id.personID " +
			 			" and e.calendarID = " + calendarID +
					" inner join calendar as cal with (nolock) on cal.calendarID = bh.calendarID " +
					" inner join school as sch with (nolock) on sch.schoolID = cal.schoolID " +
					" where bh.personID = " + contextID +
						" and bh.calendarID = " + calendarID +
						" and bh.resolutionCode = 'DTL' " ;

			result2 = db2.executeQuery(SQL2);


			out.println("<label>Select Behavior Event:</label><br/><select name=IncidentList id=16><option value='NULL' selected='false'> </option>");
			while(result2.next())
			{ incidentIDValue=result2.getString(1); 
			eventNameValue = result2.getString(2);
			out.println("<option value='"+incidentIDValue+"'>"+eventNameValue+"</option>");}
			out.println("</select>");
			
			//con.close();

%>
                <FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 0px;">

              </span></FONT></p>
              <p><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                <%

			Statement db1 = con.createStatement();
			int newRecords1 = 0;
		    SQL1 = "select name from room where schoolID = " + schoolID +
					" order by name " ;

			result1 = db1.executeQuery(SQL1);


			out.println("<label>Select Detention Room:</label><br/><select name=Rooms id=17><option value='NULL' selected='false'> </option>");
			while(result1.next())
			{ roomNameValue=result1.getString(1); 
			out.println("<option value='"+roomNameValue+"'>"+roomNameValue+"</option>");}
			out.println("</select>");
			
			con.close();

%>
              </FONT><br/>
              </p>
          </TD>	
		</TR><TR>
		
				<TD class="detailFormColumn" style="padding-top: 10px;">
                <hr>
                <p>OPTIONAL FIELDS</p>
                <p>Rescheduled Date: 
                  <input type="text" name="reschDate" id="datepicker">
                </p>
                <p>
                  <label for="tempRemovalDate">Approved By:</label>
                  <input type="text" name="appBy" id="textfield">
                </p>
                <p>
                  <label for="comments">Comments:</label>
                </p>
                <p>
                  <textarea name="comments" id="textarea" cols="60" rows="2"></textarea>
                </p></TD>
                <TR>
		
				
		</TR>
                <tr>
		<td><small><label style="font-size:small;font-family:arial, helvetica, sans-serif">Please select the report rendering format</label>&nbsp;<strong></strong>
			<span style="font-size:small;font-family:arial, helvetica, sans-serif"><br></span><input type="radio" name="render" value="pdfPDF"><span style="font-size:small;font-family:arial, helvetica, sans-serif">PDF<br></span>
			<input type="radio" name="render" value="docWORD"><span style="font-size:small;font-family:arial, helvetica, sans-serif">Word</span> </small><br></div>  </td></tr>
		
		
		
		
			<TR>
			
				<TD class="detailFormColumn" style="padding-top: 10px;">
	
		</TD>
		</TR>
		

		
		
		

		
		<TR>
		<TD class="detailFormColumn" style="padding-top: 10px;">
		
		<TR>
		<TD><br><br>
				<input type="submit" id="9" value="Generate Report"/>
		</TD>		
		<TD></TD>
		</TR>
	</TABLE>
	</FORM>	

</FONT>
</BODY>
</HTML>