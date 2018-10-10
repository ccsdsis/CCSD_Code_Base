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
	String Date1Select = request.getParameter("Date1");
	String Date2Select = request.getParameter("Date2");
	String rValue = request.getParameter("render");
	
	
	//variables needed for page to know itself and call the right report
	String dir = "AdultEd-SISSDN0001/";
	String srsReportName = "GoodTimeReport-ATALDR0002";
	String jspPageName = "GoodTimeReport-ATALDR0002";	
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

		String url = path+dir+srsReportName+"&calendarID="+calendarID+"&date1="+Date1Select+"&date2="+Date2Select;
		url += "&rs%3AFormat="+render+"";


		//Launch report		

		//out.println("<script>log('"+url+"');</script>");	
		response.sendRedirect(pagePath+"/rsPassThruMulti.jsp?url="+URLEncoder.encode(url)+"&ext="+ ext +"&srsReportName="+ srsReportName + "");

		}
%>

<% con.close(); %>
<html>
<head>
    <base href="<%= baseURL %>" />
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title></title>
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

    </script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
  <script src="//code.jquery.com/jquery-1.10.2.js"></script>
  <script src="//code.jquery.com/ui/1.11.1/jquery-ui.js"></script>
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script>
      $(function () {
          $("#Date1").datepicker();
      });
  </script>
  <script>
      $(function () {
          $("#Date2").datepicker();
      });
  </script>
</head>

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
        <form name='rsPass' action="<%= pagePath %><%= jspPageName %>.jsp?callrspassthru=true" method="post" "> <!--(this version works for most districts-->
<TABLE cellpadding="0" cellspacing="0" width="640">
		<TR>
		<TD class="wizardHeader" width="100%" style="height: 21px;">ADULT EDUCATION - HOURS OF ATTENDANCE</TD>
		</TR>
		
		<TR>
		<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;" valign="top">
		    Report produces the hours of attendance per student based on the dates selected and the current school/calendar. <br></br></TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"><IMG height="2" src="images/hr.gif"></TD>
		</TR>
	</TABLE>
      <table class="style1">
                <tbody><tr>
                    <td style="vertical-align:top">
                        Hours of Attendance Between:<br>
                    </td>
                    <td>
                        <input type="text" name="Date1" id="Date1"></td>
                </tr>
                <tr>
                    <td style="vertical-align:top">
                        AND</td>
                    <td>
    <span style="color:#000000;font-weight:normal">
                        <input type="text" name="Date2" id="Date2"></span></td>
                </tr>
        <tr>
        </tr>
            </tbody></table><br>  </div><div><strong>
			<label style="font-size:medium;font-family:arial, helvetica, sans-serif">Please select the report rendering format</label>&nbsp;</strong>
			<span style="font-size:medium;font-family:arial, helvetica, sans-serif"><br></span><input type="radio" name="render" value="pdfPDF"><span style="font-size:medium;font-family:arial, helvetica, sans-serif">PDF<br></span>
			<input type="radio" name="render" value="csvCSV"><span style="font-size:medium;font-family:arial, helvetica, sans-serif">Comma Separated Values (CSV)</span>  <br></div>  
            <p><input type="submit" id="9" value="Generate Report" /></td></p>
        </form>
</table>
    </font>
</body>
</html>
