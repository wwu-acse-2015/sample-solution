package de.wwu.pi.acse.umlToApp.web.beans

import de.wwu.pi.acse.umlToApp.util.GeneratorWithImports
import org.eclipse.uml2.uml.Class

import static extension de.wwu.pi.acse.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.ModelAndPackageHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.GUIHelper.*

class CreateBeanGenerator extends GeneratorWithImports {
	override doGenerate(Class clazz) {
	var entityName = clazz.name.toFirstLower
	'''
		package «clazz.guiPackageString»;

		import java.util.Collection;

		import javax.ejb.EJB;
		import javax.ejb.EJBException;
		import javax.faces.bean.ManagedBean;
		«IMPORTS_MARKER»

		import de.wwu.pi.acse.framework.web.Util;

		@ManagedBean
		public class «clazz.createViewClassName» {

			«clazz.generateEjbDefinition(this, clazz.ejbServiceName)»

			private «importedType(clazz)» «entityName» = new «clazz.javaType»();

			private String errorMessage;

			public «clazz.name» get«clazz.javaType»() {
				return «entityName»;
			}

			«generateServiceBeanAndGetAllForReferencedClasses(clazz)»

			public String persist() {
				// Action
				try {
					«entityName» = «clazz.ejbServiceName».create(«entityName»);
				} catch (EJBException e) {
					errorMessage = "«clazz.javaType» not created: "
							+ Util.getCausingMessage(e);
				}

				// Navigation
				if (isError())
					return null;
				else {
					return "/«entityName»/details.xhtml?faces-redirect=true&id="
							+ «entityName».getId();
				}
			}

			public boolean isError() {
				return errorMessage != null;
			}

			public String getErrorMessage() {
				return errorMessage != null ? errorMessage : "";
			}
		}
	'''
	}
}
