package dao;

import java.sql.CallableStatement;
import java.sql.ResultSet;

import model.ManagerStaff6;

public class ManagerStaffDAO6 extends DAO6 {

	public ManagerStaffDAO6() {
		super();
	}

	public boolean checkLogin(ManagerStaff6 manager) {
		boolean kq = false;
		String sql = "{call checkLogin(?,?)}"; 
		try {
			CallableStatement cs = getConnection().prepareCall(sql);
			cs.setString(1, manager.getUsername());
			cs.setString(2, manager.getPassword());
			ResultSet rs = cs.executeQuery();
			if (rs.next()) {
				manager.setId(rs.getString("id"));
				manager.setName(rs.getString("name"));
				manager.setRole(rs.getString("role"));
				manager.setSalary(rs.getBigDecimal("salary"));
				kq = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
			kq = false;
		}
		return kq;
	}
}
