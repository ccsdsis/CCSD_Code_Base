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
	String schoolIDValue = request.getParameter("schoolIDList");
        String personIDValue = request.getParameter("StaffPersonIDList"); 
	String counselorname = request.getParameter("StaffPersonIDList");
	String TestDateValue = request.getParameter("TestDate");	
	String rValue = request.getParameter("render");
        String GradeValue = request.getParameter("GradeValueList");
        String TermValue = request.getParameter("TermValueList");
        String TermName = request.getParameter("TermValueList");
		
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
	String dir = "CounselorReportProject-CNREDN0001/";
	String srsReportName = "SeniorFailureNotification-Spanish-CNREDR0003";
	String jspPageName = "SeniorFailureNotification-Spanish-CNREDR0003";

	
	
	
	
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
		String url = path+dir+srsReportName+"&schoolID="+schoolID+"&staffPersonID="+personIDValue+"&endYear="+endYear+"&grade="+GradeValue+"&termID="+TermValue+"&TestDate="+TestDateValue;
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
      $(function () {
          $("#datepicker").datepicker();
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
		<TD class="wizardHeader" width="100%" style="height: 21px;">&nbsp;Senior Failure Notification (Spanish)</TD>
		</TR>
		
		<TR>
		<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;" valign="top">
		The Senior Failure Notification report produces a letter in Spanish for each student who is currently failing one or more courses for the selected counselor(s).<br/><BR/><BR/>
		</TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"></TD>
		</TR>
	</TABLE>
	
        <TR>
			<TD class="detailFormColumn" style="padding-top: 10px;">
 <%

			Statement db2 = con.createStatement();
			int newRecords2 = 0;
		    SQL2 = "EXEC  [dbo].[sp_TCCSD_CounselorsBySchoolWithAll-CNCSDP0001] " + schoolID;

			result2 = db2.executeQuery(SQL2);


			out.println("<label>Select Counselor:</label><br/><select name=StaffPersonIDList id=16><option value='NULL' selected='false'> </option>");
			while(result2.next())
			{ personIDValue=result2.getString(1); 
			counselorname = result2.getString(2);
			out.println("<option value='"+personIDValue+"'>"+counselorname+"</option>");}
			out.println("</select>");
			


%>
		<br/>
		</TD>	
		</TR><TR>
		
				<TD class="detailFormColumn" style="padding-top: 10px;">
<%
			Statement db3 = con.createStatement();
			int newRecords3 = 0;
		    SQL3 = " select distinct gl.name as GradeValue from " +
			   " gradelevel as gl with (nolock) " +
			   " inner join calendar as cal with (nolock) on cal.calendarID = gl.calendarID and cal.calendarID = " + calendarID + 
				" and cal.schoolID = " + schoolID +
				" and cal.endYear = " + endYear +
				" order by gl.name desc " ;

			result3 = db3.executeQuery(SQL3);

			out.println("<br/><label>Select Grade Level:</label><br/><select name=GradeValueList id=17><option value='null' selected='false'> </option>");
			while(result3.next())
			{ GradeLevelValue = result3.getString(1);
			out.println("<option value='"+GradeLevelValue+"'>"+GradeLevelValue+"</option>");}
			out.println("</select>");
		
%>		
		</TD>
                <TR>
		
				<TD class="detailFormColumn" style="padding-top: 10px;">
<%
			Statement db4 = con.createStatement();
			int newRecords4 = 0;
		    SQL4 = " select distinct tm.termID, tm.name as term " +
                            " from term as tm with (nolock) " +
                            " inner join termschedule as ts with (nolock) on ts.termScheduleID = tm.termScheduleID " +
                            " inner join scheduleStructure as ss with (nolock) on ss.structureID = ts.structureID and ss.calendarID = " + calendarID ;

			result4 = db4.executeQuery(SQL4);

			out.println("<br/><br><label>Select Term:</label><br/><select name=TermValueList id=18><option value='null' selected='false'> </option>");
			while(result4.next())
			{ TermValue = result4.getString(1);
                        TermName = result4.getString(2);
			out.println("<option value='"+TermValue+"'>"+TermName+"</option>");}
			out.println("</select>");
			
			con.close();
%>		
		</TD>
		</TR>
                <TR>
                    <td ></br><br>Select Summer Test Date:
                    <input type="text" name="TestDate" id="datepicker">
                    </td>
                </TR>
                
		</TR>
		<tr>
		<td><small><br><br><label style="font-size:small;font-family:arial, helvetica, sans-serif">Please select the report rendering format</label>&nbsp;<strong></strong>
			<span style="font-size:small;font-family:arial, helvetica, sans-serif"><br></span>
			            <input type="radio" name="render" value="pdfPDF"><span style="font-size:small;font-family:arial, helvetica, sans-serif">PDF<br></span>
			            <input type="radio" name="render" value="csvCSV"><span style="font-size:small;font-family:arial, helvetica, sans-serif">Comma Separated Values (CSV)</br>
                        <input type="radio" name="render" value="xlsEXCEL"><span style="font-size:small;font-family:arial, helvetica, sans-serif">Excel</span></br> 
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