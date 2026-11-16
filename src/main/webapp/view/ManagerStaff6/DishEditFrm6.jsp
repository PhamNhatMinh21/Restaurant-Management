<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
	import="java.io.File,java.math.BigDecimal,java.net.URLEncoder,java.util.*,jakarta.servlet.http.Part,dao.*,model.*"%>
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
String searchName = (String) session.getAttribute("searchName");
if (searchName == null)
	searchName = "";
Dish6 dish = null;
String message = "";
boolean success = false;
boolean nameError = false;

if (request.getMethod().equalsIgnoreCase("POST")) {
	// luu: lay du lieu vua nhap va cap nhat cac thuoc tinh cua doi tuong dish
	dish = (Dish6) session.getAttribute("dish");
	if (dish == null) {
		response.sendRedirect("DishSearchFrm6.jsp");
		return;
	}
	String name = request.getParameter("inout_name");
	String priceText = request.getParameter("inout_price");
	String category = request.getParameter("inout_category");
	String description = request.getParameter("inout_description");
	Part newImage = request.getPart("inout_image");
	BigDecimal price = null;
	// giu lai du lieu vua nhap tren form
	dish.setName(name == null ? "" : name.trim());
	dish.setCategory(category == null ? "" : category.trim());
	dish.setDescription(description == null ? "" : description.trim());
	if (name == null || name.trim().length() == 0) {
		message = "Tên món ăn không được để trống!";
		nameError = true;
	} else {
		try {
			price = new BigDecimal(priceText.trim()).setScale(2, java.math.RoundingMode.UNNECESSARY);
			if (price.signum() <= 0 || price.precision() > 19)
				price = null;
		} catch (Exception e) {
			price = null;
		}
		if (price == null)
			message = "Đơn giá phải lớn hơn 0, tối đa 17 chữ số phần nguyên và 2 chữ số thập phân!";
	}
	if (message.equals("")) {
		dish.setPrice(price);
		if (newImage != null && newImage.getSize() > 0) {
			String submitted = newImage.getSubmittedFileName();
			String ext = submitted.lastIndexOf('.') >= 0 ? submitted.substring(submitted.lastIndexOf('.')) : ".jpg";
			String imageDir = application.getRealPath("/images");
			new File(imageDir).mkdirs();
			String fileName = dish.getId() + "_" + System.currentTimeMillis() + ext;
			newImage.write(imageDir + File.separator + fileName);
			dish.setImage("images/" + fileName);
		}
		boolean kq;
		try (DishDAO6 dao = new DishDAO6()) {
			kq = dao.editDish(dish);
		}
		if (kq) {
			success = true;
			message = "Đã lưu thành công";
		} else {
			message = "Cập nhật thất bại: món ăn không tồn tại, tên món ăn đã tồn tại hoặc lỗi kết nối cơ sở dữ liệu!";
		}
	}
} else {
	// duoc goi tu DishSearchFrm6: lay mon an duoc chon trong danh sach ket qua
	String id = request.getParameter("id");
	Dish6[] dishes = (Dish6[]) session.getAttribute("dishes");
	if (id != null && dishes != null)
		for (Dish6 d : dishes)
			if (d.getId().equals(id)) {
				dish = new Dish6();
				dish.setId(d.getId());
				dish.setName(d.getName());
				dish.setImage(d.getImage());
				dish.setPrice(d.getPrice());
				dish.setCategory(d.getCategory());
				dish.setDescription(d.getDescription());
				break;
			}
	if (dish == null) {
		response.sendRedirect("DishSearchFrm6.jsp");
		return;
	}
	session.setAttribute("dish", dish);
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sửa thông tin món ăn</title>
<link rel="stylesheet" href="../../css/style.css?v=20261116-edit-layout">
</head>
<body>
	<div class="header">
		<span class="user"><%=manager.getName()%></span>
		<h1>Sửa thông tin món ăn</h1>
	</div>
	<div class="content">
		<form name="editDish" class="dish-edit-form" action="DishEditFrm6.jsp" method="post" enctype="multipart/form-data">
			<div class="dish-edit-grid">
				<div class="dish-edit-left">
					<label>Mã món</label>
					<span id="out_dishID" class="readonly-input"><%=h(dish.getId())%></span>

					<label>Ảnh hiện tại</label>
					<div class="dish-image-box">
						<%
						if (dish.getImage() != null && dish.getImage().length() > 0) {
						%><img id="dishPreview" src="<%=request.getContextPath()%>/<%=h(dish.getImage())%>" alt="<%=h(dish.getName())%>">
						<%
						} else {
						%><div id="dishPreviewEmpty" class="dish-image-empty">Chưa có ảnh</div>
						<%
						}
						%>
					</div>
					<input type="file" id="inout_image" name="inout_image" accept="image/*" class="dish-file-input">
					<label for="inout_image" class="btn dish-image-btn">Chọn / thay ảnh</label>
					<div id="selectedImageName" class="dish-file-name"></div>
				</div>

				<div class="dish-edit-right">
					<label for="inout_name">Tên món</label>
					<input type="text" id="inout_name" name="inout_name" value="<%=h(dish.getName())%>"
						<%=nameError ? "class=\"error\"" : ""%>>

					<div class="form-line">
						<div>
							<label for="inout_price">Giá bán (VND)</label>
							<input type="number" id="inout_price" name="inout_price" min="0.01" step="0.01" max="99999999999999999.99"
								value="<%=dish.getPrice() == null ? "" : dish.getPrice().toPlainString()%>">
						</div>
						<div>
							<label for="inout_category">Nhóm món</label>
							<input type="text" id="inout_category" name="inout_category" value="<%=h(dish.getCategory())%>">
						</div>
					</div>

					<label for="inout_description">Mô tả</label>
					<textarea id="inout_description" name="inout_description" rows="4"><%=h(dish.getDescription())%></textarea>
				</div>
			</div>

			<%
			if (!message.equals("")) {
			%><div id="out_message" class="message <%=success ? "success" : "error"%>"><%=success ? "✓ " : ""%><%=message%></div>
			<%
			}
			%>

			<div class="footer dish-edit-footer">
				<a id="sub_back" class="btn inline"
					href="DishSearchFrm6.jsp?searchName=<%=URLEncoder.encode(searchName, "UTF-8")%>">Quay lại</a>
				<button type="submit" id="sub_saveDish" class="inline">Lưu</button>
			</div>
		</form>
	</div>
	<script>
		(function() {
			var input = document.getElementById("inout_image");
			var preview = document.getElementById("dishPreview");
			var empty = document.getElementById("dishPreviewEmpty");
			var nameBox = document.getElementById("selectedImageName");
			if (!input) return;
			input.addEventListener("change", function() {
				if (input.files && input.files[0]) {
					var file = input.files[0];
					if (nameBox) {
						nameBox.textContent = "Đã chọn: " + file.name;
						nameBox.classList.add("visible");
					}
					if (preview) {
						preview.src = URL.createObjectURL(file);
					} else if (empty && empty.parentNode) {
						var img = document.createElement("img");
						img.id = "dishPreview";
						img.alt = "Ảnh xem trước";
						img.src = URL.createObjectURL(file);
						empty.parentNode.replaceChild(img, empty);
						preview = img;
						empty = null;
					}
				}
			});
		})();
	</script>
</body>
</html>
