"""Run against a rebuilt application on Tomcat and its existing MySQL database.

Uses existing sample records. HTTP save submits unchanged values. The Java
companion test verifies a changed value inside a transaction and rolls it back.
"""
import http.cookiejar
import os
import unittest
import urllib.parse
import urllib.request
from html.parser import HTMLParser


class Elements(HTMLParser):
    def __init__(self, text):
        super().__init__()
        self.elements = {}
        self.feed(text)

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if "id" in attrs:
            self.elements[attrs["id"]] = (tag, attrs)


class DesignFlowTests(unittest.TestCase):
    base = os.environ.get("APP_URL", "http://127.0.0.1:18080/RestaurantManagement6/")

    def setUp(self):
        self.client = urllib.request.build_opener(
            urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()))
        self.page("view/Member6/Login.jsp", {"username": "manager", "password": "123456"})

    def page(self, path, data=None, multipart=False):
        headers = {}
        if multipart:
            boundary = "DesignVerificationBoundary"
            body = "".join(
                f'--{boundary}\r\nContent-Disposition: form-data; name="{key}"\r\n\r\n{value}\r\n'
                for key, value in data.items()) + f"--{boundary}--\r\n"
            data = body.encode("utf-8")
            headers["Content-Type"] = f"multipart/form-data; boundary={boundary}"
        elif data is not None:
            data = urllib.parse.urlencode(data).encode("utf-8")
        request = urllib.request.Request(self.base + path, data=data, headers=headers)
        with self.client.open(request, timeout=30) as response:
            self.assertEqual(response.status, 200)
            return response.read().decode("utf-8"), response.url

    def test_dish_sequence_and_unchanged_save(self):
        home, _ = self.page("view/ManagerStaff6/ManagerHomeFrm6.jsp")
        self.assertIn('id="sub_manageDishes"', home)
        management, _ = self.page("view/ManagerStaff6/DishManagementFrm6.jsp")
        self.assertIn('id="sub_addDish"', management)
        search, _ = self.page("view/ManagerStaff6/DishSearchFrm6.jsp", {"in_dishName": ""})
        self.assertIn("M01", search)
        edit, _ = self.page("view/ManagerStaff6/DishEditFrm6.jsp?id=M01")
        elements = Elements(edit).elements
        self.assertEqual(elements["out_dishID"][0], "span")
        self.assertEqual(elements["inout_price"][1]["step"], "0.01")
        original = {key: elements[key][1]["value"] for key in
                    ("inout_name", "inout_price", "inout_category")}
        # HTMLParser decodes entities in attributes, and captures textarea content separately.
        from html import unescape
        import re
        original["inout_description"] = unescape(re.search(
            r'<textarea[^>]*id="inout_description"[^>]*>(.*?)</textarea>', edit, re.S).group(1))
        saved, _ = self.page("view/ManagerStaff6/DishEditFrm6.jsp", original, multipart=True)
        self.assertIn("Đã lưu thành công", saved)
        again, _ = self.page("view/ManagerStaff6/DishSearchFrm6.jsp?searchName=" +
                             urllib.parse.quote(original["inout_name"]))
        self.assertIn("M01", again)
        for invalid_price in ("1.234", "0", "-1", "100000000000000000.00", "abc"):
            invalid_data = dict(original, inout_price=invalid_price)
            rejected, _ = self.page("view/ManagerStaff6/DishEditFrm6.jsp", invalid_data, multipart=True)
            self.assertIn("2 chữ số thập phân", rejected)
            self.assertNotIn("Đã lưu thành công", rejected)
        original["inout_name"] = ""
        invalid, _ = self.page("view/ManagerStaff6/DishEditFrm6.jsp", original, multipart=True)
        self.assertIn("Tên món ăn không được để trống", invalid)

    def test_supplier_sequence_and_back(self):
        report, _ = self.page("view/ManagerStaff6/ReportSelectionFrm6.jsp")
        controls = Elements(report).elements
        for name in ("sub_supplierStats", "sub_customerStats", "sub_ingredientStats", "sub_dishStats"):
            self.assertEqual(controls[name][0], "button")
        self.page("view/ManagerStaff6/SupplierStatsFrm6.jsp")
        stats, _ = self.page("view/ManagerStaff6/SupplierStatsFrm6.jsp",
                             {"in_startDate": "2026-08-01", "in_endDate": "2026-08-31"})
        self.assertIn("NCC01", stats)
        invoices, _ = self.page("view/ManagerStaff6/SupplierInvoiceFrm6.jsp?idSupplier=NCC01")
        self.assertIn("HD01", invoices)
        self.assertIn("01/08/2026 - 31/08/2026", invoices)
        detail, _ = self.page("view/ManagerStaff6/ImportInvoiceDetailFrm6.jsp?idInvoice=HD01")
        for value in ("HD01", "NCC01", "NL01", "NL02", "15.500.000"):
            self.assertIn(value, detail)
        self.assertEqual(Elements(detail).elements["out_importDetails"][0], "table")
        self.page("view/ManagerStaff6/SupplierInvoiceFrm6.jsp?idSupplier=NCC01")
        back, _ = self.page("view/ManagerStaff6/SupplierStatsFrm6.jsp?back=1")
        self.assertIn("NCC01", back)
        self.assertIn('value="2026-08-01"', back)

    def test_validation_and_missing_context(self):
        for data, expected in [
            ({"in_startDate": "", "in_endDate": ""}, "Vui lòng chọn đầy đủ"),
            ({"in_startDate": "2026-08-31", "in_endDate": "2026-08-01"}, "Khoảng thời gian không hợp lệ"),
            ({"in_startDate": "bad", "in_endDate": "2026-08-01"}, "Ngày thống kê không hợp lệ"),
            ({"in_startDate": "2000-01-01", "in_endDate": "2000-01-02"}, "Không có dữ liệu"),
        ]:
            body, _ = self.page("view/ManagerStaff6/SupplierStatsFrm6.jsp", data)
            self.assertIn(expected, body)
        for path in ("SupplierInvoiceFrm6.jsp?idSupplier=missing", "ImportInvoiceDetailFrm6.jsp?idInvoice=missing"):
            _, url = self.page("view/ManagerStaff6/" + path)
            self.assertTrue(url.endswith("SupplierStatsFrm6.jsp"))
        self.client = urllib.request.build_opener(
            urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()))
        _, url = self.page("view/ManagerStaff6/ManagerHomeFrm6.jsp")
        self.assertIn("LoginFrm6.jsp?err=timeout", url)


if __name__ == "__main__":
    unittest.main(verbosity=2)
