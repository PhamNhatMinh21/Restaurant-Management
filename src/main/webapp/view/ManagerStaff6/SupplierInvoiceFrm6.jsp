<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.text.*,java.time.*,java.time.format.*,java.util.*,dao.*,model.*"%>
<%
ManagerStaff6 manager = (ManagerStaff6) session.getAttribute("manager");
if (manager == null) {
	response.sendRedirect("../Member6/LoginFrm6.jsp?err=timeout");
	return;
}
DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
DecimalFormat df = new DecimalFormat("#,##0.####", new DecimalFormatSymbols(Locale.forLanguageTag("vi")));
// thong tin nha cung cap va khoang thoi gian duoc chon o SupplierStatsFrm6
String idSupplier = request.getParameter("idSupplier");
SupplierStat6[] stats = (SupplierStat6[]) session.getAttribute("stats");
LocalDate startDate = (LocalDate) session.getAttribute("startDate");
LocalDate endDate = (LocalDate) session.getAttribute("endDate");
Supplier6 supplier = null;
if (stats != null && idSupplier != null)
	for (SupplierStat6 s : stats)
		if (s.getId().equals(idSupplier)) {
			supplier = s;
			break;
		}
if (supplier == null || startDate == null || endDate == null) {
	response.sendRedirect("SupplierStatsFrm6.jsp");
	return;
}
session.setAttribute("supplier", supplier);
ImportInvoice6[] invoices;
try (ImportInvoiceDAO6 dao = new ImportInvoiceDAO6()) {
	invoices = dao.getImportInvoice(supplier.getId(), startDate, endDate);
}
session.setAttribute("invoices", invoices);
String message = "";
if (invoices == null)
	message = "Không có hóa đơn nhập nào của nhà cung cấp trong khoảng thời gian đã chọn!";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hóa đơn nhập của nhà cung cấp</title>
<link rel="stylesheet" href="../../css/style.css?v=20261115-header">
</head>
<body>
	<div class="header">
		<span class="user"><%=manager.getName()%></span>
		<h1>Hóa đơn nhập của nhà cung cấp</h1>
	</div>
	<div class="content">
		<div class="info">
			<div id="out_supplier">
				Mã NCC: <%=supplier.getId()%> - <%=supplier.getName()%><br>
				Số điện thoại: <%=supplier.getPhone()%><br>
				Email: <%=supplier.getEmail()%><br>
				Địa chỉ: <%=supplier.getAddress()%>
			</div>
			<div id="out_dateRange">Khoảng thời gian: <%=startDate.format(fmt)%> - <%=endDate.format(fmt)%></div>
		</div>

		<%
		if (!message.equals("")) {
		%><div id="out_message" class="message error"><%=message%></div>
		<%
		}
		%>

		<table id="out_importInvoices" class="list">
			<tr>
				<th>Mã hóa đơn</th>
				<th>Ngày nhập</th>
				<th>Tổng tiền(VND)</th>
				<th>Ghi chú</th>
				<th>Chi Tiết</th>
			</tr>
			<%
			if (invoices != null)
				for (ImportInvoice6 inv : invoices) {
			%>
			<tr>
				<td class="id"><%=inv.getId()%></td>
				<td><%=inv.getImportDate().format(fmt)%></td>
				<td><%=df.format(inv.getTotalAmount())%></td>
				<td><%=inv.getNote()%></td>
				<td><a id="sub_selectImportInvoice" href="ImportInvoiceDetailFrm6.jsp?idInvoice=<%=inv.getId()%>">Xem</a></td>
			</tr>
			<%
			}
			%>
		</table>

		<div class="footer">
			<a id="sub_back" class="btn inline" href="SupplierStatsFrm6.jsp?back=1">Quay lại</a>
		</div>
	</div>
</body>
</html>
