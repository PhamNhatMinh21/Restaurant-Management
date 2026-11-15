"""Check every screen attribute listed in the supplied class diagrams."""
from pathlib import Path
import re
from verify_design import Elements

ROOT = Path(__file__).resolve().parents[1]
CONTROLS = {
    "ManagerHomeFrm6": "sub_manageDishes:Link,sub_viewStatistics:Link,sub_makeCombos:Link",
    "DishManagementFrm6": "sub_editDish:Link,sub_addDish:Link,sub_back:Link",
    "DishSearchFrm6": "in_dishName:TextInput,sub_searchDishes:Button,out_dishes:Table,sub_selectDish:Link,sub_back:Link",
    "DishEditFrm6": "out_dishID:Label,inout_name:TextInput,inout_image:FileInput,inout_price:NumberInput,inout_category:TextInput,inout_description:TextArea,sub_saveDish:Button,out_message:Label,sub_back:Link",
    "ReportSelectionFrm6": "sub_supplierStats:Button,sub_customerStats:Button,sub_ingredientStats:Button,sub_dishStats:Button,sub_back:Link",
    "SupplierStatsFrm6": "in_startDate:DateInput,in_endDate:DateInput,sub_viewStats:Button,out_supplierStats:Table,sub_selectSupplier:Link,out_message:Label,sub_back:Link",
    "SupplierInvoiceFrm6": "out_supplier:Label,out_dateRange:Label,out_importInvoices:Table,sub_selectImportInvoice:Link,out_message:Label,sub_back:Link",
    "ImportInvoiceDetailFrm6": "out_importInvoices:Label,out_supplier:Label,out_importDetails:Table,out_totalAmount:Label,out_message:Label,sub_back:Link",
}
DATA = {
    "ManagerHomeFrm6": "manager:ManagerStaff6",
    "DishManagementFrm6": "manager:ManagerStaff6",
    "DishSearchFrm6": "manager:ManagerStaff6,dishes:Dish6[]",
    "DishEditFrm6": "manager:ManagerStaff6,dish:Dish6,searchName:String,newImage:Part",
    "ReportSelectionFrm6": "manager:ManagerStaff6",
    "SupplierStatsFrm6": "manager:ManagerStaff6,stats:SupplierStat6[],startDate:LocalDate,endDate:LocalDate",
    "SupplierInvoiceFrm6": "manager:ManagerStaff6,supplier:Supplier6,startDate:LocalDate,endDate:LocalDate,invoices:ImportInvoice6[]",
    "ImportInvoiceDetailFrm6": "manager:ManagerStaff6,invoice:ImportInvoice6,supplier:Supplier6,details:ImportDetail6[],startDate:LocalDate,endDate:LocalDate",
}


def check():
    count = 0
    rows = []
    for page, spec in CONTROLS.items():
        source = (ROOT / "src/main/webapp/view/ManagerStaff6" / (page + ".jsp")).read_text(encoding="utf-8")
        elements = Elements(source).elements
        for item in spec.split(","):
            name, expected = item.split(":")
            assert name in elements, f"{page}: missing {name}"
            tag, attrs = elements[name]
            actual = {"a": "Link", "button": "Button", "table": "Table", "textarea": "TextArea",
                      "span": "Label", "div": "Label", "label": "Label"}.get(tag)
            if tag == "input":
                actual = {"text": "TextInput", "number": "NumberInput", "file": "FileInput", "date": "DateInput"}.get(attrs.get("type"))
            assert actual == expected, f"{page}.{name}: {actual} != {expected}"
            rows.append(f"| {page} | {name} | {expected} | {tag} | Khớp |")
            count += 1
        for item in DATA[page].split(","):
            name, expected = item.split(":")
            assert re.search(r"\b" + re.escape(expected) + r"\s+" + re.escape(name) + r"\s*[=;]", source), f"{page}.{name}: wrong/missing {expected}"
            rows.append(f"| {page} | {name} | {expected} | {expected} | Khớp |")
            count += 1
    print(f"PASS: {count} screen attributes, names and component/data types across 8 screens.")
    return rows


if __name__ == "__main__":
    check()
