package de.wwu.pi.acse.pizzaOrdering.web.util;

import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;

import de.wwu.pi.acse.pizzaOrdering.ejb.DishServiceBean;
import de.wwu.pi.acse.pizzaOrdering.entity.Dish;

@ManagedBean(name="dishConverter")
public class DishConverter implements Converter {

	@EJB
	private DishServiceBean service;

	public Object getAsObject(FacesContext context, UIComponent component, String value) {
		return service.getDish(Long.parseLong(value));
	}

	public String getAsString(FacesContext context, UIComponent component, Object entity) {
		return "" + ((Dish) entity).getId();
	}
}
