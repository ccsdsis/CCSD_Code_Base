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
	
	//variables to gather the choices the user has made and concat them into the URL
    String reportID = request.getParameter("reportSel"); 
	if(reportID == null)
		reportID = "";
	String reportGrade = request.getParameter("gradeSel");
	if(reportGrade == null)
		reportGrade = "";
	String rValue = request.getParameter("render");
		
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
	String dir = "MiddleSchoolPromotion/";
	String srsReportName = "MSPromo_Retention";
	String jspPageName = "MSPromotion_Forms";
	
	String dropdownName = "";
	String dropdownValue = "";

	
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
			String url = path+dir+srsReportName+"&EndYear="+endYear+"&SchoolID="+schoolID+"&CustomReportID="+reportID+"&grade="+reportGrade+"&BlankOnly=N";
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
	<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
	<script src="//code.jquery.com/jquery-1.10.2.js"></script>
	<script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
	<link rel="stylesheet" href="/resources/demos/style.css">
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
			<TD class="wizardHeader" width="100%" style="height: 21px;">Middle School Promotion Retention Forms</TD>
			</TR>
			
			<TR>
				<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;" valign="top">
				  <p>Produces various academic awareness forms for the selected School, Year, and Grade.</p><br>
				</TD>
			</TR>

			<TR>
				<TD width="100%" height="2" background="images/hr.gif"></TD>
			</TR>
		</TABLE>
		<table cellpadding="0" cellspacing="0" width="640">
			<tr>
				<td><span style="font-size:small;font-family:arial, helvetica, sans-serif">
						<strong><br>&nbsp;Grade:<br></span>
					<select id="gradeSel" name="gradeSel">
						<option value="06" <%if(reportGrade.equals("06")){out.println("selected");} %> >06</option>
						<option value="07" <%if(reportGrade.equals("07")){out.println("selected");} %> >07</option>
						<option value="08" <%if(reportGrade.equals("08")){out.println("selected");} %> >08</option>
					</select>
				</td>
			</tr>
			<tr>
				<td><span style="font-size:small;font-family:arial, helvetica, sans-serif">
						<strong><br>&nbsp;Retention Report:<br></span>
					<select id="reportSel" name="reportSel">
					<%
						Statement dbSQL = con.createStatement();
						String sqlReports = " select customreportid, customreportname from ccsd_custom.dbo.customreport order by customreportname ";
						ResultSet rsReports = dbSQL.executeQuery(sqlReports);
						//out.println("<option value=''></option>");
						while(rsReports.next())
						{
							dropdownValue = rsReports.getString(1);
							dropdownName = rsReports.getString(2);
							out.println("<option value='" + dropdownValue + "' "); 
							if(reportID.equals(dropdownValue))
								out.println(" selected "); 
							out.println(">" + dropdownName + "</option>");
						}
					%>
					</select>
				</td>
			</tr>
			<tr>
				<td>
					<span style="font-size:small;font-family:arial, helvetica, sans-serif">
						<strong><br>Forms generate in PDF format.</strong>
					</span>
					<br>
					<input name="render" type="radio" value="pdfPDF" checked="checked">
					<span style="font-size:small;font-family:arial, helvetica, sans-serif">PDF</br>
				</td>
			</tr>
			<TR>
				<TD class="detailFormColumn" style="padding-top: 10px;">
					<br><input type="submit" id="9" value="Download File"/>
				</TD>		
			</TR>
		</TABLE>
	</FORM>	
<% con.close(); %>
</FONT>
</BODY>
</HTML>