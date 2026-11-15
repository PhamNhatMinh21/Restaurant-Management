package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.Arrays;

import model.ImportDetail6;
import model.Ingredient6;

public class ImportDetailDAO6 extends DAO6 {

	public ImportDetailDAO6() {
		super();
	}
	
	public ImportDetail6[] getImportDetail(String idInvoice) {
		ImportDetail6[] kq = null;
		int count = 0;
		String sql = "{call getImportDetail(?)}";
		try {
			CallableStatement cs = getConnection().prepareCall(sql);
			cs.setString(1, idInvoice);
			ResultSet rs = cs.executeQuery();
			while (rs.next()) {
				if (kq == null)
					kq = new ImportDetail6[10];
				ImportDetail6 detail = new ImportDetail6();
				detail.setId(rs.getString("id"));
				detail.setQuantity(rs.getBigDecimal("quantity"));
				detail.setPrice(rs.getBigDecimal("price"));
				detail.setAmount(detail.getQuantity().multiply(detail.getPrice()));
				// nguyen lieu
				Ingredient6 ingredient = new Ingredient6();
				ingredient.setId(rs.getString("idIngredient"));
				ingredient.setName(rs.getString("nameIngredient"));
				ingredient.setUnit(rs.getString("unit"));
				ingredient.setDescription(rs.getString("description"));
				detail.setIngredient(ingredient);
				if (count == kq.length)
					kq = Arrays.copyOf(kq, kq.length * 2);
				kq[count++] = detail;
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
