package de.wwu.pi.acse.PizzaXX.web;

import javax.ejb.EJB;
import javax.faces.bean.ManagedBean;

import de.wwu.pi.acse.framework.logic.AbstractServiceBean;
import de.wwu.pi.acse.framework.web.AbstractConverter;

import de.wwu.pi.acse.PizzaXX.ejb.DeliveryOrderServiceBean;
import de.wwu.pi.acse.PizzaXX.entity.DeliveryOrder;

@ManagedBean(name="deliveryOrderConverter")
public class DeliveryOrderConverter extends AbstractConverter<DeliveryOrder> {

	@EJB
	private DeliveryOrderServiceBean service;

	public AbstractServiceBean<DeliveryOrder> getService() {
		return service;
	}
}
