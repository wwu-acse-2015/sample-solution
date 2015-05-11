package de.wwu.pi.acse.pizzaOrdering.web;

import javax.ejb.EJB;
import javax.ejb.EJBException;
import javax.faces.bean.ManagedBean;

import de.wwu.pi.acse.pizzaOrdering.ejb.DishServiceBean;
import de.wwu.pi.acse.pizzaOrdering.entity.Dish;
import de.wwu.pi.acse.pizzaOrdering.web.util.Util;

@ManagedBean
public class DishCreate {

	@EJB
	private DishServiceBean dishService;

	private Dish dish = new Dish();

	private String errorMessage;

	public Dish getDish() {
		return dish;
	}

	public String persist() {
		// Action
		try {
			dish = dishService.create(dish);
		} catch (EJBException e) {
			errorMessage = "Dish not created: "
					+ Util.getCausingMessage(e);
		}

		// Navigation
		if (isError())
			return null;
		else {
			return "/dish/details.xhtml?faces-redirect=true&id="
					+ dish.getId();
		}
	}

	public boolean isError() {
		return errorMessage != null;
	}

	public String getErrorMessage() {
		return errorMessage != null ? errorMessage : "";
	}
}
