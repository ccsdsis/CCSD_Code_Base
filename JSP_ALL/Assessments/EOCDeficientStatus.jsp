<%-- jsp script for "EOC Assessment Status Report" --%>
<%-- Date written: Apr 12, 2016 --%>
 
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
 
    Object sessUser = session.getAttribute("user"); //this line needed for later Campus versions

	//variables to gather the choices the user has made and concat them into the URL
	//String Date1Select = request.getParameter("Date1");
	//String Date2Select = request.getParameter("Date2");
    String GradeListValue = request.getParameter("gradeList");
	String rValue = request.getParameter("render");
	
	
 	//variables needed for page to know itself and call the right report
 	String dir = "EOCAssessmentStatus/";	
	String srsReportName = "EOCDeficientStatus";
	String jspPageName = "EOCDeficientStatus";

	
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
 		String errMessage1 = "Grade level must be entered";
 		String errMessage3 = "Please select the report file format";
  		
		String PrintReport = "Yes";
		// Check Grade value is null or empty when school is not selected  
        //if schoolID = null 
        //  null; 		
		
  		if (GradeListValue.equals("NULL") || GradeListValue.isEmpty()) {	
     	      out.println("<script>log('"+errMessage1+"');</script>");
  	          PrintReport = "No"; 		  
		      GradeListValue = " "; 
		}

		if (rValue == null) {
		   out.println("<script>log('"+errMessage3+"');</script>");
	       PrintReport = "No"; 		 			 
		 //  break label2;
		//  rValue = "pdfPDF";
		}

		String ext = rValue.substring(0,3);
	    String render = rValue.substring(3,rValue.length());
		String GradeListValue2 = GradeListValue.replaceAll(" ","%20"); 
		
		// produce PDF or csv file format report file 

		//Build ReportServer URL
		String url = path+dir+srsReportName+"&schoolID="+schoolID+"&endYear="+endYear+"&gradeList="+GradeListValue2;
    	url += "&rs%3AFormat="+render+"";				 
		 
		//Launch report		
		if (PrintReport.equals("Yes")) {	
 		//out.println("<script>log('"+url+"');</script>");	
		response.sendRedirect(pagePath+"/rsPassThruMulti.jsp?url="+URLEncoder.encode(url)+"&ext="+ ext +"&srsReportName="+ srsReportName + "");
        } 		 
	 }
	
%>


<html>
<head>
    <base href="<%= baseURL %>" />
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <TITLE>Report</TITLE>
    <link rel="stylesheet" href="styles/lens.css" type="text/css" />
    <style type="text/css">
        .style1 {
            width: 600px;
        }

        .style2 {
            height: 94px;
        }
    </style>

    <script language="JavaScript">

		var studentArray = new Array();

	</script>

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

<body bgcolor="#E0E0E0" topmargin="4" leftmargin="4">
    <font style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">

       <%

	   } //ends the try block

        catch(Exception ex)
        {

        System.out.println("error occurred" + ex.getMessage());
        out.println("<b>"+ex.getMessage()+"</b>"); out.flush();
        throw ex;
        }

        %>

		
		<% con.close(); %>

        <form name='rsPass' action="<%= pagePath %><%= jspPageName %>.jsp?callrspassthru=true" method="post" "> <!--(this version works for most districts-->

	<TABLE cellpadding="0" cellspacing="0" width="640">
		<TR>
		<TD class="wizardHeader" width="100%" style="height: 21px;">&nbsp;EOC Deficient Status Report</TD>
		
		</TR>
		
		<TR>
		<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;" valign="top">
		 This report produces an End Of Course exam (EOC) Assessment status report for active students based on the given grade levels and selected school.
		 <p>Users with access to all schools can select <strong>All Schools</strong> from the School drop down list to export the report for the entire district.</p>
		 <p>&nbsp;</p> 
		</TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"><IMG height="2" src="images/hr.gif"></TD>
		</TR>
	</TABLE>
	
	
		
      <table class="style1">
            <tbody>				
			<tr>
			<%-- Check for comment --%>
                    <td style="font-size:medium;vertical-align:top">
                        Grade Levels:		   			
                        <input type="text" name="gradeList" id="gradeList">					
					<tr>
					<td <label style="padding-left: 50px; font-size:small;font-family:arial, helvetica, sans-serif">(Separate multiple grades with comma)</label></td>
					</tr>
					</td> <br>
			<%-- Check for comment --%>
            </tr>
         <tr>
        </tr>
            </tbody></table><br>  </div><div><strong>
			<label style="font-size:medium;font-family:arial, helvetica, sans-serif">Please select the report rendering format</label>&nbsp;</strong>
			<span style="font-size:medium;font-family:arial, helvetica, sans-serif"><br></span><input type="radio" name="render" value="pdfPDF" checked="checked" ><span style="font-size:medium;font-family:arial, helvetica, sans-serif">PDF<br></span>
			<input type="radio" name="render" value="csvCSV"><span style="font-size:medium;font-family:arial, helvetica, sans-serif">Comma Separated Values (CSV)</span>  <br></div>  
            <p><input type="submit" id="9" value="Generate Report" /></td></p>
        </form>
</table>
    </font>
</body>
</html>
