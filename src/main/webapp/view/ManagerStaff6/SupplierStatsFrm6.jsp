<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.time.*,java.time.format.*,java.util.*,dao.*,model.*"%>
<%
request.setCharacterEncoding("UTF-8");
ManagerStaff6 manager = (ManagerStaff6) session.getAttribute("manager");
if (manager == null) {
	response.sendRedirect("../Member6/LoginFrm6.jsp?err=timeout");
	return;
}
LocalDate startDate = null;
LocalDate endDate = null;
SupplierStat6[] stats = null;
String message = "";

if (request.getMethod().equalsIgnoreCase("POST")) {
	// bam Xem thong ke: form gui vao chinh trang nay de xu ly
	String in_startDate = request.getParameter("in_startDate");
	String in_endDate = request.getParameter("in_endDate");
	if (in_startDate == null || in_startDate.length() == 0 || in_endDate == null || in_endDate.length() == 0) {
		message = "Vui lòng chọn đầy đủ ngày bắt đầu và ngày kết thúc thống kê!";
	} else {
		try {
			startDate = LocalDate.parse(in_startDate);
			endDate = LocalDate.parse(in_endDate);
			if (startDate.isAfter(endDate)) {
				message = "Khoảng thời gian không hợp lệ! Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc.";
			} else if (endDate.isAfter(LocalDate.now())) {
				message = "Ngày kết thúc không được vượt quá ngày hiện tại!";
			} else {
				try (SupplierStatDAO6 dao = new SupplierStatDAO6()) {
					stats = dao.getSupplierStat(startDate, endDate);
				}
				if (stats == null)
					message = "Không có dữ liệu nhập hàng trong khoảng thời gian đã chọn!";
				session.setAttribute("stats", stats);
				session.setAttribute("startDate", startDate);
				session.setAttribute("endDate", endDate);
			}
			} catch (DateTimeParseException e) {
			message = "Ngày thống kê không hợp lệ!";
		}
	}
} else if (request.getParameter("back") != null) {
	// quay lai tu SupplierInvoiceFrm6: hien lai ket qua thong ke truoc do
	stats = (SupplierStat6[]) session.getAttribute("stats");
	startDate = (LocalDate) session.getAttribute("startDate");
	endDate = (LocalDate) session.getAttribute("endDate");
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thống kê nhà cung cấp</title>
<link rel="stylesheet" href="../../css/style.css?v=20261115-header">
</head>
<body>
	<div class="header">
		<span class="user"><%=manager.getName()%></span>
		<h1>Thống kê nhà cung cấp</h1>
	</div>
	<div class="content">
		<form name="viewStats" action="SupplierStatsFrm6.jsp" method="post">
			<div class="row">
				<div class="col">
					<label for="in_startDate">Ngày bắt đầu</label>
					<input type="date" id="in_startDate" name="in_startDate" value="<%=startDate == null ? "" : startDate.toString()%>">
				</div>
				<div class="col">
					<label for="in_endDate">Ngày kết thúc</label>
					<input type="date" id="in_endDate" name="in_endDate" value="<%=endDate == null ? "" : endDate.toString()%>">
				</div>
				<div class="col">
					<label>&nbsp;</label>
					<button type="submit" id="sub_viewStats" class="inline">Xem thống kê</button>
				</div>
			</div>
		</form>

		<%
		if (!message.equals("")) {
		%><div id="out_message" class="message error"><%=message%></div>
		<%
		}
		%>

		<table id="out_supplierStats" class="list">
			<tr>
				<th>Mã NCC</th>
				<th>Tên nhà cung cấp</th>
				<th>Số điện thoại</th>
				<th>Địa chỉ</th>
				<th>Email</th>
				<th>Tổng lượng nhập</th>
				<th>Chi Tiết</th>
			</tr>
			<%
			if (stats != null)
				for (SupplierStat6 s : stats) {
			%>
			<tr>
				<td class="id"><%=s.getId()%></td>
				<td><%=s.getName()%></td>
				<td><%=s.getPhone()%></td>
				<td><%=s.getAddress()%></td>
				<td><%=s.getEmail()%></td>
				<td><%=s.getTotalImportQuantity().toPlainString()%></td>
				<td><a id="sub_selectSupplier" href="SupplierInvoiceFrm6.jsp?idSupplier=<%=s.getId()%>">Xem</a></td>
			</tr>
			<%
			}
			%>
		</table>

		<div class="footer">
			<a id="sub_back" class="btn inline" href="ReportSelectionFrm6.jsp">Quay lại</a>
		</div>
	</div>
</body>
</html>
