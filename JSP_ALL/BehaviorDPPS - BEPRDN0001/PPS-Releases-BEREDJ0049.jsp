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

// PPS-Releases-BEREDJ0049.jsp
// SIS-6038 2018-06-06 (FM) Add "date override" functionality to bypass PPS Review Date logic that requires the date be >= current date. 
// SIS-5646 2017-12-21 (FM) New - Custom Report - Behavior>Behavior DPPS>PPS Releases
//                          Input criteria: PPS ReviewDate (@reviewDateIn) populated from Behavior DPPS records where DPPS Close Date is null
//
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
	String rValue = request.getParameter("render");

	//variables to gather the choices the user has made and concat them into the URL
	String reviewDateRfmt   = null;
	String reviewDate       = null;
	
	//variables to gather the choices the user has made and concat them into the URL
	String reviewDateValue  = request.getParameter("reviewDateList");
	String selectoverRide   = request.getParameter("overRide");
		
	//variables needed for SQL statements to work
	String SQL1 = null;				//for user group list processing
	ResultSet result1 = null;  		//for user group list processing
	String fnSQL1 = null;			//for user group list processing
	ResultSet fnresult1 = null; 	//for user group list processing
	
	//variables needed for page to know itself and call the right report
	String dir = "Behavior-BEPRDN0001/";
	String srsReportName = "PPS-Releases-BEREDR0049";
	String jspPageName   = "PPS-Releases-BEREDJ0049";

	
%>

<SCRIPT LANGUAGE="JavaScript">

function log(message) 
{
    if (!log.window_ || log.window_.closed) 
	{
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
			// Resolve null parameter - Field editing performed by onValidate form function
			String PrintReport = "Yes";

			//Launch report	
			// produce XLS or CSV file format report file		
			String ext    = rValue.substring(0,3);
			String render = rValue.substring(3,rValue.length());

			//Build ReportServer URL
			String url = path+dir+srsReportName+"&reviewDateIn="+reviewDateValue+"&overRide="+selectoverRide;
    	      url += "&rs%3AFormat="+render+"";	
			//out.println("AFTER build url");

			//Launch report		
			//out.println("launch report");	
			if (PrintReport.equals("Yes")) 
			{			
				//out.println("<script>log('"+url+"');</script>");	
				response.sendRedirect(pagePath+"/rsPassThruMulti.jsp?url="+URLEncoder.encode(url)+"&ext="+ ext +"&srsReportName="+ srsReportName + "");
			}
		
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
   // $(function() 
   //{
		// $( "#datepicker" ).datepicker();
	    // $( "#datepicker2" ).datepicker();
	//}
	//);  
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
		<TD class="wizardHeader" width="100%" style="height: 21px;">&nbsp; &nbsp; &nbsp;PPS Releases</TD>
		</TR>
		
		<TR>
			<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;" valign="top">
			This Behavior DPPS report generates a list of PPS Releases.<BR>
			Selected records do not have a Close Date and have a PPS Review Date greater than or equal to today.</br><br>If PPS Review Date Override is selected, all PPS Release records that do not have a Close Date are reported. The PPS Review Date can be earlier than today.<br><br>This report is generated in CSV or Excel formats.<br></br>
			</TD>
		</TR>

		<TR>
			<TD width="100%" height="2" background="images/hr.gif"><IMG height="2" src="images/hr.gif"></TD>
		</TR>
	</TABLE>

		<table style='table-layout:fixed; padding-top: 0px' width="640"><col width=300><col width=5><col width=200>
        <TR>
			<TD class="detailFormColumn" style="padding-top: 10px; padding-left: 30px">
 <%
			Statement db2 = con.createStatement();
			int newRecords1 = 0;
			SQL1 =  " DECLARE @PPSReviewDate     int = (select attributeid from campusattribute with (nolock) where object='Behavior DPPS' and element='PPSReviewDate') " +
					" DECLARE @DPPSCloseDate     int = (SELECT attributeid FROM campusattribute with (nolock) WHERE object='Behavior DPPS' AND element='DPPSCloseDate') " +
					" SELECT DISTINCT cs.value AS reviewDate " +
					" ,( CASE WHEN cs.value IS NOT NULL THEN SUBSTRING(cs.value,7,4) + '/' + SUBSTRING(cs.value, 1,2) + '/' +  SUBSTRING(cs.value,4,2) " +   
					"         ELSE NULL END ) AS reviewDateRefmt " +  
					" FROM customstudent cs WITH (nolock) " + 
					" LEFT OUTER JOIN  customstudent  cs2  WITH (nolock) ON cs2.personid = cs.personid and cs2.attributeid = @DPPSCloseDate and cs2.date = cs.date " +
					" WHERE cs.attributeid = @PPSReviewDate " +
					"  AND cs2.date      IS NULL " +
					" ORDER by reviewDateRefmt asc " ;

			result1 = db2.executeQuery(SQL1);
			out.println("<label><br><strong>&nbsp;&nbsp;&nbsp;Select PPS Review Date:</strong></label><br/><select name='reviewDateList' id='reviewDateList'><option value='0'>SELECT ALL</option>");
			while(result1.next())
				{reviewDate      = result1.getString(1);
				out.println("<option>"+reviewDate+"</option>");}
				out.println("</select>");

        con.close();
%>
            </TD>
			<TD> </TD>			
            <TD class="detailFormColumn" style="padding-top: 11px;"><STRONG><label style="font-family:arial, helvetica, sans-serif"></br>PPS Review Date Override:</label></STRONG><BR>
                <INPUT id="overRide" name="overRide" type="checkbox" value="Y" />
			</TD>
       	</TR>
	</TABLE>
	
			<div><br><br><strong>
			<label style="font-family:arial, helvetica, sans-serif">&nbsp;&nbsp;&nbsp;Please select the report rendering format</label>&nbsp;</strong>
			<span style="font-family:arial, helvetica, sans-serif"><br></span>
			<input type="radio" name="render" value="csvCSV" checked="checked"><span style="font-family:arial, helvetica, sans-serif">Comma Separated Values (CSV)</span><br>
			<input type="radio" name="render" value="xlsEXCEL"><span style="font-family:arial, helvetica, sans-serif">Excel (XLS)</span>  <br>
			</div>  
            <p><input name="submit" type="submit" id="submit" value="Generate Report" /></td></p>
	</FORM>	

</FONT>
</BODY>
</HTML>
