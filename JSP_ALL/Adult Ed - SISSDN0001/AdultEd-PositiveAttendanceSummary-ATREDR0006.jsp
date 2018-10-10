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
	String endYear = Prism.getCookie(request, "endYear");
	String schoolID = Prism.getCookie(request, "schoolID");
	String sectionID = Prism.getCookie(request, "sectionID");
	String structureID = Prism.getCookie(request, "structureID");
    String personID = Prism.getCookie(request, "personID");	

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
	String personID2 = null;
	String AllPersonIDs = null;
	String StudentName = null;
	String Term = null;

	
	//variables to gather the choices the user has made and concat them into the URL
	String schoolIDValue = request.getParameter("schoolIDList");
    String[] personIDValue = request.getParameterValues("personIDList"); 
	String TermValue = request.getParameter("termIDList");
		
	//variables needed for SQL statements to work
	String SQL1 = null;
	String SQL2 = null;
	String SQL3 = null;
	String SQL4 = null;
	ResultSet result1 = null;
	ResultSet result2 = null;
	ResultSet result3 = null;
	ResultSet result4 = null;
	
	//variables needed for page to know itself and call the right report
	String dir = "AdultEd-SISSDN0001/";
	String srsReportName = "AdultEd-PositiveAttendanceSummary-ATREDR0006";
	String jspPageName = "AdultEd-PositiveAttendanceSummary-ATREDR0006";

	
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
		
		

		//Build ReportServer URL
		
		//Get the values from the personIDValue array an put them into a comma delimited string
		AllPersonIDs = personIDValue[0];
		for(int i=1; i<personIDValue.length; i++)
		{
		AllPersonIDs = AllPersonIDs + "," + personIDValue[i];
		}
		String url = path+dir+srsReportName+"&calendarID="+calendarID+"&personID="+AllPersonIDs+"&termName="+TermValue;
		url += "&rs%3AFormat=PDF";


		//Launch report		

		//out.println("<script>log('"+url+"');</script>");
		response.sendRedirect(baseURL+"/ccsdReports/rsPassThruPDF.jsp?url="+URLEncoder.encode(url));

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
		<TD class="wizardHeader" width="100%" style="height: 21px;">&nbsp;Positive Attendance Summary</TD>
		</TR>
		
		<TR>
		<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;" valign="top">
		This report generates a Positive Attendance Summary for each student selected and the selected term.  </br>
		</br></br>
		</TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"><IMG height="2" src="images/hr.gif"></TD>
		</TR>
	</TABLE>
	
        <TR>
			<TD class="detailFormColumn" style="padding-top: 10px;">
 <%

			Statement db2 = con.createStatement();
			int newRecords2 = 0;
		    SQL2 = "EXEC  [dbo].[st_CCSD_StudentNamesBySchool-SISSDP0004] " + schoolID;

			//PreparedStatement ps = con.prepareStatement(SQL2);
			//ps.setEscapeProcessing(true);
			//ps.setQueryTimeout(<timeout value>);
			//ps.setString(1, schoolID);

			//Re rs = ps.executeQuery();

			result2 = db2.executeQuery(SQL2);


			out.println("<label> </br><strong>Students</br></strong></label><br/><label>To Select Multiple Students, hold the CTRL button and select students</label><br/><select name=personIDList multiple id=16 style='width:250px; height:450px;'><option value='NULL' selected='true'>Select</option>");
			while(result2.next())
			{ personID2=result2.getString(2); 
				StudentName = result2.getString(1);
			out.println("<option value='"+personID2+"'>"+StudentName+"</option>");}
			out.println("</select>");
			

%>
		<br/>
		</TD>	
		</TR>
		<tr>
			<td>
			 <%

			Statement db3 = con.createStatement();
			int newRecords3 = 0;
		    SQL3 = "EXEC  [dbo].[sp_CCSD_TermsByCalendar-SCFTDP0001] " + calendarID;


			result3 = db3.executeQuery(SQL3);


			out.println("<br/><label>Term</label><br/><select name=termIDList id=17><option value='NULL' selected='true'>Select</option>");
			while(result3.next())
			{ Term = result3.getString(1);
			out.println("<option value='"+Term+"'>"+Term+"</option>");}
			out.println("</select>");
			
			con.close();

%>
			</td>
		</tr>

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