package dao;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.Arrays;

import model.SupplierStat6;

public class SupplierStatDAO6 extends DAO6 {

	public SupplierStatDAO6() {
		super();
	}

	public SupplierStat6[] getSupplierStat(LocalDate startDate, LocalDate endDate) {
		SupplierStat6[] kq = null;
		int count = 0;
		String sql = "{call getSupplierStat(?,?)}";
		try {
			CallableStatement cs = getConnection().prepareCall(sql);
			cs.setDate(1, Date.valueOf(startDate));
			cs.setDate(2, Date.valueOf(endDate));
			ResultSet rs = cs.executeQuery();
			while (rs.next()) {
				if (kq == null)
					kq = new SupplierStat6[10];
				SupplierStat6 stat = new SupplierStat6();
				stat.setId(rs.getString("id"));
				stat.setName(rs.getString("name"));
				stat.setPhone(rs.getString("phone"));
				stat.setAddress(rs.getString("address"));
				stat.setEmail(rs.getString("email"));
				stat.setTotalImportQuantity(rs.getBigDecimal("totalImportQuantity"));
				stat.setStartDate(startDate);
				stat.setEndDate(endDate);
				if (count == kq.length)
					kq = Arrays.copyOf(kq, kq.length * 2);
				kq[count++] = stat;
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
