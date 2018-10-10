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
// SIS-5328 2017-08-31 (FM) Add " order by exl1.outVal " to session location sql.


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
	String sessionDate1Value = request.getParameter("sessionDate1");
	String sessionDate2Value = request.getParameter("sessionDate2");
	String sessionLocationValue = request.getParameter("sessionLocationList");
	String adminPersonIDValue = request.getParameter("AdminList");
    String adminPersonName = request.getParameter("AdminList"); 
	String tw = request.getParameter("twCB");
	String sat = request.getParameter("satCB");
	String month = request.getParameter("monthSL");

	//variables needed for SQL statements to work
	String SQL2 = null;
	ResultSet result2 = null;
	String SQL1 = null;
	ResultSet result1 = null;
	String SQL3 = null;
	ResultSet result3 = null;
	
	//variables needed for page to know itself and call the right report
	String dir = "Behavior-BEPRDN0001/";
	String srsReportName = "SAAPNotificationLetter-BEREDR0015";
	String jspPageName = "SAAPNotificationLetter-BEREDR0015";

	
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
		//REPLACE ALL SPECIAL CHARACTERS FOR LOCATION TEXT BOX
		String locationText1Output = sessionLocationValue.replace(" ","%20");
		String locationText1Output2 = locationText1Output.replace("#","%23");
		String locationText1Output3 = locationText1Output2.replace("^", "%5E");
		String locationText1Output4 = locationText1Output3.replace("&", "%26");
		String locationText1Output5 = locationText1Output4.replace("+", "%2B");
		String locationText1Output6 = locationText1Output5.replace(">", "%3E");
		String locationText1Output7 = locationText1Output6.replace("<", "%3C");
		String locationText1Output8 = locationText1Output7.replace("[", "%5B");
		String locationText1Output9 = locationText1Output8.replace("]", "%5D");
		String locationText1Output10 = locationText1Output9.replace("{", "%7B");
		String locationText1Output11 = locationText1Output10.replace("}", "%7D");
		String locationText1Output12 = locationText1Output11.replace("\\", "%5C");
		String locationText1Output13 = locationText1Output12.replace("|", "%7C");
		String locationText1Output14 = locationText1Output13.replace("\"", "%22");
		String locationText1Output15 = locationText1Output14.replace(",", "%2C");	
		
		String url = path+dir+srsReportName+"&sessionLocation="+locationText1Output15+"&tw="+tw+"&sat="+sat+"&month="+month;
		url += "&calendarID="+calendarID+"&adminPersonID="+adminPersonIDValue+"&personID="+contextID+"&sessionDate1="+sessionDate1Value+"&sessionDate2="+sessionDate2Value;
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
		<TD class="wizardHeader" width="100%" style="height: 21px;">SAAP Notification Letter</TD>
		</TR>
		
		<TR>
		<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;font-size: 10px; font-weight: bold;" valign="top">
		  <span style="font-size: 8pt">Print a SAAP Notification Letter for the selected student.</span>
		  <p></TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"></TD>
		</TR>
	</TABLE>
	
        <TR>
		  <TD class="detailFormColumn" style="padding-top: 10px;">
          <p><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 0px;">
            <%

			Statement db1 = con.createStatement();
			int newRecords1 = 0;
		    SQL1 = "select distinct sf.personID, coalesce(id.firstname, '') + ' ' + coalesce(id.lastname, '') as AdminName " +
					" from [identity] as id with (nolock) " +
						" inner join staffMember as sf with (nolock) on sf.personID = id.personID " +
							" and sf.schoolID = " + schoolID +
							" and sf.endDate is null " +
							" and sf.behavior = 1 " ;

			result1 = db1.executeQuery(SQL1);


			out.println("<label>Referring Person:</label><br/><select name=AdminList id=17><option value='NULL' selected='false'> </option>");
			while(result1.next())
			{ adminPersonIDValue=result1.getString(1); 
			adminPersonName = result1.getString(2);
			out.println("<option value='"+adminPersonIDValue+"'>"+adminPersonName+"</option>");}
			out.println("</select>");
			
			//con.close();

%>
          </span></FONT></FONT></p>
          <p><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;"><b>Session Month &amp; Dates</b></span></FONT></p>
          <p><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;">
            <label for="monthSL">Month:</label>
            <select name="monthSL" id="monthSL">
              <option value="NA">&lt;SELECT&gt;</option>
              <option value="January">January</option>
              <option value="February">February</option>
              <option value="March">March</option>
              <option value="April">April</option>
              <option value="May">May</option>
              <option value="June">June</option>
              <option value="July">July</option>
              <option value="August">August</option>
              <option value="September">September</option>
              <option value="October">October</option>
              <option value="November">November</option>
              <option value="December">December</option>
            </select>
          <br></br>
          From:  <input type="text" name="sessionDate1" id="datepicker">
          </span></FONT> <FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;">
          To:
          <input type="text" name="sessionDate2" id="datepicker2">
          </span></FONT></FONT></p>
          <p><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 0px;">
            <%

			Statement db3 = con.createStatement();
			int newRecords3 = 0;
		    SQL3 = " select exl1.outVal as locationName " +
					" from ccsdextractLookup as exl1 with (nolock) " +
					" inner join ccsdextractLookup as exl2 with (nolock) on exl2.ICVal = exl1.ICVal and exl2.fld = 'locationAddress1' " +
					" inner join ccsdextractLookup as exl3 with (nolock) on exl3.ICVal = exl1.ICVal and exl3.fld = 'locationAddress2' " +
					" inner join ccsdextract as ex with (nolock) on ex.extractID = exl1.extractID and ex.extractID = exl2.extractID and " +
					" ex.extractID = exl3.extractID and ex.name = 'BehaviorForms' " +
					" where exl1.fld = 'location' " +
					" order by exl1.outVal "  ;

			result3 = db3.executeQuery(SQL3);


			out.println("<label>Select Session Location:</label><br/><select name=sessionLocationList id=17><option value='NULL' selected='false'> </option>");
			while(result3.next())
			{ sessionLocationValue=result3.getString(1); 
			out.println("<option value='"+sessionLocationValue+"'>"+sessionLocationValue+"</option>");}
			out.println("</select>");
			
			//con.close();

%>
          </span></FONT></FONT></FONT></p>
          <p><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
          <input type="checkbox" name="twCB" value="1">
Tues. & Wed. - 5 p.m. - 8 p.m.</br>
<br>
<input type="checkbox" name="satCB" value="1">
Saturday - 8 a.m. - 3 p.m.</FONT><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><br>
</br>
        </br>
        </FONT></p>
          <p><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
            <input type="hidden" name="twCB" value="0" />
          <input type="hidden" name="satCB" value="0" />
          </FONT></p></TD>	
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
<script type="text/javascript">
$(function() {
    $( "#datepicker" ).datepicker();
    $( "#datepicker2" ).datepicker();
    $( "#datepicker3" ).datepicker();
  });
</script>
</BODY>
</HTML>