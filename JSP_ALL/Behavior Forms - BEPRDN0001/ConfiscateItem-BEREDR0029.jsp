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
	String itemsValue = request.getParameter("itemsText");
	String confiscatedValue = request.getParameter("confiscatedText");
	
	//variables needed for page to know itself and call the right report
	String dir = "Behavior-BEPRDN0001/";
	String srsReportName = "ConfiscateItem-BEREDR0029";
	String jspPageName = "ConfiscateItem-BEREDR0029";

	
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
		//replace special characters in itemsTextbox
		String itemsOutput = itemsValue.replace(" ","%20");
		String itemsOutput2 = itemsOutput.replace("#","%23");
		String itemsOutput3 = itemsOutput2.replace("^", "%5E");
		String itemsOutput4 = itemsOutput3.replace("&", "%26");
		String itemsOutput5 = itemsOutput4.replace("+", "%2B");
		String itemsOutput6 = itemsOutput5.replace(">", "%3E");
		String itemsOutput7 = itemsOutput6.replace("<", "%3C");
		String itemsOutput8 = itemsOutput7.replace("[", "%5B");
		String itemsOutput9 = itemsOutput8.replace("]", "%5D");
		String itemsOutput10 = itemsOutput9.replace("{", "%7B");
		String itemsOutput11 = itemsOutput10.replace("}", "%7D");
		String itemsOutput12 = itemsOutput11.replace("\\", "%5C");
		String itemsOutput13 = itemsOutput12.replace("|", "%7C");
		String itemsOutput14 = itemsOutput13.replace("\"", "%22");
		String itemsOutput15 = itemsOutput14.replace(",", "%2C");
		
		//replace special characters in confiscatedByTextbox
		String confiscatedOutput = confiscatedValue.replace(" ","%20");
		String confiscatedOutput2 = confiscatedOutput.replace("#","%23");
		String confiscatedOutput3 = confiscatedOutput2.replace("^", "%5E");
		String confiscatedOutput4 = confiscatedOutput3.replace("&", "%26");
		String confiscatedOutput5 = confiscatedOutput4.replace("+", "%2B");
		String confiscatedOutput6 = confiscatedOutput5.replace(">", "%3E");
		String confiscatedOutput7 = confiscatedOutput6.replace("<", "%3C");
		String confiscatedOutput8 = confiscatedOutput7.replace("[", "%5B");
		String confiscatedOutput9 = confiscatedOutput8.replace("]", "%5D");
		String confiscatedOutput10 = confiscatedOutput9.replace("{", "%7B");
		String confiscatedOutput11 = confiscatedOutput10.replace("}", "%7D");
		String confiscatedOutput12 = confiscatedOutput11.replace("\\", "%5C");
		String confiscatedOutput13 = confiscatedOutput12.replace("|", "%7C");
		String confiscatedOutput14 = confiscatedOutput13.replace("\"", "%22");
		String confiscatedOutput15 = confiscatedOutput14.replace(",", "%2C");
		
		String url = path+dir+srsReportName+"&personID="+contextID+"&calendarID="+calendarID+"&items="+itemsOutput15+"&takenby="+confiscatedOutput15;
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


	<FORM name = 'rsPass' action="<%= pagePath %><%= jspPageName %>.jsp?callrspassthru=true" method="post""> <!--(this version works for most districts-->
	
	<TABLE cellpadding="0" cellspacing="0" width="640">
		<TR>
		<TD class="wizardHeader" width="100%" style="height: 21px;">Confiscated Item(s) Receipt</TD>
		</TR>
		
		<TR>
		<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;font-size: 10px; font-weight: bold;" valign="top">
		  <span style="font-size: 8pt">Print a Confiscated Item(s) Receipt for the selected student.</span>
		  <p></TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"></TD>
		</TR>
	</TABLE>
	
        <TR>
			<TD class="detailFormColumn" style="padding-top: 10px;">
          <p>
            <label for="textfield">Items Confiscated:</label>
            <input type="text" name="itemsText" id="itemsText" >
          </p>
          <p>
            <label for="textfield">Confiscated By:</label>
            <input type="text" name="confiscatedText" id="confiscatedText">
          </p></TD>	
		</TR><TR>
		
				<TD class="detailFormColumn" style="padding-top: 10px;">&nbsp;</TD>
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