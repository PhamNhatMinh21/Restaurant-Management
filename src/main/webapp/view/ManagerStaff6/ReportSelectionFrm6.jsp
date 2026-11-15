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
<title>Chọn báo cáo thống kê</title>
<link rel="stylesheet" href="../../css/style.css?v=20261115-header">
</head>
<body>
	<div class="header">
		<span class="user"><%=manager.getName()%></span>
		<h1>Chọn báo cáo thống kê</h1>
	</div>
	<div class="content">
		<div class="menu">
			<form action="SupplierStatsFrm6.jsp" method="get">
				<button id="sub_supplierStats" type="submit">Thống kê nhà cung cấp</button>
			</form>
			<button id="sub_customerStats" type="button" disabled>Thống kê khách hàng</button>
			<button id="sub_ingredientStats" type="button" disabled>Thống kê nguyên liệu</button>
			<button id="sub_dishStats" type="button" disabled>Thống kê món ăn</button>
		</div>
		<div class="footer">
			<a id="sub_back" class="btn inline" href="ManagerHomeFrm6.jsp">Quay lại</a>
		</div>
	</div>
</body>
</html>
