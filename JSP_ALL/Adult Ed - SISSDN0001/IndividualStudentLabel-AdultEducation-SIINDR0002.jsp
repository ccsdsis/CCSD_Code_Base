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


	//variable used when assembling the gradelevel droplist
	String grade = null;
	
	//variables to gather the choices the user has made and concat them into the URL

    //variables for grade levels selected
    	
	//variables needed for SQL statements to work
	String SQL1 = null;
	ResultSet result1 = null;

	//variables needed for page to know itself and call the right report
	String dir = "StudentLabels-SIREDN0002/";
	String srsReportName = "IndividualStudentLabel-AdultEducation-SIINDR0002";
	String jspPageName = "IndividualStudentLabel-AdultEducation-SIINDR0002";
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

		//Build ReportServer URL

		String url = path+dir+srsReportName+"&personID="+contextID+"&schoolId="+schoolID+"&endYear="+endYear;
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
	
    <style type="text/css">
        .style2
        {
            font-size: xx-small;
        }
        .style3
        {
            width: 640px;
        }
    </style>
<script language="javascript" type="text/javascript">
<!--
/****************************************************
     Author: Eric King
     Url: http://redrival.com/eak/index.shtml
     This script is free to use as long as this info is left in
     Featured on Dynamic Drive script library (http://www.dynamicdrive.com)
****************************************************/
var win=null;
function NewWindow(mypage,myname,w,h,scroll,pos){
if(pos=="random"){LeftPosition=(screen.width)?Math.floor(Math.random()*(screen.width-w)):100;TopPosition=(screen.height)?Math.floor(Math.random()*((screen.height-h)-75)):100;}
if(pos=="center"){LeftPosition=(screen.width)?(screen.width-w)/2:100;TopPosition=(screen.height)?(screen.height-h)/2:100;}
else if((pos!="center" && pos!="random") || pos==null){LeftPosition=0;TopPosition=20}
settings='width='+w+',height='+h+',top='+TopPosition+',left='+LeftPosition+',scrollbars='+scroll+',location=no,directories=no,status=no,menubar=no,toolbar=no,resizable=yes';
win=window.open(mypage,myname,settings);}
// -->
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
	      <% 
			Statement db1 = con.createStatement();
		    SQL1 = " select case when personID is null then 'NO STUDENT SELECTED' " +
					" when personID is not null then (StuName + ' - ' + STNO) end as student " +
				   " from v_CCSD_IndivStuLabel_AD " +
				   " where personID = " + contextID +
				   " and endYear = " + endYear +
				   " and schoolID = " + schoolID +
					" and RowNum = 1 " ;

    result1 = db1.executeQuery(SQL1);
			
%>
	<TABLE cellpadding="0" cellspacing="0" width="640">
		<TR>
		<TD class="wizardHeader" width="100%" style="height: 21px;">   Individual Student Label </TD>
		</TR>
		
		<TR>
		<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;" valign="top">
		    Print a single student label using a DYMO printer (#30323 (3 1/2 X 1 1/8) label).<br />
            <br />
            <strong>INSTRUCTIONS: </strong><br />
			The label will print for the student you are currently viewing in <strong> Student Information > General </strong>.  Please make sure you are viewing the student you need to print a label on before using this report.
			After pressing PRINT, the label will load as a PDF, print from the PDF file to your DYMO printer.</br></br>
			<a href="http://www.screencast.com/t/pPdNQZanDr" onclick="NewWindow(this.href,'Student Label Demo','1100','900','no','center');return false" onfocus="this.blur()">Watch Quick Demo Video</a></br></br>
			You must disable pop-up blockers in order to watch the video.</br></br>
&nbsp;</TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"><IMG height="2" src="images/hr.gif"></TD>
		</TR>
	</TABLE>
		
	<TABLE cellpadding="0" cellspacing="2">
		<tr>
			<td>
			<FONT style="font-family: arial, helvetica, sans; font-size: 11pt; color: #000000; font-weight: normal;">
			<strong>YOUR ARE PRINTING A LABEL FOR THE FOLLOWING STUDENT:</strong></BR></BR>
			</FONT>
			</td>
			<tr>
			<td>
			<FONT style="font-family: arial, helvetica, sans; font-size: 9pt; color: #000000; font-weight: normal;">
			<% while(result1.next()){ %>
				<%= result1.getString(1) %> </BR></BR></BR>
			</FONT>
			<% } %>
			</td>
			</tr>
		</tr>
		<tr>
		<TD class="style3">
		<FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
		<input type="submit" id="9" value="PRINT LABEL"/></FONT></TD>
		</TR>
	</TABLE>
    <% con.close(); %>
	</FORM>	

</FONT>
</BODY>
</HTML>