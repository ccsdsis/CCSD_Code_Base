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
	
	//variables to gather the choices the user has made and concat them into the URL
	String AthCourse = request.getParameter("AthCourseSelection");
        String CourseName = request.getParameter("AthCourseSelection");
        String SQL1 = null;
	ResultSet result1 = null;
	
	//variables needed for page to know itself and call the right report
	String dir = "AthleticRosters-SCRODN0001/";
	String srsReportName = "AthleticSectionRostersBySport-SCRODR0003";
	String jspPageName = "AthleticSectionRostersBySport-SCRODR0003";	
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

		String url = path+dir+srsReportName+"&calendarID="+calendarID+"&Course="+AthCourse;
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
	<TITLE>Senior Check Out Card</TITLE>
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
		<TD class="wizardHeader" width="100%" style="height: 21px;">ATHLETIC SECTION ROSTERS</TD>
		</TR>
		
		<TR>
		<TD class="style2" 
                style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;" 
                valign="top" bgcolor="White">
		    This report produces a roster of each athletic section based on the season(s) selected below or the specific section selected.  Roster data is pulled from the Athletics 
            sections.</br></TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"><IMG height="2" src="images/hr.gif"></TD>
		</TR>
	</TABLE>
	
	<table class="style1">

        <tr>

            			<TD class="detailFormColumn" style="padding-top: 10px;">
 <%

			Statement db1 = con.createStatement();
			int newRecords2 = 0;
		    SQL1 = "  select distinct number, name " + 
                            " from coursemaster where substring(number, 1,3) " + 
                            " = 'ATH' " +
                            " order by name ";
                            

			result1 = db1.executeQuery(SQL1);


			out.println("<label>Select Sport:</label><select name=AthCourseSelection><option value='NULL' selected='false'> </option>");
			while(result1.next())
			{ AthCourse=result1.getString(1); 
			CourseName = result1.getString(2);
			out.println("<option value='"+AthCourse+"'>"+CourseName+"</option>");}
			out.println("</select>");
			
			con.close();

%>
		<br/></td>
        </tr>
    </table>
<p><input type="submit" id="9" value="Generate Report"/></td></p>
	</FORM>	

</FONT>
</BODY>
</HTML>


