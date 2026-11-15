package model;

import java.math.BigDecimal;

public class Staff6 extends User6 {
	private String role;
	private BigDecimal salary;

	public Staff6() {
		super();
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public BigDecimal getSalary() {
		return salary;
	}

	public void setSalary(BigDecimal salary) {
		this.salary = salary;
	}
}
