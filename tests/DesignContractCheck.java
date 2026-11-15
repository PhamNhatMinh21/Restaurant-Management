import dao.*;
import model.*;
import java.lang.reflect.*;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.Map;

public class DesignContractCheck {
    static void require(boolean condition, String message) {
        if (!condition) throw new AssertionError(message);
    }

    static void fields(Class<?> type, String spec) throws Exception {
        String[] entries = spec.isEmpty() ? new String[0] : spec.split(",");
        require(type.getDeclaredFields().length == entries.length, type + " unexpected field count");
        for (String entry : entries) {
            String[] pair = entry.split(":");
            Field field = type.getDeclaredField(pair[0]);
            require(field.getType().getSimpleName().equals(pair[1]), type + "." + pair[0] + " wrong type");
            require(Modifier.isPrivate(field.getModifiers()), field + " must be private");
            require(!Modifier.isStatic(field.getModifiers()), field + " must be an instance field");
            String suffix = Character.toUpperCase(pair[0].charAt(0)) + pair[0].substring(1);
            require(type.getMethod("get" + suffix).getReturnType() == field.getType(), "Getter type");
            type.getMethod("set" + suffix, field.getType());
        }
    }

    public static void main(String[] args) throws Exception {
        for (var entry : Map.of(
                User6.class, "id:String,name:String,username:String,password:String,dob:LocalDate,address:String,phone:String",
                Staff6.class, "role:String,salary:BigDecimal",
                ManagerStaff6.class, "",
                Dish6.class, "id:String,image:String,name:String,price:BigDecimal,category:String,description:String",
                Supplier6.class, "id:String,name:String,phone:String,address:String,email:String",
                SupplierStat6.class, "totalImportQuantity:BigDecimal,startDate:LocalDate,endDate:LocalDate",
                ImportInvoice6.class, "id:String,importDate:LocalDate,totalAmount:BigDecimal,note:String,supplier:Supplier6,details:ImportDetail6[]",
                ImportDetail6.class, "id:String,quantity:BigDecimal,price:BigDecimal,amount:BigDecimal,ingredient:Ingredient6",
                Ingredient6.class, "id:String,name:String,unit:String,description:String").entrySet()) {
            fields(entry.getKey(), entry.getValue());
        }
        require(Staff6.class.getSuperclass() == User6.class, "Staff inheritance");
        require(ManagerStaff6.class.getSuperclass() == Staff6.class, "Manager inheritance");
        require(SupplierStat6.class.getSuperclass() == Supplier6.class, "Statistics inheritance");
        Field connectionField = DAO6.class.getDeclaredField("con");
        require(connectionField.getType() == Connection.class && Modifier.isPrivate(connectionField.getModifiers())
                && !Modifier.isStatic(connectionField.getModifiers()), "private Connection con");
        require(DishDAO6.class.getMethod("searchDish", String.class).getReturnType() == Dish6[].class, "Dish array");
        require(DishDAO6.class.getMethod("editDish", Dish6.class).getReturnType() == boolean.class, "Edit result");
        require(SupplierStatDAO6.class.getMethod("getSupplierStat", LocalDate.class, LocalDate.class).getReturnType() == SupplierStat6[].class, "Stats array");
        require(ImportInvoiceDAO6.class.getMethod("getImportInvoice", String.class, LocalDate.class, LocalDate.class).getReturnType() == ImportInvoice6[].class, "Invoice array");
        require(ImportDetailDAO6.class.getMethod("getImportDetail", String.class).getReturnType() == ImportDetail6[].class, "Detail array");
        System.out.println("PASS: all 38 model fields, getters/setters, inheritance, private instance connection, DAO signatures.");

        connectionField.setAccessible(true);
        try (DishDAO6 dao = new DishDAO6()) {
            Connection connection = (Connection) connectionField.get(dao);
            require(connection != null, "MySQL connection required");
            connection.setAutoCommit(false);
            try {
                Dish6[] dishes = dao.searchDish("");
                require(dishes != null && dishes.length > 10, "Real data must exercise array growth");
                Dish6 dish = dishes[0];
                BigDecimal original = dish.getPrice();
                dish.setPrice(original.add(new BigDecimal("0.25")));
                require(dao.editDish(dish), "Real database update");
                try (PreparedStatement query = connection.prepareStatement("SELECT price FROM tblDish6 WHERE id=?")) {
                    query.setString(1, dish.getId());
                    try (ResultSet result = query.executeQuery()) {
                        require(result.next() && result.getBigDecimal(1).compareTo(dish.getPrice()) == 0, "Updated price persisted inside transaction");
                    }
                    connection.rollback();
                    try (ResultSet result = query.executeQuery()) {
                        require(result.next() && result.getBigDecimal(1).compareTo(original) == 0, "Rollback restored original price");
                    }
                }
            } finally {
                connection.rollback();
                connection.setAutoCommit(true);
            }
        }
        System.out.println("PASS: real MySQL search >10 rows, changed-price update, read-back, rollback, original price restored.");
        try (ImportDetailDAO6 dao = new ImportDetailDAO6()) {
            Connection connection = (Connection) connectionField.get(dao);
            connection.setAutoCommit(false);
            String detailId;
            String invoiceId;
            BigDecimal originalQuantity;
            BigDecimal originalPrice;
            try {
                try (Statement s = connection.createStatement(); ResultSet r = s.executeQuery(
                        "SELECT id,tblImportInvoice6id,quantity,price FROM tblImportDetail6 ORDER BY id LIMIT 1")) {
                    require(r.next(), "Sample import detail required");
                    detailId = r.getString(1);
                    invoiceId = r.getString(2);
                    originalQuantity = r.getBigDecimal(3);
                    originalPrice = r.getBigDecimal(4);
                }
                try (PreparedStatement s = connection.prepareStatement("UPDATE tblImportDetail6 SET quantity=1.25,price=2.35 WHERE id=?")) {
                    s.setString(1, detailId);
                    require(s.executeUpdate() == 1, "Update decimal quantity and price");
                }
                boolean found = false;
                for (ImportDetail6 detail : dao.getImportDetail(invoiceId)) {
                    if (detail.getId().equals(detailId)) {
                        found = true;
                        require(detail.getQuantity().compareTo(new BigDecimal("1.25")) == 0, "Quantity retains 2 decimals");
                        require(detail.getPrice().compareTo(new BigDecimal("2.35")) == 0, "Import price retains 2 decimals");
                        require(detail.getAmount().compareTo(new BigDecimal("2.9375")) == 0, "Derived amount preserves exact product");
                    }
                }
                require(found, "Updated detail returned by DAO");
                connection.rollback();
                try (PreparedStatement s = connection.prepareStatement("SELECT quantity,price FROM tblImportDetail6 WHERE id=?")) {
                    s.setString(1, detailId);
                    try (ResultSet r = s.executeQuery()) {
                        require(r.next() && r.getBigDecimal(1).compareTo(originalQuantity) == 0
                                && r.getBigDecimal(2).compareTo(originalPrice) == 0, "Import values restored");
                    }
                }
            } finally {
                connection.rollback();
                connection.setAutoCommit(true);
            }
        }
        System.out.println("PASS: quantity 1.25, price 2.35, exact derived amount 2.9375; original import values restored.");
    }
}
