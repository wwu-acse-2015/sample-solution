package de.wwu.pi.acse.pizzaOrdering.web.util;

import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;

import de.wwu.pi.acse.pizzaOrdering.ejb.CustomerServiceBean;
import de.wwu.pi.acse.pizzaOrdering.entity.Customer;

@ManagedBean(name="customerConverter")
public class CustomerConverter implements Converter {

	@EJB
	private CustomerServiceBean service;

	public Object getAsObject(FacesContext context, UIComponent component, String value) {
		return service.getCustomer(Long.parseLong(value));
	}

	public String getAsString(FacesContext context, UIComponent component, Object entity) {
		return "" + ((Customer) entity).getId();
	}

}
