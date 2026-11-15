package model;

import java.math.BigDecimal;

public class ImportDetail6 {
	private String id;
	private BigDecimal quantity;
	private BigDecimal price;
	private BigDecimal amount;
	private Ingredient6 ingredient;

	public ImportDetail6() {
		super();
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public BigDecimal getQuantity() {
		return quantity;
	}

	public void setQuantity(BigDecimal quantity) {
		this.quantity = quantity;
	}

	public BigDecimal getPrice() {
		return price;
	}

	public void setPrice(BigDecimal price) {
		this.price = price;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public Ingredient6 getIngredient() {
		return ingredient;
	}

	public void setIngredient(Ingredient6 ingredient) {
		this.ingredient = ingredient;
	}
}
