package model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class SupplierStat6 extends Supplier6 {
	private BigDecimal totalImportQuantity;
	private LocalDate startDate;
	private LocalDate endDate;

	public SupplierStat6() {
		super();
	}

	public BigDecimal getTotalImportQuantity() {
		return totalImportQuantity;
	}

	public void setTotalImportQuantity(BigDecimal totalImportQuantity) {
		this.totalImportQuantity = totalImportQuantity;
	}

	public LocalDate getStartDate() {
		return startDate;
	}

	public void setStartDate(LocalDate startDate) {
		this.startDate = startDate;
	}

	public LocalDate getEndDate() {
		return endDate;
	}

	public void setEndDate(LocalDate endDate) {
		this.endDate = endDate;
	}
}
