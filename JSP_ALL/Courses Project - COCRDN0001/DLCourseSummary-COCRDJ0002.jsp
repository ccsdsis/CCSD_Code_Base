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
	//String departmentName = null;
	//String departmentCode = null;
	
	//variables to gather the choices the user has made and concat them into the URL
    String ccsdTypeID = request.getParameter("SchoolTypeList"); 
	String ccsdTypeName = request.getParameter("SchoolTypeList");
	String schoolID2 = request.getParameter("SchoolList");
	String schoolNameText = request.getParameter("SchoolList");
	String rValue = request.getParameter("render");
	

		
	//variables needed for SQL statements to work
	String SQL1 = null;
	String SQL2 = null;
	String SQL3 = null;
	String SQL4 = null;
	ResultSet result1 = null;
	ResultSet result2 = null;
	ResultSet result3 = null;
	ResultSet result4 = null;
	
	//variables needed for page to know itself and call the right report
	String dir = "Courses/";
	//String srsReportName = "ClassList-SISEDR0009";
	String srsReportName ="DLCourseSummary-COCRDR0002";
	String jspPageName = "DLCourseSummary-COCRDJ0002";

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

function validate() {
    //var admin = document.forms["rsPass"]["AdminList"].value;
	var rptFormat = document.forms["rsPass"]["render"].value;
	//alert(x);
    //if (admin == "NULL" || admin == null || admin == "") {
    //    alert("Behavior Contact must be selected.");
    //    return false;
    //}
	if (rptFormat.toUpperCase() == "NULL" || rptFormat == null || rptFormat == "") {
        alert("Report Format must be selected.");
        return false;
    }
	//else
	//{
	//	 alert(x);
	//	 return true;
	//}
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
		
		//out.println("Before: " + schoolID);
		
		if(schoolID.equals("null") || schoolID == "")
		{
			schoolID = "0";	
		}
		//out.println("After: " + schoolID);
		
		if (!schoolID.equals("0"))
		{
			Statement db1 = con.createStatement();
				SQL1 = " select distinct cd.standardcode as code " +
				" from school as cd with (nolock) " +
				" where schoolid = " + schoolID;

			result1 = db1.executeQuery(SQL1);

			while(result1.next())
			{ 
				schoolID2 =result1.getString(1);
			}
		
		}
		else
			schoolID2 = schoolID;

		String ext = rValue.substring(0,3);
		String render = rValue.substring(3,rValue.length());

		//Build ReportServer URL
		//String url = path+dir+srsReportName+"&endYear="+endYear+"&department="+departmentCode+"&schoolID="+schoolID2+"&program="+programCode;
		//url += "&rs%3AFormat="+render+"";
		
		String url = path+dir+srsReportName+"&endYear="+endYear+"&schoolID="+schoolID2+"&ccsdTypeID="+ccsdTypeID;
		url += "&rs%3AFormat="+render+"";

		//Launch report		
		//out.println(url);
		response.sendRedirect(pagePath+"/rsPassThruMulti.jsp?url="+URLEncoder.encode(url)+"&ext="+ ext +"&srsReportName="+ srsReportName + "");

		}
%>

<HTML>
<HEAD>
	<BASE HREF="<%= baseURL %>"/>
	<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
	<TITLE>Report</TITLE>
	<LINK rel="stylesheet" href="styles/lens.css" type="text/css"/>

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
	<FORM name = 'rsPass' action="<%= pagePath %><%= jspPageName %>.jsp?callrspassthru=true" onsubmit="return validate()" method="post"> <!--(this version works for most districts-->
	
	<TABLE cellpadding="0" cellspacing="0" width="640">
		<TR>
		<TD class="wizardHeader" width="100%" style="height: 21px;">&nbsp;Distance Learning Courses by School</TD>
		</TR>
		
		<TR>
		<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;" valign="top">
		  <p>The Distance Learning Courses by School report provides a listing of course information for each selected school including whether the course is available by Edgenuity and/or NVLA Canvas.</p><br><br></TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"></TD>
		</TR>
        <TR>
        	<!--<td class="detailFormColumn" style="padding-top:10px;">-->
  <%

			//Statement db1 = con.createStatement();
			//int newRecords1 = 0;
		    //SQL1 = " select cd.code as code, cd.name as name " +
			//		" from campusDictionary as cd with (nolock) " +
			//			" inner join campusAttribute as ca with (nolock) on ca.attributeID = cd.attributeID " +
			//				" and ca.object = 'Case Mgmt Programs' " +
			//				" and ca.element = 'AttendSchool' " ;

			//result1 = db1.executeQuery(SQL1);


			//out.println("<label><span><strong>Select School :</strong></span></label><br/><select name=SchoolList id=17><option value='0' selected='true'> ALL SCHOOLS</option>");
			//while(result1.next())
			//{ schoolID2 =result1.getString(1); 
			//schoolNameText = result1.getString(2);
			//out.println("<option value='"+schoolID2+"'>"+schoolNameText+"</option>");}
			//out.println("</select>");
			
			//con.close();

			//out.println("schID: " + schoolID);
			if (schoolID.equals("0"))
			{
				out.println("<TD class='detailFormColumn' style='padding-top: 10px;'>");
				Statement db2 = con.createStatement();
				int newRecords2 = 0;
		    
				SQL2 = "select name + ' - ' + value 'name', value from dbo.campusdictionary where [attributeID] = 872 and value not like '%CH%' order by 1;";

				result2 = db2.executeQuery(SQL2);


				out.println("<label><span><strong>Select CCSD School Type:</strong></span></label><br/><select name=SchoolTypeList id=16><option value='0' selected='true'>ALL TYPES</option>");
			
				while(result2.next())
				{ ccsdTypeName = result2.getString(1); 
				ccsdTypeID = result2.getString(2);
				out.println("<option value='"+ccsdTypeID+"'>"+ccsdTypeName+"</option>");}
				out.println("</select>");
			
			//con.close();
			}
%></tr>
		<tr>
		<td><small><br><label style="font-size:small;font-family:arial, helvetica, sans-serif"><strong>Please select the report rendering format</label>&nbsp;</strong><font color=red>*</font>
			<span style="font-size:small;font-family:arial, helvetica, sans-serif"><br></span></span>
			<input type="radio" name="render" value="pdfPDF" checked><span style="font-size:small;font-family:arial, helvetica, sans-serif">PDF</br>
            <input type="radio" name="render" value="csvCSV"><span style="font-size:small;font-family:arial, helvetica, sans-serif">Comma Separated Values (CSV)</br>
                        <input type="radio" name="render" value="xlsEXCEL"><span style="font-size:small;font-family:arial, helvetica, sans-serif">Excel</span>  </small><br></div>  
		</td>
		</tr>
		<TR>
		<TD><br>&nbsp;&nbsp;<font color=red>*</font> = Required fields</td>
		</tr>
		<tr>
		<td><input type="submit" name="btnSubmit" id="9" value="Download File"/></td>
		</TR>
	</TABLE>
	</FORM>	
</FONT>
</BODY>
</HTML>