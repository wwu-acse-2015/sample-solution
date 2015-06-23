package de.wwu.pi.acse.PizzaXX.web;

import java.util.Collection;

import javax.ejb.EJB;
import javax.ejb.EJBException;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

import de.wwu.pi.acse.PizzaXX.ejb.DishServiceBean;
import de.wwu.pi.acse.PizzaXX.entity.Dish;
import de.wwu.pi.acse.framework.web.Util;

@ManagedBean
@ViewScoped
public class DishListDetails {

	@EJB
	private DishServiceBean dishService;

	private long id;
	private Dish dish;
	private String errorMessage;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
		init();
	}

	public void init() {
		dish = null;
	}

	public void ensureInitialized() {
		try {
			if (getDish() != null)
				// Success
				return;
		} catch (EJBException e) {
			e.printStackTrace();
		}
		Util.redirectToRoot();
	}

	public Dish getDish() {
		if (dish == null) {
			dish = dishService.getWithFetchedReferences(id);
		}
		return dish;
	}

	public boolean isError() {
		return errorMessage != null;
	}

	public String getErrorMessage() {
		return errorMessage != null ? errorMessage : "";
	}

	private void resetError() {
		errorMessage = null;
	}

	public String persist() {
		dish = dishService.updateMasterData(dish);
		return toPage();
	}

	private String toPage() {
		return "/dish/DishListDetails.xhtml?faces-redirect=true&id=" + id;
	}

	public String remove() {
		dishService.remove(id);
		return "/dish/DishList.xhtml";
	}

}
