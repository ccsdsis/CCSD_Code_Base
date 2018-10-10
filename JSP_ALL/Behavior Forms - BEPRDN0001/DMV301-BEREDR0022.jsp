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
	String rValue = request.getParameter("render");
	String dlnum = request.getParameter("dlNumText");
	String firstoffense = request.getParameter("firstOffenseCB");
	String dlsusp1 = request.getParameter("dlSuspCB1");
	String dlsuspdays1 = request.getParameter("dlsuspdays1Text");
	String issuance30 = request.getParameter("issuance30CB");
	String secondoffense = request.getParameter("secondOffenseCB");
	String dlsusp2 = request.getParameter("dlSuspCB2");
	String dlsuspdays2 = request.getParameter("dlsuspdays2Text");
	String issuance60 = request.getParameter("issuance60CB");

	//variables needed for SQL statements to work
	String SQL2 = null;
	ResultSet result2 = null;
	String SQL1 = null;
	ResultSet result1 = null;
	
	//variables needed for page to know itself and call the right report
	String dir = "Behavior-BEPRDN0001/";
	String srsReportName = "DMV301-BEREDR0022";
	String jspPageName = "DMV301-BEREDR0022";

	
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
		String dlnumOutput = dlnum.replace(" ","%20");
		String dlsuspdays1ValueOutput = dlsuspdays1.replace(" ","%20");
		String dlsuspdays2ValueOutput = dlsuspdays2.replace(" ","%20");
		
		String url = path+dir+srsReportName+"&dlnum="+dlnumOutput+"&firstoffense="+firstoffense+"&dlsusp1="+dlsusp1+"&dlsuspdays1="+dlsuspdays1ValueOutput+"&issuance30="+issuance30;
		url += "&secondoffense="+secondoffense+"&dlsusp2="+dlsusp2+"&dlsuspdays2="+dlsuspdays2ValueOutput+"&issuance60="+issuance60;
		url += "&calendarID="+calendarID+"&personID="+contextID;
		url += "&rs%3AFormat="+render+"";

		//Launch report	
		//out.println("<script>log('"+url+"');</script>");
		response.sendRedirect(pagePath+"/rsPassThruMulti.jsp?url="+URLEncoder.encode(url)+"&ext="+ ext +"&srsReportName="+ srsReportName + "");

		}
%>

        <% con.close(); %>
<HTML>
<HEAD>
	<BASE HREF="<%= baseURL %>"/>
	<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
	<TITLE>Report</TITLE>
	<LINK rel="stylesheet" href="styles/lens.css" type="text/css"/>
	<script src="jquery-1.11.1.min.js" type="text/javascript"></script>
	<script src="jquery.ui-1.10.4.datepicker.min.js" type="text/javascript"></script>
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
  <link href="jquery.ui.core.min.css" rel="stylesheet" type="text/css">
  <link href="jquery.ui.theme.min.css" rel="stylesheet" type="text/css">
  <link href="jquery.ui.datepicker.min.css" rel="stylesheet" type="text/css">
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
		<TD class="wizardHeader" width="100%" style="height: 21px;">&nbsp;&nbsp;DMV-301 Certification of Attendance (NRS 392)</TD>
		</TR>
		
		<TR>
		<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;font-size: 10px; font-weight: bold;" valign="top">
		  <p style="font-size: 8pt">Print a DMV-301 Certification of Attendance form for the selected student.		  </p>
		  <p></TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"></TD>
		</TR>
	</TABLE>
	
        <TR>
		  <TD class="detailFormColumn" style="padding-top: 10px;">
          <p><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;"></br>
          </br>DRIVER'S LICENSE/INSTRUCTION PERMIT # (if applicable):  
          <input type="text" name="dlNumText" id="dlNumText" value=" ">
          </span></FONT></p>
          <fieldset>
            <legend>First Offense</legend>
            <p>
              <input type="checkbox" name="firstOffenseCB" id="outcome1CB" value=1>
              <label for="firstOffenseCB">First Offense  </label>
              <input type="checkbox" name="dlSuspCB1" id="dlSuspCB1" value=1>
              <label for="dlSuspCB1">Driver's License suspended?  </label>
              <FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
              <input type="checkbox" name="issuance30CB" id="dlSuspCB2" value=1> 
              Issuance Delayed for 30 days?</FONT></p>
            <p>
              <label for="dlsuspdays1Text">Number of Days Driver's License Suspended (min of 30 days no more than six months):</label>
              <input type="text" name="dlsuspdays1Text" id="dlsuspdays1Text" value=" ">
            </p>
            <p><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
              <input type="hidden" name="firstOffenseCB" value="0" />
			  <input type="hidden" name="dlSuspCB1" value="0" />
              <input type="hidden" name="issuance30CB" value="0" />
            </FONT><br></br>
          </p>
          </fieldset>
          <fieldset>
            <legend>Second Offense</legend>
            <p>
              <input type="checkbox" name="secondOffenseCB" id="secondOffenseCB" value=1>
              <label for="secondOffenseCB">Second Offense  </label>
              <input type="checkbox" name="dlSuspCB2" id="dlSuspCB2" value=1>
              <label for="dlSuspCB2">Driver's License suspended?  </label>
              <FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
              <input type="checkbox" name="issuance60CB" id="issuance60CB" value=1>
              <FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">Issuance Delayed for 60 days?</FONT></FONT></p>
            <p>
              <label for="dlsuspdays1Text">Number of Days Driver's License Suspended (min of 60 days no more than one year):</label>
              <input type="text" name="dlsuspdays2Text" id="dlsuspdays2Text" value=" ">
            </p>
            <p><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
              <input type="hidden" name="secondOffenseCB" value="0" />
			  <input type="hidden" name="dlSuspCB2" value="0" />
              <input type="hidden" name="issuance60CB" value="0" />
            </FONT></p>
          </fieldset>
          
          
          </TD>	
		</TR><TR>
		
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