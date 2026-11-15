package model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class ImportInvoice6 {
	private String id;
	private LocalDate importDate;
	private BigDecimal totalAmount;
	private String note;
	private Supplier6 supplier;
	private ImportDetail6[] details;

	public ImportInvoice6() {
		super();
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public LocalDate getImportDate() {
		return importDate;
	}

	public void setImportDate(LocalDate importDate) {
		this.importDate = importDate;
	}

	public BigDecimal getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(BigDecimal totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public Supplier6 getSupplier() {
		return supplier;
	}

	public void setSupplier(Supplier6 supplier) {
		this.supplier = supplier;
	}

	public ImportDetail6[] getDetails() {
		return details;
	}

	public void setDetails(ImportDetail6[] details) {
		this.details = details;
	}
}
