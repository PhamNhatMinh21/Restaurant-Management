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
<title>Quản lý thông tin món ăn</title>
<link rel="stylesheet" href="../../css/style.css?v=20261115-header">
</head>
<body>
	<div class="header">
		<span class="user"><%=manager.getName()%></span>
		<h1>Quản lý thông tin món ăn</h1>
	</div>
	<div class="content">
		<div class="menu">
			<a id="sub_editDish" class="btn" href="DishSearchFrm6.jsp">Sửa thông tin món ăn</a>
			<a id="sub_addDish" class="btn disabled" href="#">Thêm món ăn</a>
		</div>
		<div class="footer">
			<a id="sub_back" class="btn inline" href="ManagerHomeFrm6.jsp">Quay lại</a>
		</div>
	</div>
</body>
</html>
