package de.wwu.pi.acse.pizzaOrdering.entity;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
public class Dish {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private long id;
	@NotNull(message="Name is a required field")
	private String name;
	@NotNull(message="Description is a required field")
	private String description;
	@NotNull(message="Price is a required field")
	private int price;

	// Default Constructor
	public Dish() {
		super();
	}

	public long getId() {
		return this.id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	@Override
	public String toString() {
		return getName() + ", " + getDescription() + ", " + getPrice();
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + (int) (this.getId() ^ (this.getId() >>> 32));
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Dish other = (Dish) obj;
		if (this.getId() != other.getId())
			return false;
		return true;
	}
}
