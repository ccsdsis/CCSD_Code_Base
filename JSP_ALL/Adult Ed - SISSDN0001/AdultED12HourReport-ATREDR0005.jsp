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
	Object sessUser = session.getAttribute("user"); //this line needed for later Campus versions
	
	//variables needed for page to know itself and call the right report
	String dir = "AdultEd-SISSDN0001/";
	String srsReportName = "AdultED12HourReport-ATREDR0005";
	String jspPageName = "AdultED12HourReport-ATREDR0005";	
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

		String url = path+dir+srsReportName+"&calendarID="+calendarID;
		url += "&rs%3AFormat=PDF";


		//Launch report		

		//out.println("<script>log('"+url+"');</script>");
		response.sendRedirect(baseURL+"/ccsdReports/rsPassThruPDF.jsp?url="+URLEncoder.encode(url));

		}
%>
<% con.close(); %>

<HTML>
<HEAD>
	<BASE HREF="<%= baseURL %>"/>
	<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
	<TITLE></TITLE>
	<LINK rel="stylesheet" href="styles/lens.css" type="text/css"/>
    <style type="text/css">
        .style1
        {
            width: 600px;
        }
        .style2
        {
            height: 94px;
        }
    </style>

	<SCRIPT LANGUAGE="JavaScript">


		var studentArray = new Array();



		function loadStudents() 
		{
			document.rsPass.personID.length = 1;
			Index = document.rsPass.grade.options[document.rsPass.grade.selectedIndex].value;
			
			if( Index != 0 ) {
				var students = studentArray[Index]; 

				document.rsPass.personID.options[document.rsPass.personID.length] = new Option('All', 'null', false, false); 
				for (var i=0; i < students.length; i++)
				{
					if (students[i] !=  null && students[i] !="")
					{
						var splitArray = students[i].split('|');
						
						document.rsPass.personID.options[document.rsPass.personID.length] = new Option(splitArray[0], splitArray[1], false, false);
						
					}
				}
			} 
		}

		function changeDate() 
		{
		
			if (document.rsPass.term.value == "2")
			{
				document.rsPass.effectiveDate.value = document.rsPass.t2End.value;
			}
			else if (document.rsPass.term.value == "3")
			{
				document.rsPass.effectiveDate.value = document.rsPass.t3End.value;
			}
			else if (document.rsPass.term.value == "4")
			{
				document.rsPass.effectiveDate.value = document.rsPass.t4End.value;
			}
			else {
				document.rsPass.effectiveDate.value = document.rsPass.t1End.value;
			}
		}		
		
	</SCRIPT>
<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
  <script src="//code.jquery.com/jquery-1.10.2.js"></script>
  <script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script>
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
		<TD class="wizardHeader" width="100%" style="height: 21px;">ADULT EDUCATION - 12 HOUR REPORT</TD>
		</TR>
		
		<TR>
		<TD class="style2" 
                style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;" 
                valign="top" bgcolor="White">
		    The Adult Ed 12 Hour Report generates a summary containing:
			<div><ul><li>Total Registrations (Enrolled and Not Enrolled)</li><li>Registrations 17 - 24 Years Old (Enrolled and Not Enrolled)</li><li>Unduplicated &amp; Duplicated Enrollments</li><li>Unduplicated &amp; Duplicated Enrollments 17-24 Years Old&nbsp;</li><li>ESL &amp; NON ESL Enrollments</li><li>ESL &amp; NON ESL 17 - 24 Years Old Enrollments</li><li>Graduates, Proficiency Only, GED's Adult Ed, GED's Prisons&nbsp;</li><li>Per Cent Unduplicated Enrollment which are ESL</li><li>Per Cent of Registration which have Enrolled at 12 Hours</li><li>Per Cent of Registration which have Enrolled</li></ul></div> 
			<br><br>			
			Report also includes summary of enrollments at 12 hours by ethnicity and gender.
			</br></TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"><IMG height="2" src="images/hr.gif"></TD>
		</TR>
	</TABLE>
	
	<table class="style1">

            <td valign="top">&nbsp;
                </td>
            <td>&nbsp;
                </td>
        </tr>
    </table>
<p><input type="submit" id="9" value="Generate Report"/></td></p>
	</FORM>	

</FONT>
</BODY>
</HTML>
