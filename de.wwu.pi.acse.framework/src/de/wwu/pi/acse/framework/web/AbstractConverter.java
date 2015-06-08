package de.wwu.pi.acse.framework.web;

import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;

import de.wwu.pi.acse.framework.data.AbstractEntity;
import de.wwu.pi.acse.framework.logic.AbstractServiceBean;

public abstract class AbstractConverter<T extends AbstractEntity> implements Converter {

	@Override
	public Object getAsObject(FacesContext context, UIComponent component, String value) {
		if (value == null) {
			return null;
		}
		return getService().get(Long.parseLong(value));
	}

	@Override
	public String getAsString(FacesContext context, UIComponent component, Object entity) {
		if (entity == null) {
			return "";
		}
		return "" + ((AbstractEntity) entity).getId();
	}

	public abstract AbstractServiceBean<T> getService();

}