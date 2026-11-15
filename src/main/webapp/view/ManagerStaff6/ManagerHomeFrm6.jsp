<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="model.*"%>
<%
ManagerStaff6 manager = (ManagerStaff6) session.getAttribute("manager");
if (manager == null) {
	response.sendRedirect("../Member6/LoginFrm6.jsp?err=timeout");
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trang chủ quản lý</title>
<link rel="stylesheet" href="../../css/style.css?v=20261115-header">
</head>
<body>
	<div class="header">
		<span class="user"><%=manager.getName()%></span>
		<h1>Trang chủ quản lý</h1>
	</div>
	<div class="content">
		<div class="menu">
			<a id="sub_manageDishes" class="btn" href="DishManagementFrm6.jsp">Quản lý thông tin món ăn</a>
			<a id="sub_viewStatistics" class="btn" href="ReportSelectionFrm6.jsp">Xem báo cáo thống kê</a>
			<a id="sub_makeCombos" class="btn disabled" href="#">Tạo combo menu</a>
		</div>
	</div>
</body>
</html>
