package de.wwu.pi.acse.umlToApp.web.beans

import de.wwu.pi.acse.umlToApp.util.GeneratorWithImports
import org.eclipse.uml2.uml.Class

import static extension de.wwu.pi.acse.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.ModelAndPackageHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.GUIHelper.*
import static extension de.wwu.pi.acse.umlToApp.data.EntityClass.*

class DetailsBeanGenerator extends GeneratorWithImports {
	override doGenerate(Class clazz) {
	var entityName = clazz.name.toFirstLower
	var serviceName = /* entityName + */ 'service'
	'''
		package «clazz.guiPackageString»;

		import java.util.Collection;

		import javax.ejb.EJB;
		import javax.ejb.EJBException;
		import javax.faces.bean.ManagedBean;
		import javax.faces.bean.ViewScoped;

		«IMPORTS_MARKER»
		import de.wwu.pi.acse.framework.web.Util;

		@ManagedBean
		@ViewScoped
		public class «clazz.detailsViewClassName» {

			«clazz.generateEjbDefinition(this, serviceName)
			»
			« val compositeReferences = clazz.multiReferences.filter[composite] »
			«IF compositeReferences.size > 0»
				//Service for referenced classes of composite elements
				«generateServiceBeanAndGetAllForReferencedClasses(compositeReferences.map[type as Class].toSet,#[clazz])»
			«ENDIF»

			private long id;
			private «clazz.javaType» «entityName»;
			private String errorMessage;

			public long getId() {
				return id;
			}

			public void setId(long id) {
				this.id = id;
				init();
			}

			public void init() {
				«entityName» = null;
			}

			public void ensureInitialized() {
				try {
					if (get«clazz.javaType»() != null)
						// Success
						return;
				} catch (EJBException e) {
					e.printStackTrace();
				}
				Util.redirectToRoot();
			}

			public «importedType(clazz)» get«clazz.javaType»() {
				if («entityName» == null) {
					«entityName» = «serviceName».getWithFetchedReferences(id);
				}
				return «entityName»;
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

			public String submitMasterDataChanges() {
				«entityName» = «serviceName».updateMasterData(«entityName»);
				return toPage();
			}

			private String toPage() {
				return "/«entityName»/details.xhtml?faces-redirect=true&id=" + id;
			}

			public String remove() {
				«serviceName».remove(id);
				return "/«entityName»/list.xhtml";
			}

			«FOR compositeRef : compositeReferences»
				«val appendix = 'ForNew' + compositeRef.name.toFirstUpper»
				public String addTo«compositeRef.name.toFirstUpper»() {
					resetError();
					try  {
						«serviceName».addTo«compositeRef.name.toFirstUpper»(id« (compositeRef.type as Class).singleValueProperties.filter[it.name != compositeRef.opposite.name].join(', ',', ', null, [it.name + appendix]) »);
					} catch (EJBException e) {
						errorMessage = "«compositeRef.readableLabel» could not be added: " +
							Util.getCausingMessage(e);
					}

					if (isError()) return null;
					else return toPage();
				}

				public String removeFrom«compositeRef.name.toFirstUpper»(«importedType(compositeRef.type)» «compositeRef.type.name.toFirstLower») {
					«serviceName».removeFrom«compositeRef.name.toFirstUpper»(«compositeRef.type.name.toFirstLower»);
					return toPage();
				}

				«FOR singleProp : (compositeRef.type as Class).singleValueProperties.filter[it.name != compositeRef.opposite.name]»
					«singleProp.generateDeclaration(appendix)»
					«singleProp.generateGetter(appendix)»
					«singleProp.generateSetter(appendix)»
				«ENDFOR»
			«ENDFOR»
		}
	'''
	}
}
