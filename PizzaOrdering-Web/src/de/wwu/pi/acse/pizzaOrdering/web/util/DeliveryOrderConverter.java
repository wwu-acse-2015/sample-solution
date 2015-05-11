package de.wwu.pi.acse.pizzaOrdering.web.util;

import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;

import de.wwu.pi.acse.pizzaOrdering.ejb.DeliveryOrderServiceBean;
import de.wwu.pi.acse.pizzaOrdering.entity.DeliveryOrder;

@ManagedBean(name="deliveryOrderConverter")
public class DeliveryOrderConverter implements Converter {

	@EJB
	private DeliveryOrderServiceBean service;

	public Object getAsObject(FacesContext context, UIComponent component, String value) {
		return service.getDeliveryOrder(Long.parseLong(value));
	}

	public String getAsString(FacesContext context, UIComponent component, Object entity) {
		return "" + ((DeliveryOrder) entity).getId();
	}
}
