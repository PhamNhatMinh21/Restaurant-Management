<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*,java.text.*,dao.*,model.*"%>
<%!
String h(String s) {
	if (s == null) return "";
	return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
}
%>
<%
request.setCharacterEncoding("UTF-8");
ManagerStaff6 manager = (ManagerStaff6) session.getAttribute("manager");
if (manager == null) {
	response.sendRedirect("../Member6/LoginFrm6.jsp?err=timeout");
	return;
}
DecimalFormat df = new DecimalFormat("#,##0.##", new DecimalFormatSymbols(Locale.forLanguageTag("vi")));
// ten mon an can tim: tu form nay (in_dishName) hoac tu DishEditFrm6 khi bam Quay lai
String searchName = request.getParameter("in_dishName");
if (searchName == null)
	searchName = request.getParameter("searchName");
Dish6[] dishes = null;
String message = "";
if (searchName != null) {
	try (DishDAO6 dao = new DishDAO6()) {
		dishes = dao.searchDish(searchName.trim());
	}
	session.setAttribute("dishes", dishes);
	session.setAttribute("searchName", searchName.trim());
	if (dishes == null)
		message = "Không tìm thấy món ăn nào phù hợp với từ khóa!";
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tìm kiếm món ăn</title>
<link rel="stylesheet" href="../../css/style.css?v=20261115-header">
</head>
<body>
	<div class="header">
		<span class="user"><%=manager.getName()%></span>
		<h1>Tìm kiếm món ăn</h1>
	</div>
	<div class="content">
		<form name="searchDish" action="DishSearchFrm6.jsp" method="post">
			<label for="in_dishName">Tên món ăn</label>
			<div class="row">
				<div class="col">
					<input type="text" id="in_dishName" name="in_dishName" size="60"
						value="<%=h(searchName)%>">
				</div>
				<div class="col">
					<button type="submit" id="sub_searchDishes" class="inline">Tìm kiếm</button>
				</div>
			</div>
		</form>

		<%
		if (!message.equals("")) {
		%><div id="out_message" class="message error"><%=message%></div>
		<%
		}
		%>

		<table id="out_dishes" class="list">
			<tr>
				<th>Mã món</th>
				<th>Tên món</th>
				<th>Ảnh</th>
				<th>Giá bán(VND)</th>
				<th>Nhóm món</th>
				<th>Mô tả</th>
				<th>Chi tiết</th>
			</tr>
			<%
			if (dishes != null)
				for (Dish6 d : dishes) {
			%>
			<tr>
				<td class="id"><%=h(d.getId())%></td>
				<td><%=h(d.getName())%></td>
				<td>
					<%
					if (d.getImage() != null && d.getImage().length() > 0) {
					%><img src="<%=request.getContextPath()%>/<%=h(d.getImage())%>" alt="<%=h(d.getName())%>">
					<%
					}
					%>
				</td>
				<td><%=df.format(d.getPrice())%></td>
				<td><%=h(d.getCategory())%></td>
				<td><%=h(d.getDescription())%></td>
				<td><a id="sub_selectDish" href="DishEditFrm6.jsp?id=<%=h(d.getId())%>">Sửa</a></td>
			</tr>
			<%
			}
			%>
		</table>

		<div class="footer">
			<a id="sub_back" class="btn inline" href="DishManagementFrm6.jsp">Quay lại</a>
		</div>
	</div>
</body>
</html>
