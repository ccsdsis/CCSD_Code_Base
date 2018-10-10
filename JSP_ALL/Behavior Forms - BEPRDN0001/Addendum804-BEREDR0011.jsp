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
    String summaryText1 = request.getParameter("summaryTextInput1");
	
	String rValue = request.getParameter("render");
		
	//variables needed for SQL statements to work
	String SQL2 = null;
	ResultSet result2 = null;
	
	//variables needed for page to know itself and call the right report
	String dir = "Behavior-BEPRDN0001/";
	String srsReportName = "Addendum804-BEREDR0011";
	String jspPageName = "Addendum804-BEREDR0011";

	
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
		String summaryText1Output = summaryText1.replace(" ","%20");
		String summaryText1Output2 = summaryText1Output.replace("#","%23");
		String summaryText1Output3 = summaryText1Output2.replace("^", "%5E");
		String summaryText1Output4 = summaryText1Output3.replace("&", "%26");
		String summaryText1Output5 = summaryText1Output4.replace("+", "%2B");
		String summaryText1Output6 = summaryText1Output5.replace(">", "%3E");
		String summaryText1Output7 = summaryText1Output6.replace("<", "%3C");
		String summaryText1Output8 = summaryText1Output7.replace("[", "%5B");
		String summaryText1Output9 = summaryText1Output8.replace("]", "%5D");
		String summaryText1Output10 = summaryText1Output9.replace("{", "%7B");
		String summaryText1Output11 = summaryText1Output10.replace("}", "%7D");
		String summaryText1Output12 = summaryText1Output11.replace("\\", "%5C");
		String summaryText1Output13 = summaryText1Output12.replace("|", "%7C");
		String summaryText1Output14 = summaryText1Output13.replace("\"", "%22");

		String url = path+dir+srsReportName+"&personID="+contextID+"&summary1="+summaryText1Output14;
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
        <% con.close(); %>

	<FORM name = 'rsPass' action="<%= pagePath %><%= jspPageName %>.jsp?callrspassthru=true" method="post""> <!--(this version works for most districts-->
	
	<TABLE cellpadding="0" cellspacing="0" width="640">
		<TR>
		<TD class="wizardHeader" width="100%" style="height: 21px;"><span class="wizardHeader" style="height: 21px;">&nbsp;&nbsp;Addendum CCF-804</span></TD>
		</TR>
		
		<TR>
		<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;" valign="top"><p>Print an Addendum CCF-804 form for the selected student.</p>
          <p>PLEASE NOTE: The information selected and entered into this form is not saved and will be lost after you navigate to another page. Do not navigate away from this page until you have completely filled out the form and saved the document. If you need to make changes to the form after you have saved it, you will need to edit the document in Word or Adobe Acrobat.</p>
          <p>Please do not use any special formatting as the report will convert them to plain text.</p>
          <br/><BR/><BR/>
		</TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"></TD>
		</TR>
	</TABLE>
	
        <TR>
			<TD class="detailFormColumn" style="padding-top: 10px;">&nbsp;</TD>	
		</TR><TR>
		
				<TD class="detailFormColumn" style="padding-top: 10px;">&nbsp;</TD>
                <TR>
		
				<TD class="detailFormColumn" style="padding-top: 10px;">&nbsp;</TD>
		</TR>
                <TR>
                    <td ></br>
                      <label for="textarea"><strong>SUMMARY OF PROBLEM (Continued): (5000 characters and spaces max)</strong><br>
                      </label>
                    <textarea name="summaryTextInput1" id="summaryTextInput1ID" cols="100" rows="10" maxlength="5000"></textarea>
                    <br></br></br></TR>
                
		</TR>
		<tr>
		<td><hr>
		  <small><br>
		    <label style="font-size:small;font-family:arial, helvetica, sans-serif">Please select the report rendering format</label>
	      &nbsp;<strong></strong>
		    <span style="font-size:small;font-family:arial, helvetica, sans-serif"><br>
            </span>
		    <input type="radio" name="render" value="pdfPDF">
		    <span style="font-size:small;font-family:arial, helvetica, sans-serif">PDF<br>
            </span>
		    <input type="radio" name="render" value="docWORD">
	      <span style="font-size:small;font-family:arial, helvetica, sans-serif">Word</span> </small><br>      </div>  </td></tr>
		
		
		
		
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