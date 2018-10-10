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
	String date1 = request.getParameter("date1Text");
	String date2 = request.getParameter("date2Text");
	String date3 = request.getParameter("date3Text");
	String date4 = request.getParameter("date4Text");
	String dateFine1 = request.getParameter("dateFine1Text");
	String dateFine2 = request.getParameter("dateFine2Text");
	String dateFine3 = request.getParameter("dateFine3Text");
	String dateFine4 = request.getParameter("dateFine4Text");
	String dateReturned = request.getParameter("dateReturnedText");
	String paid = request.getParameter("paidCB");
	String parentCalledOn = request.getParameter("parentCalledText");	
	String timeTextValue = request.getParameter("timeText");
	String reason1TextValue = request.getParameter("reason1Text");
	String reason2TextValue = request.getParameter("reason2Text");
	String reason3TextValue = request.getParameter("reason3Text");
	String reason4TextValue = request.getParameter("reason4Text");
	String item1TextValue = request.getParameter("item1Text");
	String item2TextValue = request.getParameter("item2Text");
	String item3TextValue = request.getParameter("item3Text");
	String item4TextValue = request.getParameter("item4Text");
	String size1TextValue = request.getParameter("size1Text");
	String size2TextValue = request.getParameter("size2Text");
	String size3TextValue = request.getParameter("size3Text");
	String size4TextValue = request.getParameter("size4Text");
	String fineAmt1TextValue = request.getParameter("fineAmt1Text");
	String fineAmt2TextValue = request.getParameter("fineAmt2Text");
	String fineAmt3TextValue = request.getParameter("fineAmt3Text");
	String fineAmt4TextValue = request.getParameter("fineAmt4Text");
	String personReceivingTextValue = request.getParameter("personReceivingText");
	String fineAssdTextValue = request.getParameter("fineAssdText");
	
	
	//variables needed for page to know itself and call the right report
	String dir = "Behavior-BEPRDN0001/";
	String srsReportName = "BorrowedClothesForm-BEREDR0024";
	String jspPageName = "BorrowedClothesForm-BEREDR0024";

	
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
//REPLACE SPECIAL CHARACTERS ON TIMETEXT
String timeTextOutput = timeTextValue.replace(" ","%20");
String timeTextOutput2 = timeTextOutput.replace("#","%23");
String timeTextOutput3 = timeTextOutput2.replace("^", "%5E");
String timeTextOutput4 = timeTextOutput3.replace("&", "%26");
String timeTextOutput5 = timeTextOutput4.replace("+", "%2B");
String timeTextOutput6 = timeTextOutput5.replace(">", "%3E");
String timeTextOutput7 = timeTextOutput6.replace("<", "%3C");
String timeTextOutput8 = timeTextOutput7.replace("[", "%5B");
String timeTextOutput9 = timeTextOutput8.replace("]", "%5D");
String timeTextOutput10 = timeTextOutput9.replace("{", "%7B");
String timeTextOutput11 = timeTextOutput10.replace("}", "%7D");
String timeTextOutput12 = timeTextOutput11.replace("\\", "%5C");
String timeTextOutput13 = timeTextOutput12.replace("|", "%7C");
String timeTextOutput14 = timeTextOutput13.replace("\"", "%22");
String timeTextOutput15 = timeTextOutput14.replace(",", "%2C");

//REPLACE SPECIAL CHARACTERS ON REASON 1-4
String reasonText1Output = reason1TextValue.replace(" ","%20");
String reasonText1Output2 = reasonText1Output.replace("#","%23");
String reasonText1Output3 = reasonText1Output2.replace("^", "%5E");
String reasonText1Output4 = reasonText1Output3.replace("&", "%26");
String reasonText1Output5 = reasonText1Output4.replace("+", "%2B");
String reasonText1Output6 = reasonText1Output5.replace(">", "%3E");
String reasonText1Output7 = reasonText1Output6.replace("<", "%3C");
String reasonText1Output8 = reasonText1Output7.replace("[", "%5B");
String reasonText1Output9 = reasonText1Output8.replace("]", "%5D");
String reasonText1Output10 = reasonText1Output9.replace("{", "%7B");
String reasonText1Output11 = reasonText1Output10.replace("}", "%7D");
String reasonText1Output12 = reasonText1Output11.replace("\\", "%5C");
String reasonText1Output13 = reasonText1Output12.replace("|", "%7C");
String reasonText1Output14 = reasonText1Output13.replace("\"", "%22");
String reasonText1Output15 = reasonText1Output14.replace(",", "%2C");

String reasonText2Output = reason2TextValue.replace(" ","%20");
String reasonText2Output2 = reasonText2Output.replace("#","%23");
String reasonText2Output3 = reasonText2Output2.replace("^", "%5E");
String reasonText2Output4 = reasonText2Output3.replace("&", "%26");
String reasonText2Output5 = reasonText2Output4.replace("+", "%2B");
String reasonText2Output6 = reasonText2Output5.replace(">", "%3E");
String reasonText2Output7 = reasonText2Output6.replace("<", "%3C");
String reasonText2Output8 = reasonText2Output7.replace("[", "%5B");
String reasonText2Output9 = reasonText2Output8.replace("]", "%5D");
String reasonText2Output10 = reasonText2Output9.replace("{", "%7B");
String reasonText2Output11 = reasonText2Output10.replace("}", "%7D");
String reasonText2Output12 = reasonText2Output11.replace("\\", "%5C");
String reasonText2Output13 = reasonText2Output12.replace("|", "%7C");
String reasonText2Output14 = reasonText2Output13.replace("\"", "%22");
String reasonText2Output15 = reasonText2Output14.replace(",", "%2C");

String reasonText3Output = reason3TextValue.replace(" ","%20");
String reasonText3Output2 = reasonText3Output.replace("#","%23");
String reasonText3Output3 = reasonText3Output2.replace("^", "%5E");
String reasonText3Output4 = reasonText3Output3.replace("&", "%26");
String reasonText3Output5 = reasonText3Output4.replace("+", "%2B");
String reasonText3Output6 = reasonText3Output5.replace(">", "%3E");
String reasonText3Output7 = reasonText3Output6.replace("<", "%3C");
String reasonText3Output8 = reasonText3Output7.replace("[", "%5B");
String reasonText3Output9 = reasonText3Output8.replace("]", "%5D");
String reasonText3Output10 = reasonText3Output9.replace("{", "%7B");
String reasonText3Output11 = reasonText3Output10.replace("}", "%7D");
String reasonText3Output12 = reasonText3Output11.replace("\\", "%5C");
String reasonText3Output13 = reasonText3Output12.replace("|", "%7C");
String reasonText3Output14 = reasonText3Output13.replace("\"", "%22");
String reasonText3Output15 = reasonText3Output14.replace(",", "%2C");

String reasonText4Output = reason4TextValue.replace(" ","%20");
String reasonText4Output2 = reasonText4Output.replace("#","%23");
String reasonText4Output3 = reasonText4Output2.replace("^", "%5E");
String reasonText4Output4 = reasonText4Output3.replace("&", "%26");
String reasonText4Output5 = reasonText4Output4.replace("+", "%2B");
String reasonText4Output6 = reasonText4Output5.replace(">", "%3E");
String reasonText4Output7 = reasonText4Output6.replace("<", "%3C");
String reasonText4Output8 = reasonText4Output7.replace("[", "%5B");
String reasonText4Output9 = reasonText4Output8.replace("]", "%5D");
String reasonText4Output10 = reasonText4Output9.replace("{", "%7B");
String reasonText4Output11 = reasonText4Output10.replace("}", "%7D");
String reasonText4Output12 = reasonText4Output11.replace("\\", "%5C");
String reasonText4Output13 = reasonText4Output12.replace("|", "%7C");
String reasonText4Output14 = reasonText4Output13.replace("\"", "%22");
String reasonText4Output15 = reasonText4Output14.replace(",", "%2C");

//REPLACE ALL SPECIAL CHARACTERS IN ITEM 1-4
String item1Text4Output = item1TextValue.replace(" ","%20");
String item1Text4Output2 = item1Text4Output.replace("#","%23");
String item1Text4Output3 = item1Text4Output2.replace("^", "%5E");
String item1Text4Output4 = item1Text4Output3.replace("&", "%26");
String item1Text4Output5 = item1Text4Output4.replace("+", "%2B");
String item1Text4Output6 = item1Text4Output5.replace(">", "%3E");
String item1Text4Output7 = item1Text4Output6.replace("<", "%3C");
String item1Text4Output8 = item1Text4Output7.replace("[", "%5B");
String item1Text4Output9 = item1Text4Output8.replace("]", "%5D");
String item1Text4Output10 = item1Text4Output9.replace("{", "%7B");
String item1Text4Output11 = item1Text4Output10.replace("}", "%7D");
String item1Text4Output12 = item1Text4Output11.replace("\\", "%5C");
String item1Text4Output13 = item1Text4Output12.replace("|", "%7C");
String item1Text4Output14 = item1Text4Output13.replace("\"", "%22");
String item1Text4Output15 = item1Text4Output14.replace(",", "%2C");

String item2Text4Output = item2TextValue.replace(" ","%20");
String item2Text4Output2 = item2Text4Output.replace("#","%23");
String item2Text4Output3 = item2Text4Output2.replace("^", "%5E");
String item2Text4Output4 = item2Text4Output3.replace("&", "%26");
String item2Text4Output5 = item2Text4Output4.replace("+", "%2B");
String item2Text4Output6 = item2Text4Output5.replace(">", "%3E");
String item2Text4Output7 = item2Text4Output6.replace("<", "%3C");
String item2Text4Output8 = item2Text4Output7.replace("[", "%5B");
String item2Text4Output9 = item2Text4Output8.replace("]", "%5D");
String item2Text4Output10 = item2Text4Output9.replace("{", "%7B");
String item2Text4Output11 = item2Text4Output10.replace("}", "%7D");
String item2Text4Output12 = item2Text4Output11.replace("\\", "%5C");
String item2Text4Output13 = item2Text4Output12.replace("|", "%7C");
String item2Text4Output14 = item2Text4Output13.replace("\"", "%22");
String item2Text4Output15 = item2Text4Output14.replace(",", "%2C");

String item3Text4Output = item3TextValue.replace(" ","%20");
String item3Text4Output2 = item3Text4Output.replace("#","%23");
String item3Text4Output3 = item3Text4Output2.replace("^", "%5E");
String item3Text4Output4 = item3Text4Output3.replace("&", "%26");
String item3Text4Output5 = item3Text4Output4.replace("+", "%2B");
String item3Text4Output6 = item3Text4Output5.replace(">", "%3E");
String item3Text4Output7 = item3Text4Output6.replace("<", "%3C");
String item3Text4Output8 = item3Text4Output7.replace("[", "%5B");
String item3Text4Output9 = item3Text4Output8.replace("]", "%5D");
String item3Text4Output10 = item3Text4Output9.replace("{", "%7B");
String item3Text4Output11 = item3Text4Output10.replace("}", "%7D");
String item3Text4Output12 = item3Text4Output11.replace("\\", "%5C");
String item3Text4Output13 = item3Text4Output12.replace("|", "%7C");
String item3Text4Output14 = item3Text4Output13.replace("\"", "%22");
String item3Text4Output15 = item3Text4Output14.replace(",", "%2C");

String item4Text4Output = item4TextValue.replace(" ","%20");
String item4Text4Output2 = item4Text4Output.replace("#","%23");
String item4Text4Output3 = item4Text4Output2.replace("^", "%5E");
String item4Text4Output4 = item4Text4Output3.replace("&", "%26");
String item4Text4Output5 = item4Text4Output4.replace("+", "%2B");
String item4Text4Output6 = item4Text4Output5.replace(">", "%3E");
String item4Text4Output7 = item4Text4Output6.replace("<", "%3C");
String item4Text4Output8 = item4Text4Output7.replace("[", "%5B");
String item4Text4Output9 = item4Text4Output8.replace("]", "%5D");
String item4Text4Output10 = item4Text4Output9.replace("{", "%7B");
String item4Text4Output11 = item4Text4Output10.replace("}", "%7D");
String item4Text4Output12 = item4Text4Output11.replace("\\", "%5C");
String item4Text4Output13 = item4Text4Output12.replace("|", "%7C");
String item4Text4Output14 = item4Text4Output13.replace("\"", "%22");
String item4Text4Output15 = item4Text4Output14.replace(",", "%2C");

//REPLACE ALL SPECIAL CHARACTERS IN SIZE 1-4
String size1Text4Output = size1TextValue.replace(" ","%20");
String size1Text4Output2 = size1Text4Output.replace("#","%23");
String size1Text4Output3 = size1Text4Output2.replace("^", "%5E");
String size1Text4Output4 = size1Text4Output3.replace("&", "%26");
String size1Text4Output5 = size1Text4Output4.replace("+", "%2B");
String size1Text4Output6 = size1Text4Output5.replace(">", "%3E");
String size1Text4Output7 = size1Text4Output6.replace("<", "%3C");
String size1Text4Output8 = size1Text4Output7.replace("[", "%5B");
String size1Text4Output9 = size1Text4Output8.replace("]", "%5D");
String size1Text4Output10 = size1Text4Output9.replace("{", "%7B");
String size1Text4Output11 = size1Text4Output10.replace("}", "%7D");
String size1Text4Output12 = size1Text4Output11.replace("\\", "%5C");
String size1Text4Output13 = size1Text4Output12.replace("|", "%7C");
String size1Text4Output14 = size1Text4Output13.replace("\"", "%22");
String size1Text4Output15 = size1Text4Output14.replace(",", "%2C");

String size2Text4Output = size2TextValue.replace(" ","%20");
String size2Text4Output2 = size2Text4Output.replace("#","%23");
String size2Text4Output3 = size2Text4Output2.replace("^", "%5E");
String size2Text4Output4 = size2Text4Output3.replace("&", "%26");
String size2Text4Output5 = size2Text4Output4.replace("+", "%2B");
String size2Text4Output6 = size2Text4Output5.replace(">", "%3E");
String size2Text4Output7 = size2Text4Output6.replace("<", "%3C");
String size2Text4Output8 = size2Text4Output7.replace("[", "%5B");
String size2Text4Output9 = size2Text4Output8.replace("]", "%5D");
String size2Text4Output10 = size2Text4Output9.replace("{", "%7B");
String size2Text4Output11 = size2Text4Output10.replace("}", "%7D");
String size2Text4Output12 = size2Text4Output11.replace("\\", "%5C");
String size2Text4Output13 = size2Text4Output12.replace("|", "%7C");
String size2Text4Output14 = size2Text4Output13.replace("\"", "%22");
String size2Text4Output15 = size2Text4Output14.replace(",", "%2C");

String size3Text4Output = size3TextValue.replace(" ","%20");
String size3Text4Output2 = size3Text4Output.replace("#","%23");
String size3Text4Output3 = size3Text4Output2.replace("^", "%5E");
String size3Text4Output4 = size3Text4Output3.replace("&", "%26");
String size3Text4Output5 = size3Text4Output4.replace("+", "%2B");
String size3Text4Output6 = size3Text4Output5.replace(">", "%3E");
String size3Text4Output7 = size3Text4Output6.replace("<", "%3C");
String size3Text4Output8 = size3Text4Output7.replace("[", "%5B");
String size3Text4Output9 = size3Text4Output8.replace("]", "%5D");
String size3Text4Output10 = size3Text4Output9.replace("{", "%7B");
String size3Text4Output11 = size3Text4Output10.replace("}", "%7D");
String size3Text4Output12 = size3Text4Output11.replace("\\", "%5C");
String size3Text4Output13 = size3Text4Output12.replace("|", "%7C");
String size3Text4Output14 = size3Text4Output13.replace("\"", "%22");
String size3Text4Output15 = size3Text4Output14.replace(",", "%2C");

String size4Text4Output = size4TextValue.replace(" ","%20");
String size4Text4Output2 = size4Text4Output.replace("#","%23");
String size4Text4Output3 = size4Text4Output2.replace("^", "%5E");
String size4Text4Output4 = size4Text4Output3.replace("&", "%26");
String size4Text4Output5 = size4Text4Output4.replace("+", "%2B");
String size4Text4Output6 = size4Text4Output5.replace(">", "%3E");
String size4Text4Output7 = size4Text4Output6.replace("<", "%3C");
String size4Text4Output8 = size4Text4Output7.replace("[", "%5B");
String size4Text4Output9 = size4Text4Output8.replace("]", "%5D");
String size4Text4Output10 = size4Text4Output9.replace("{", "%7B");
String size4Text4Output11 = size4Text4Output10.replace("}", "%7D");
String size4Text4Output12 = size4Text4Output11.replace("\\", "%5C");
String size4Text4Output13 = size4Text4Output12.replace("|", "%7C");
String size4Text4Output14 = size4Text4Output13.replace("\"", "%22");
String size4Text4Output15 = size4Text4Output14.replace(",", "%2C");

//REPLACE ALL SPECIAL CHARACTERS IN FINEAMT 1-4
String fineAmt1Text4Output = fineAmt1TextValue.replace(" ","%20");
String fineAmt1Text4Output2 = fineAmt1Text4Output.replace("#","%23");
String fineAmt1Text4Output3 = fineAmt1Text4Output2.replace("^", "%5E");
String fineAmt1Text4Output4 = fineAmt1Text4Output3.replace("&", "%26");
String fineAmt1Text4Output5 = fineAmt1Text4Output4.replace("+", "%2B");
String fineAmt1Text4Output6 = fineAmt1Text4Output5.replace(">", "%3E");
String fineAmt1Text4Output7 = fineAmt1Text4Output6.replace("<", "%3C");
String fineAmt1Text4Output8 = fineAmt1Text4Output7.replace("[", "%5B");
String fineAmt1Text4Output9 = fineAmt1Text4Output8.replace("]", "%5D");
String fineAmt1Text4Output10 = fineAmt1Text4Output9.replace("{", "%7B");
String fineAmt1Text4Output11 = fineAmt1Text4Output10.replace("}", "%7D");
String fineAmt1Text4Output12 = fineAmt1Text4Output11.replace("\\", "%5C");
String fineAmt1Text4Output13 = fineAmt1Text4Output12.replace("|", "%7C");
String fineAmt1Text4Output14 = fineAmt1Text4Output13.replace("\"", "%22");
String fineAmt1Text4Output15 = fineAmt1Text4Output14.replace(",", "%2C");

String fineAmt2Text4Output = fineAmt2TextValue.replace(" ","%20");
String fineAmt2Text4Output2 = fineAmt2Text4Output.replace("#","%23");
String fineAmt2Text4Output3 = fineAmt2Text4Output2.replace("^", "%5E");
String fineAmt2Text4Output4 = fineAmt2Text4Output3.replace("&", "%26");
String fineAmt2Text4Output5 = fineAmt2Text4Output4.replace("+", "%2B");
String fineAmt2Text4Output6 = fineAmt2Text4Output5.replace(">", "%3E");
String fineAmt2Text4Output7 = fineAmt2Text4Output6.replace("<", "%3C");
String fineAmt2Text4Output8 = fineAmt2Text4Output7.replace("[", "%5B");
String fineAmt2Text4Output9 = fineAmt2Text4Output8.replace("]", "%5D");
String fineAmt2Text4Output10 = fineAmt2Text4Output9.replace("{", "%7B");
String fineAmt2Text4Output11 = fineAmt2Text4Output10.replace("}", "%7D");
String fineAmt2Text4Output12 = fineAmt2Text4Output11.replace("\\", "%5C");
String fineAmt2Text4Output13 = fineAmt2Text4Output12.replace("|", "%7C");
String fineAmt2Text4Output14 = fineAmt2Text4Output13.replace("\"", "%22");
String fineAmt2Text4Output15 = fineAmt2Text4Output14.replace(",", "%2C");

String fineAmt3Text4Output = fineAmt3TextValue.replace(" ","%20");
String fineAmt3Text4Output2 = fineAmt3Text4Output.replace("#","%23");
String fineAmt3Text4Output3 = fineAmt3Text4Output2.replace("^", "%5E");
String fineAmt3Text4Output4 = fineAmt3Text4Output3.replace("&", "%26");
String fineAmt3Text4Output5 = fineAmt3Text4Output4.replace("+", "%2B");
String fineAmt3Text4Output6 = fineAmt3Text4Output5.replace(">", "%3E");
String fineAmt3Text4Output7 = fineAmt3Text4Output6.replace("<", "%3C");
String fineAmt3Text4Output8 = fineAmt3Text4Output7.replace("[", "%5B");
String fineAmt3Text4Output9 = fineAmt3Text4Output8.replace("]", "%5D");
String fineAmt3Text4Output10 = fineAmt3Text4Output9.replace("{", "%7B");
String fineAmt3Text4Output11 = fineAmt3Text4Output10.replace("}", "%7D");
String fineAmt3Text4Output12 = fineAmt3Text4Output11.replace("\\", "%5C");
String fineAmt3Text4Output13 = fineAmt3Text4Output12.replace("|", "%7C");
String fineAmt3Text4Output14 = fineAmt3Text4Output13.replace("\"", "%22");
String fineAmt3Text4Output15 = fineAmt3Text4Output14.replace(",", "%2C");

String fineAmt4Text4Output = fineAmt4TextValue.replace(" ","%20");
String fineAmt4Text4Output2 = fineAmt4Text4Output.replace("#","%23");
String fineAmt4Text4Output3 = fineAmt4Text4Output2.replace("^", "%5E");
String fineAmt4Text4Output4 = fineAmt4Text4Output3.replace("&", "%26");
String fineAmt4Text4Output5 = fineAmt4Text4Output4.replace("+", "%2B");
String fineAmt4Text4Output6 = fineAmt4Text4Output5.replace(">", "%3E");
String fineAmt4Text4Output7 = fineAmt4Text4Output6.replace("<", "%3C");
String fineAmt4Text4Output8 = fineAmt4Text4Output7.replace("[", "%5B");
String fineAmt4Text4Output9 = fineAmt4Text4Output8.replace("]", "%5D");
String fineAmt4Text4Output10 = fineAmt4Text4Output9.replace("{", "%7B");
String fineAmt4Text4Output11 = fineAmt4Text4Output10.replace("}", "%7D");
String fineAmt4Text4Output12 = fineAmt4Text4Output11.replace("\\", "%5C");
String fineAmt4Text4Output13 = fineAmt4Text4Output12.replace("|", "%7C");
String fineAmt4Text4Output14 = fineAmt4Text4Output13.replace("\"", "%22");
String fineAmt4Text4Output15 = fineAmt4Text4Output14.replace(",", "%2C");

//REPLACE ALL SPECIAL CHARACTERS IN PERSONRECEIVINGTEXT
String personReceivingText4Output = personReceivingTextValue.replace(" ","%20");
String personReceivingText4Output2 = personReceivingText4Output.replace("#","%23");
String personReceivingText4Output3 = personReceivingText4Output2.replace("^", "%5E");
String personReceivingText4Output4 = personReceivingText4Output3.replace("&", "%26");
String personReceivingText4Output5 = personReceivingText4Output4.replace("+", "%2B");
String personReceivingText4Output6 = personReceivingText4Output5.replace(">", "%3E");
String personReceivingText4Output7 = personReceivingText4Output6.replace("<", "%3C");
String personReceivingText4Output8 = personReceivingText4Output7.replace("[", "%5B");
String personReceivingText4Output9 = personReceivingText4Output8.replace("]", "%5D");
String personReceivingText4Output10 = personReceivingText4Output9.replace("{", "%7B");
String personReceivingText4Output11 = personReceivingText4Output10.replace("}", "%7D");
String personReceivingText4Output12 = personReceivingText4Output11.replace("\\", "%5C");
String personReceivingText4Output13 = personReceivingText4Output12.replace("|", "%7C");
String personReceivingText4Output14 = personReceivingText4Output13.replace("\"", "%22");
String personReceivingText4Output15 = personReceivingText4Output14.replace(",", "%2C");

//REPLACE ALL SPECIAL CHARACTERS IN FINEASSSSEDTEXT
String fineAssdText4Output = fineAssdTextValue.replace(" ","%20");
String fineAssdText4Output2 = fineAssdText4Output.replace("#","%23");
String fineAssdText4Output3 = fineAssdText4Output2.replace("^", "%5E");
String fineAssdText4Output4 = fineAssdText4Output3.replace("&", "%26");
String fineAssdText4Output5 = fineAssdText4Output4.replace("+", "%2B");
String fineAssdText4Output6 = fineAssdText4Output5.replace(">", "%3E");
String fineAssdText4Output7 = fineAssdText4Output6.replace("<", "%3C");
String fineAssdText4Output8 = fineAssdText4Output7.replace("[", "%5B");
String fineAssdText4Output9 = fineAssdText4Output8.replace("]", "%5D");
String fineAssdText4Output10 = fineAssdText4Output9.replace("{", "%7B");
String fineAssdText4Output11 = fineAssdText4Output10.replace("}", "%7D");
String fineAssdText4Output12 = fineAssdText4Output11.replace("\\", "%5C");
String fineAssdText4Output13 = fineAssdText4Output12.replace("|", "%7C");
String fineAssdText4Output14 = fineAssdText4Output13.replace("\"", "%22");
String fineAssdText4Output15 = fineAssdText4Output14.replace(",", "%2C");
		
		String url = path+dir+srsReportName+"&personID="+contextID+"&calendarID="+calendarID;
		url += "&reason1="+reasonText1Output15+"&reason2="+reasonText2Output15+"&reason3="+reasonText3Output15+"&reason4="+reasonText4Output15;
		url += "&date1="+date1+"&date2="+date2+"&date3="+date3+"&date4="+date4;
		url += "&item1="+item1Text4Output15+"&item2="+item2Text4Output15+"&item3="+item3Text4Output15+"&item4="+item4Text4Output15;
		url += "&size1="+size1Text4Output15+"&size2="+size2Text4Output15+"&size3="+size3Text4Output15+"&size4="+size4Text4Output15;
		url += "&fineAmt1="+fineAmt1Text4Output15+"&fineAmt2="+fineAmt2Text4Output15+"&fineAmt3="+fineAmt3Text4Output15+"&fineAmt4="+fineAmt4Text4Output15;
		url += "&dateFineStarts1="+dateFine1+"&dateFineStarts2="+dateFine2+"&dateFineStarts3="+dateFine3+"&dateFineStarts4="+dateFine4;
		url += "&dateReturned="+dateReturned+"&personReceiving="+personReceivingText4Output15+"&fineAssessed="+fineAssdText4Output15+"&paid="+paid+"&parentCalledOn="+parentCalledOn;
		url += "&time="+timeTextOutput15;
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
		<TD class="wizardHeader" width="100%" style="height: 21px;">Borrowed Clothes Form</TD>
		</TR>
		
		<TR>
		<TD class="wizardInstruction" style="padding-top: 10px; padding-right: 30px; padding-left: 30px; height=33px;font-size: 10px; font-weight: bold;" valign="top">
		  <span style="font-size: 8pt">Print a Borrowed Clothes Form for the selected student.</span>
		  <p></TD>
		</TR>

		<TR>
		<TD width="100%" height="2" background="images/hr.gif"></TD>
		</TR>
	</TABLE>
	
        <TR>
			<TD class="detailFormColumn" style="padding-top: 10px;">
          <p>
            <label for="timeText"> Time:</label>
            <input type="text" name="timeText" id="timeText">
          </p>
          <fieldset>
            <legend>Borrowed Items</legend>
            <table width="75%" border="0">
              <tbody>
                <tr>
                  <th scope="col">Reason</th>
                  <th scope="col">Date</th>
                  <th scope="col">Item</th>
                  <th scope="col">Size</th>
                  <th scope="col">Fine Amt</th>
                  <th scope="col">Date Fine Starts</th>
                </tr>
                <tr>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="reason1Text" id="reason1Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;">
                    <input type="text" name="date1Text" id="datepicker">
                  </span></FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="item1Text" id="item1Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="size1Text" id="size1Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="fineAmt1Text" id="fineAmt1Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;">
                    <input type="text" name="dateFine1Text" id="datepicker5">
                  </span></FONT></td>
                </tr>
                <tr>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="reason2Text" id="reason2Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;">
                    <input type="text" name="date2Text" id="datepicker2">
                  </span></FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="item2Text" id="item2Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="size2Text" id="size2Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="fineAmt2Text" id="fineAmt2Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;">
                    <input type="text" name="dateFine2Text" id="datepicker6">
                  </span></FONT></td>
                </tr>
                <tr>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="reason3Text" id="reason3Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;">
                    <input type="text" name="date3Text" id="datepicker3">
                  </span></FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="item3Text" id="item3Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="size3Text" id="size3Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="fineAmt3Text" id="fineAmt3Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;">
                    <input type="text" name="dateFine3Text" id="datepicker7">
                  </span></FONT></td>
                </tr>
                <tr>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="reason4Text" id="reason4Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;">
                    <input type="text" name="date4Text" id="datepicker4">
                  </span></FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="item4Text" id="item4Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="size4Text" id="size4Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
                    <input type="text" name="fineAmt4Text" id="fineAmt4Text">
                  </FONT></td>
                  <td><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;">
                    <input type="text" name="dateFine4Text" id="datepicker8">
                  </span></FONT></td>
                </tr>
              </tbody>
            </table>
            <p>Date Returned: <FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;">
              <input type="text" name="dateReturnedText" id="datepicker9">
            </span></FONT>       </p>
            <p>Person Receiving Clothes: <FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
              <input type="text" name="personReceivingText" id="personReceivingText">
            </FONT></p>
            <p><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">Fine Assessed: <FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
            <input type="text" name="fineAssdText" id="fineAssdText">
            </FONT></FONT></p>
            <p>
              <input type="checkbox" name="paidCB" id="paidCB" value="1">
              <label for="checkbox">Paid? </label>
              <FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">
              <input type="hidden" name="paidCB" value="0" />
            </FONT></FONT></p>
            <p><FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;">Parent Called On: <FONT style="font-family: arial, helvetica, sans; font-size: 8pt; color: #000000; font-weight: normal;"><span class="detailFormColumn" style="padding-top: 10px;">
            <input type="text" name="parentCalledText" id="datepicker10">
            </span></FONT></FONT><br>
            </p>
            <p>&nbsp; </p>
          </fieldset></TD>	
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
<script type="text/javascript">
$(function() {
$( "#datepicker" ).datepicker();
$( "#datepicker2" ).datepicker();
$( "#datepicker3" ).datepicker();
$( "#datepicker4" ).datepicker();
$( "#datepicker5" ).datepicker();    
$( "#datepicker6" ).datepicker();
$( "#datepicker7" ).datepicker();
$( "#datepicker8" ).datepicker();
$( "#datepicker9" ).datepicker();
$( "#datepicker10" ).datepicker();
  });
</script>
</BODY>
</HTML>