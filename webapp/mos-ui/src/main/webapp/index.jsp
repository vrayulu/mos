<%--

    Copyright(C) 2013 - 2014, Developed by KPISOFT PTE. LTD. All rights reserved.
    This file is part of EPM UI Webapp.
    
    The intellectual and technical concepts contained herein may be covered 
    by patents, patents in process, and are protected by trade secret or 
    copyright law. Any unauthorized use of this code without prior approval 
    from KPISOFT PTE. LTD. is prohibited.

--%>

<%@ taglib tagdir="/WEB-INF/tags" prefix="mytags"%>
<html>
<head>
	<mytags:style />
</head>
<body>
<%
	 String ua = request.getHeader( "User-Agent" );
	 boolean flag = false; 
	 if(ua != null ){
		ua = ua.toLowerCase();
		flag = (ua.indexOf("android") != -1 || ua.indexOf("iphone") != -1 || ua.indexOf("backberry") != -1);
	 }
	 if(flag){
		 pageContext.forward("jsp/DependentJSPs/Mobile.jsp");
	 }else{
		 pageContext.forward("jsp/adminScreens/Home.jsp");
	 }

%>
</body>
</html>