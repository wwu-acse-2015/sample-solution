package de.wwu.pi.acse.pizzaOrdering.web;

import javax.ejb.EJB;
import javax.ejb.EJBException;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.ViewScoped;

import de.wwu.pi.acse.pizzaOrdering.ejb.DishServiceBean;
import de.wwu.pi.acse.pizzaOrdering.entity.Dish;
import de.wwu.pi.acse.pizzaOrdering.web.util.Util;

@ManagedBean
@ViewScoped
public class DishDetails {

	@EJB
	private DishServiceBean dishService;

	private long id;
	private Dish dish;


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
			dish = dishService.getDish(id);
		}
		return dish;
	}

	public String submitMasterDataChanges() {
		dish = dishService.updateMasterData(dish);
		return toDishPage();
	}

	private String toDishPage() {
		return "/dish/details.xhtml?faces-redirect=true&id=" + id;
	}

	public String removeDish() {
		dishService.remove(id);
		return "/dish/list.xhtml";
	}

}
