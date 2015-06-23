package de.wwu.pi.acse.crudDslXX.generator.web.beans

import static extension de.wwu.pi.acse.crudDslXX.util.ModelUtil.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.ClassHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.GUIHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.PackageHelper.*
import de.wwu.pi.acse.crudDslXX.generator.util.GeneratorWithImports
import de.wwu.pi.acse.crudDslXX.crudDslXX.EntryPage

class CreateBeanGenerator extends GeneratorWithImports<EntryPage> {
	override doGenerate(EntryPage page) {
	val entityName = page.entity.entityClassName.toFirstLower
	val entity = page.entity
	'''
		package «page.entity.guiPackageString»;

		import java.util.Collection;

		import javax.ejb.EJB;
		import javax.ejb.EJBException;
		import javax.faces.bean.ManagedBean;
		«IMPORTS_MARKER»

		import de.wwu.pi.acse.framework.web.Util;

		@ManagedBean
		public class «page.createBeanClassName» {

			«entity.generateEjbDefinition(this, entity.ejbServiceName)»

			private «importedType(entity)» «entityName» = new «entity.entityClassName»();

			private String errorMessage;

			public «entity.entityClassName» get«entity.entityClassName»() {
				return «entityName»;
			}

			«generateServiceBeanAndGetAllForReferencedClasses(page)»

			public String persist() {
				// Action
				try {
					«entityName» = «entity.ejbServiceName».create(«entityName»);
				} catch (EJBException e) {
					errorMessage = "«page.entity.readableName» not created: "
							+ Util.getCausingMessage(e);
				}

				// Navigation
				if (isError())
					return null;
				else {
					return "«page.entity.urlToDetailsPage»?faces-redirect=true&id="
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
