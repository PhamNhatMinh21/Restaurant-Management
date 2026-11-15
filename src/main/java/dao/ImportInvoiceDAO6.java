package dao;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.Arrays;

import model.ImportInvoice6;
import model.Supplier6;

public class ImportInvoiceDAO6 extends DAO6 {

	public ImportInvoiceDAO6() {
		super();
	}
	
	public ImportInvoice6[] getImportInvoice(String idSupplier, LocalDate startDate, LocalDate endDate) {
		ImportInvoice6[] kq = null;
		int count = 0;
		String sql = "{call getImportInvoice(?,?,?)}";
		try {
			CallableStatement cs = getConnection().prepareCall(sql);
			cs.setString(1, idSupplier);
			cs.setDate(2, Date.valueOf(startDate));
			cs.setDate(3, Date.valueOf(endDate));
			ResultSet rs = cs.executeQuery();
			while (rs.next()) {
				if (kq == null)
					kq = new ImportInvoice6[10];
				ImportInvoice6 invoice = new ImportInvoice6();
				invoice.setId(rs.getString("id"));
				invoice.setImportDate(rs.getDate("importDate").toLocalDate());
				invoice.setTotalAmount(rs.getBigDecimal("totalAmount"));
				invoice.setNote(rs.getString("note"));
				
				Supplier6 supplier = new Supplier6();
				supplier.setId(idSupplier);
				invoice.setSupplier(supplier);
				if (count == kq.length)
					kq = Arrays.copyOf(kq, kq.length * 2);
				kq[count++] = invoice;
			}
			if (kq != null)
				kq = Arrays.copyOf(kq, count);
		} catch (Exception e) {
			e.printStackTrace();
			kq = null;
		}
		return kq;
	}
}
