<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="model.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Đăng nhập</title>
<link rel="stylesheet" href="../../css/style.css?v=20261115-header">
</head>
<body>
	<div class="header">
		<h1>Đăng nhập</h1>
	</div>
	<div class="content">
		<%
		String err = request.getParameter("err");
		if (err != null && err.equalsIgnoreCase("timeout")) {
		%><div class="message error">Hết phiên làm việc. Làm ơn đăng nhập lại!</div>
		<%
		} else if (err != null && err.equalsIgnoreCase("fail")) {
		%><div class="message error">Sai tên đăng nhập/mật khẩu!</div>
		<%
		}
		%>
		<form name="login" action="Login.jsp" method="post">
			<label>Tên đăng nhập</label>
			<input type="text" name="username" id="username" required>
			<label>Mật khẩu</label>
			<input type="password" name="password" id="password" required>
			<div class="footer">
				<input type="submit" class="inline" value="Đăng nhập">
			</div>
		</form>
	</div>
</body>
</html>
