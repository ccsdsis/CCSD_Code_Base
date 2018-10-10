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

// TE-Granted-BEREDJ0045.jsp
// SIS-4678 2017-12-04 (FM) Rename stored procedure to get school years.  Rename st_CCSD_BehDPPSGetSchYears-BEREDP0004 to st_CCSD_GetSchYears
// SIS-4678 2017-10-26 (FM) New - Custom Report - Behavior>Behavior DPPS>Trial Enrollments Granted
//                          Input criteria: 
//                          School Year (@yearIn): dropdown list populated with values for current and previous school years
//                          Quarter Term (@qtrIn): from dropdown list populated with the quarter terms and date ranges specific to school year selected
//                          Term Start Date (@termStartDtIn): from dropdown list populated with the quarter terms and date ranges specific to school year selected
//                          Term End Date (@termEndDtIn): from dropdown list populated with the quarter terms and date ranges specific to school year selected
//							Report Date (@rptDateIn): user-selected date from calendar for report heading
//							Sort Type (@sortIn): N (student last name, firstname), S (TE school name)
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
	String schYearArea       = request.getParameter("schYearArea");
	String termDateArea      = request.getParameter("termDateArea");
	String dropdownSchYear   = null;
	String dropdownRange     = null;
	
    //variables to send to ssrs
	String schYearValue      = schYearArea;
	String qtrValue          = null;
	String startDateValue    = null;
	String endDateValue      = null;
	if (termDateArea != null)
	{
		qtrValue       = termDateArea.substring(0,2);
		startDateValue = termDateArea.substring(9,13) + "-" + termDateArea.substring(3,5)   + "-" + termDateArea.substring(6,8);
		endDateValue   = termDateArea.substring(22)   + "-" + termDateArea.substring(16,18) + "-" + termDateArea.substring(19,21);
	}
	String rptDateValue      = request.getParameter("rptDate");
    String sortInValue       = request.getParameter("sortType");
		
	//variables needed for SQL statements to work
	String SQL1 = null;				//for user group list processing
	ResultSet result1 = null;  		//for user group list processing
	String fnSQL1 = null;			//for user group list processing
	ResultSet fnresult1 = null; 	//for user group list processing
	
	//variables needed for page to know itself and call the right report
	String dir           = "Behavior-BEPRDN0001/";
	String srsReportName = "TE-Granted-BEREDR0045";
	String jspPageName   = "TE-Granted-BEREDJ0045";

	
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

function populateDroplistTermDates() 
{
	//alert("==populateDroplistTermDates function entry");
	
	var termDateList = new Array();
	var elementCount = 0;
	var i = 0;
<%
	Statement fnSQL = con.createStatement();
	//Get list of Quarter Term Dates for current and 1 year prior
	fnSQL1 = "EXEC  [dbo].[st_CCSD_BehDPPSGetQtrTerms-BEREDP0003] ";

	fnresult1 = fnSQL.executeQuery(fnSQL1);	
	while(fnresult1.next())
	{ 
%>
	termDateList[i]    = new Array();
	termDateList[i][0] = "<%=fnresult1.getString(1)%>";       //endYear
	termDateList[i][1] = "<%=fnresult1.getString(2)%>";       //Tname
	termDateList[i][2] = "<%=fnresult1.getString(3)%>";       //TstartDate
	termDateList[i][3] = "<%=fnresult1.getString(4)%>";       //TendDate

	i++;
<%
	}
%>

	var schYearArea  = document.getElementById("schYearArea");
	var termDateArea = document.getElementById("termDateArea");
	
	termDateArea.options.length = 0;
	if (schYearArea.value == "")
	{
		termDateArea.disabled = true;
	} 
	else 
	{
		termDateArea.disabled = false;
		for (var i = 0, j = 1; i < termDateList.length; i++)
		{
			var optField = termDateList[i][0];
			if (optField == schYearArea.value) 
			{
				termDateArea.options[j] = 
				termDateArea.options[j] = new Option(termDateList[i][1] + "  " + termDateList[i][2].substring(5,7) + "/" + termDateList[i][2].substring(8) + "/" + termDateList[i][2].substring(0,4) + " - " + termDateList[i][3].substring(5,7) + "/" + termDateList[i][3].substring(8) + "/" + termDateList[i][3].substring(0,4));
				if (optField == schYearArea)    //not sure what I should be checking here    				    
				{
					termDateArea.options[j].selected = true;
				}
				j++;
			}
		}
		
	}
}

</SCRIPT>

<SCRIPT type="text/javaScript">
function validateForm() 
{
    var schYear = document.forms["rsPass"]["schYearArea"].value;

    if (schYear == "") 
    {    alert("School Year must be selected");
        return false;
    }

    var qtrTerm = document.forms["rsPass"]["termDateArea"].value;
    if (qtrTerm == "") 
    {    alert("Quarter Term must be selected");
        return false;
    }

    var rptDate = document.forms["rsPass"]["rptDate"].value;
    if (rptDate == "") 
    {    alert("Report Date must be selected");
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
			// produce PDF or csv file format report file		
			String ext    = rValue.substring(0,3);
			String render = rValue.substring(3,rValue.length());

			//Build ReportServer URL
			String url = path+dir+srsReportName+"&yearIn="+schYearValue+"&qtrIn="+qtrValue+"&termStartDtIn="+startDateValue+"&termEndDtIn="+endDateValue+"&rptDateIn="+rptDateValue+"&sortIn="+sortInValue;
				url += "&rs%3AFormat="+render+"";	

			//Launch report		
			if (PrintReport.equals("Yes")) 
			{
			out.println("url string=" + url);				
			response.sendRedirect(pagePath+"/rsPassThruMulti.jsp?url="+URLEncoder.encode(url)+"&ext="+ ext +"&srsReportName="+ srsReportName + "");
			}
			
			//DEBUG FIELDS - USE THESE AND COMMENT OUT REPORT LAUNCH FOR DEBUG
			//if (PrintReport.equals("Yes")) 
			//{
			//out.println("schYearArea=" + schYearArea);
			//out.println("termDateArea=" + termDateArea);
			//out.println("schYearValue=" + schYearValue);
			//out.println("qtrValue=" + qtrValue);
			//out.println("startDateValue=" + startDateValue);
			//out.println("endDateValue=" + endDateValue);
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
   $(function() {
    $( "#datepicker" ).datepicker();
	    $( "#datepicker2" ).datepicker();
  });  </script>	
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
		<TD class="wizardHeader" width="100%" style="height: 21px;">&nbsp; &nbsp; &nbsp;Trial Enrollments Granted by Trial Enrollment School or Student Name</TD>
		</TR>
		
		<TR>
			<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;" valign="top">
			This Behavior DPPS report generates a list of trial enrollments that have been granted by the school board.</br><br>
			The report can be sorted by student last name/firstname or Trial Enrollment School Name.<br></br>
			</TD>
		</TR>

		<TR>
			<TD width="100%" height="2" background="images/hr.gif"><IMG height="2" src="images/hr.gif"></TD>
		</TR>
	</TABLE>
	
        <TR>
 <%
// HTML Code
// POPULATE SCHOOL YEAR DROPDOWN LIST AND DRIVE POPULATION OF TERM DATE DROPLIST
// School Year Droplist drives droplist options in Quarter Term Date Droplist
// string(1) = schYear and string(2) = endYearRange
out.println("<tr>");
out.println("<td class='detailFormColumn' style='padding-top: 10px; padding-left: 30px; colspan=2'>");

	Statement db1 = con.createStatement();
	SQL1 = "EXEC  [dbo].[st_CCSD_GetSchYears] ";

result1 = db1.executeQuery(SQL1);

out.println("<label><span><b><br>&nbsp;&nbsp;&nbsp;Select School Year:</b></span></label><br><select name='schYearArea' id='schYearArea' onchange='populateDroplistTermDates();'>");
out.println("<option value=''></option>");

while(result1.next())
{ 
out.println("in schYearArea loop");
	dropdownSchYear  = result1.getString(1);               
	dropdownRange    = result1.getString(2);              
	out.println("<option value='"+dropdownSchYear+"'");
	if(dropdownSchYear.equals(schYearArea))
		out.println(" selected ");
	out.println(">"+dropdownRange);
	out.println("</option>");
}
out.println("</select></td>");

// Quarter Term Date Droplist
//out.println("<td class='detailFormColumn' style='padding-top: 10px;' colspan=2>");
out.println("<td class='detailFormColumn' style='padding-top: 10px; padding-left: 30px; colspan=2'>");
out.println("<label><span><b><br><br><br>&nbsp;&nbsp;&nbsp;Select Quarter Term:</b></span></label><br><select id='termDateArea' name='termDateArea'>");
out.println("</select>");
out.println("</td>");
				
%>
				<br/>	
		</TR>
			<tr>
				<td  valign="top"><br><br><strong>&nbsp;&nbsp;&nbsp;Select Sort Type:</strong></br>
                </td>
				<td><select name="sortType">
					<option value="S">School Name</option>
					<option value="N">Student Last Name</option>
					</select>
				</td>
			</tr>
			<tr>
				<td valign="top">&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td  valign="top"><br><br><br><strong>&nbsp;&nbsp;&nbsp;Select Report Date:</strong></br></td>
				<td><input type="text" name="rptDate" id="datepicker"></td>
			</tr>

		
			<div><br><br><strong>
			<label style="font-family:arial, helvetica, sans-serif">&nbsp;&nbsp;&nbsp;Please select the report rendering format</label>&nbsp;</strong>
			<span style="font-family:arial, helvetica, sans-serif"><br></span>
			<input type="radio" name="render" value="pdfPDF" checked="checked" ><span style="font-family:arial, helvetica, sans-serif">PDF<br></span>
			<input type="radio" name="render" value="csvCSV"><span style="font-family:arial, helvetica, sans-serif">Comma Separated Values (CSV)</span>  <br>
			</div>  
            <p><input type="submit" id="submit" name="submit" value="Generate Report" /></td></p>
	</FORM>	

</FONT>
</BODY>
</HTML>
