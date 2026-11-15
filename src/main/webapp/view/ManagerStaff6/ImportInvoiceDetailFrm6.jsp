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
// hoa don nhap duoc chon o SupplierInvoiceFrm6
String idInvoice = request.getParameter("idInvoice");
ImportInvoice6[] invoices = (ImportInvoice6[]) session.getAttribute("invoices");
Supplier6 supplier = (Supplier6) session.getAttribute("supplier");
LocalDate startDate = (LocalDate) session.getAttribute("startDate");
LocalDate endDate = (LocalDate) session.getAttribute("endDate");
ImportInvoice6 invoice = null;
if (invoices != null && idInvoice != null)
	for (ImportInvoice6 inv : invoices)
		if (inv.getId().equals(idInvoice)) {
			invoice = inv;
			break;
		}
if (invoice == null || supplier == null || startDate == null || endDate == null) {
	response.sendRedirect("SupplierStatsFrm6.jsp");
	return;
}
ImportDetail6[] details;
try (ImportDetailDAO6 dao = new ImportDetailDAO6()) {
	details = dao.getImportDetail(invoice.getId());
}
invoice.setSupplier(supplier);
invoice.setDetails(details);
String message = "";
if (details == null)
	message = "Không tải được chi tiết nguyên liệu của hóa đơn này, vui lòng thử lại sau!";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Chi Tiết Hóa Đơn Nhập</title>
<link rel="stylesheet" href="../../css/style.css?v=20261115-header">
</head>
<body>
	<div class="header">
		<span class="user"><%=manager.getName()%></span>
		<h1>Chi Tiết Hóa Đơn Nhập</h1>
	</div>
	<div class="content">
		<div class="info">
			<div id="out_importInvoices">
				Mã hóa đơn: <%=invoice.getId()%><br>
				Ngày nhập: <%=invoice.getImportDate().format(fmt)%><br>
				Ghi chú: <%=invoice.getNote()%>
			</div>
			<div id="out_supplier">
				Mã NCC: <%=supplier.getId()%><br>
				Tên: <%=supplier.getName()%><br>
				Số điện thoại: <%=supplier.getPhone()%><br>
				Email: <%=supplier.getEmail()%><br>
				Địa chỉ: <%=supplier.getAddress()%>
			</div>
		</div>

		<%
		if (!message.equals("")) {
		%><div id="out_message" class="message error"><%=message%></div>
		<%
		}
		%>

		<table id="out_importDetails" class="list">
			<tr>
				<th>Mã chi tiết</th>
				<th>Mã nguyên liệu</th>
				<th>Tên nguyên liệu</th>
				<th>Đơn vị tính</th>
				<th>Mô tả</th>
				<th>Số lượng</th>
				<th>Đơn giá</th>
				<th>Thành tiền</th>
			</tr>
			<%
			if (details != null)
				for (ImportDetail6 d : details) {
			%>
			<tr>
				<td class="id"><%=d.getId()%></td>
				<td class="id"><%=d.getIngredient().getId()%></td>
				<td><%=d.getIngredient().getName()%></td>
				<td><%=d.getIngredient().getUnit()%></td>
				<td><%=d.getIngredient().getDescription()%></td>
				<td><%=d.getQuantity().stripTrailingZeros().toPlainString()%></td>
				<td><%=df.format(d.getPrice())%></td>
				<td><%=df.format(d.getAmount())%></td>
			</tr>
			<%
			}
			%>
		</table>

		<div class="total">
			<span id="out_totalAmount">Tổng tiền: <%=df.format(invoice.getTotalAmount())%> VND</span>
		</div>

		<div class="footer">
			<a id="sub_back" class="btn inline" href="SupplierInvoiceFrm6.jsp?idSupplier=<%=supplier.getId()%>">Quay lại</a>
		</div>
	</div>
</body>
</html>
