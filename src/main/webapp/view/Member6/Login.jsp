<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="dao.*,model.*"%>
<%
request.setCharacterEncoding("UTF-8");
String username = request.getParameter("username");
String password = request.getParameter("password");
ManagerStaff6 manager = new ManagerStaff6();
manager.setUsername(username);
manager.setPassword(password);
boolean kq;
try (ManagerStaffDAO6 dao = new ManagerStaffDAO6()) {
	kq = dao.checkLogin(manager);
}
if (kq) {
	session.setAttribute("manager", manager);
	response.sendRedirect("../ManagerStaff6/ManagerHomeFrm6.jsp");
} else {
	response.sendRedirect("LoginFrm6.jsp?err=fail");
}
%>
