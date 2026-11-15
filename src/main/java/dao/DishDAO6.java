package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.util.Arrays;

import model.Dish6;

public class DishDAO6 extends DAO6 {

	public DishDAO6() {
		super();
	}

	public Dish6[] searchDish(String name) {
		Dish6[] kq = null;
		int count = 0;
		String sql = "{call searchDish(?)}";
		try {
			CallableStatement cs = getConnection().prepareCall(sql);
			cs.setString(1, name);
			ResultSet rs = cs.executeQuery();
			while (rs.next()) {
				if (kq == null)
					kq = new Dish6[10];
				Dish6 dish = new Dish6();
				dish.setId(rs.getString("id"));
				dish.setName(rs.getString("name"));
				dish.setImage(rs.getString("image"));
				dish.setPrice(rs.getBigDecimal("price"));
				dish.setCategory(rs.getString("category"));
				dish.setDescription(rs.getString("description"));
				if (count == kq.length)
					kq = Arrays.copyOf(kq, kq.length * 2);
				kq[count++] = dish;
			}
			if (kq != null)
				kq = Arrays.copyOf(kq, count);
		} catch (Exception e) {
			e.printStackTrace();
			kq = null;
		}
		return kq;
	}

	public boolean editDish(Dish6 dish) {
		boolean kq = false;
		String sql = "{call editDish(?,?,?,?,?,?)}";
		try {
			CallableStatement cs = getConnection().prepareCall(sql);
			cs.setString(1, dish.getId());
			cs.setString(2, dish.getName());
			cs.setString(3, dish.getImage());
			cs.setBigDecimal(4, dish.getPrice());
			cs.setString(5, dish.getCategory());
			cs.setString(6, dish.getDescription());
			ResultSet rs = cs.executeQuery();
			if (rs.next()) {
				kq = (rs.getInt("kq") == 1);
			}
		} catch (Exception e) {
			e.printStackTrace();
			kq = false;
		}
		return kq;
	}
}
