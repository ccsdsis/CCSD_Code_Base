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

// BehaviorEventsByCal-BEREDJ0046.jsp
// SIS-4431 2017-12-05 (FM) New - Custom Report - Behavior>Behavior Event Type Counts By Calendar
//                          Input criteria: SchoolYear (@schoolYear) 
//
// variables that already defined because of imports
// appName
// baseURL

	Connection con = Prism.getConnection(appName);

	String calendarID  = Prism.getCookie(request, "calendarID");
	String districtID  = Prism.getCookie(request, "districtID");
	String endYear     = Prism.getCookie(request, "endYear");
	String schoolID    = Prism.getCookie(request, "schoolID");
	String sectionID   = Prism.getCookie(request, "sectionID");
	String structureID = Prism.getCookie(request, "structureID");
    String personID    = Prism.getCookie(request, "personID");	

	Object contextID     = (String) session.getAttribute("contextID");
	Object contextIDType = (String) session.getAttribute("contextIDType");

	CampusApp newurl = Prism.getApp(appName);

	Object sessUser  = session.getAttribute("user"); //this line needed for later Campus versions

	String tempUser    = sessUser.toString();
	int userIndexStart = tempUser.indexOf("userID:") + 7;
	int userIndexEnd   = tempUser.indexOf(" ", userIndexStart);
	String userID      = tempUser.substring(userIndexStart,userIndexEnd);
	int unIndexStart   = tempUser.indexOf("username:") + 9;
	int unIndexEnd     = tempUser.indexOf(" ", unIndexStart);
	String username    = tempUser.substring(unIndexStart,unIndexEnd);
	String rValue      = request.getParameter("render");

    //variables used when assembling the dropdown lists
	String schYear       = null;
	
	//variables to gather the choices the user has made and concat them into the URL
	String schYearArea       = request.getParameter("schYearArea");
	String termDateArea      = request.getParameter("termDateArea");
	String dropdownschYear   = null;
	String dropdownRange     = null;
	
    //variables to send to ssrs
	String schYearValue      = schYearArea;
		
	//variables needed for SQL statements to work
	String SQL1       = null;		//for user group list processing
	ResultSet result1 = null;  		//for user group list processing
	
	//variables needed for page to know itself and call the right report
	String dir           = "Behavior-BEPRDN0001/";
	String srsReportName = "BehaviorEventsByCal-BEREDR0046";
	String jspPageName   = "BehaviorEventsByCal-BEREDJ0046";

	
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

<SCRIPT type="text/javaScript">
function validateForm() 
{
    var schYear = document.forms["rsPass"]["schYearArea"].value;

	//alert("got into validateForm");
	
    if (schYear == "") {
        alert("School Year must be selected");
        return false;
    }
} 
</SCRIPT>

<%

	try
	{

		if (request.getParameter("callrspassthru") != null)
		{
		// Resolve null parameter - Field editing performed by onValidate form function
		String PrintReport = "Yes";

		//Launch report	
		// produce PDF, Excel or csv file format report file		
		String ext    = rValue.substring(0,3);
	    String render = rValue.substring(3,rValue.length());

		//Build ReportServer URL
		String url = path+dir+srsReportName+"&endYear="+schYearValue;
    	      url += "&rs%3AFormat="+render+"";				 

		//Launch report		
		if (PrintReport.equals("Yes")) 
		{	
 		//out.println("<script>log('"+url+"');</script>");	
		response.sendRedirect(pagePath+"/rsPassThruMulti.jsp?url="+URLEncoder.encode(url)+"&ext="+ ext +"&srsReportName="+ srsReportName + "");
        }
					
		//DEBUG FIELDS - USE THESE AND COMMENT OUT REPORT LAUNCH FOR DEBUG
		//if (PrintReport.equals("Yes")) 
		//{
		//out.println("schYear=" + schYear);
		//}
		
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
  // $(function() {
  // $( "#datepicker" ).datepicker();
  // });
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
	<FORM name = 'rsPass' action="<%= pagePath %><%= jspPageName %>.jsp?callrspassthru=true" onsubmit="return validateForm()" method="post"> <!--(this version works for most districts-->
	
	<TABLE cellpadding="0" cellspacing="0" width="640">
		<TR>
		<TD class="wizardHeader" width="100%" style="height: 21px;">&nbsp; &nbsp; &nbsp;Behavior Event Type Counts By Calendar</TD>
		</TR>
		
		<TR>
			<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;" valign="top">
			This Behavior Event Type Counts By Calendar report generates a list of behavior events with the number of times each occurred during the selected school year by Calendar. <br><br>If multiple persons are involved in a behavior event, only the event is counted, not the event per person. In other words, if an individual event involves 10 persons, that event is counted only once.<br><br>
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
		int newRecords1 = 0;
		SQL1 = "EXEC [dbo].[st_CCSD_GetSchYears] ";
		result1 = db2.executeQuery(SQL1);
		out.println("<label><br><strong>&nbsp;&nbsp;&nbsp;School Year</strong></label><br/><select name=schYearArea id=schYearArea><option value='NULL' selected='true'>Select</option>");
		while(result1.next())
		     {dropdownschYear  = result1.getString(1); 
		      dropdownRange    = result1.getString(2);
		      out.println("<option value='"+dropdownschYear+"'>"+dropdownRange+"</option>");}
		      out.println("</select>");
%>
		     <br/>
            </TD>	
	</TR>
		
			<div><br><strong>
			<label style="font-family:arial, helvetica, sans-serif"><br><br>&nbsp;&nbsp;&nbsp;Please select the report rendering format</label>&nbsp;</strong>
			<span  style="font-family:arial, helvetica, sans-serif"><br></span>
			<input type="radio" name="render" value="pdfPDF" checked="checked" ><span style="font-family:arial, helvetica, sans-serif">PDF<br></span>
			<input type="radio" name="render" value="csvCSV"><span style="font-family:arial, helvetica, sans-serif">Comma Separated Values (CSV)</span>  <br>
			<input type="radio" name="render" value="xlsEXCEL"><span style="font-family:arial, helvetica, sans-serif">Excel (XLS)</span>  <br>
			</div>  
            <p><input name"submit" type="submit" id="submit" value="Generate Report" /></td></p>
	</FORM>	

</FONT>
</BODY>
</HTML>
