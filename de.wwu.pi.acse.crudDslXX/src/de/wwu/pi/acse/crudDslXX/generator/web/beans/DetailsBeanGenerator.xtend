package de.wwu.pi.acse.crudDslXX.generator.web.beans

import static extension de.wwu.pi.acse.crudDslXX.util.ModelUtil.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.ClassHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.GUIHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.PackageHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.entity.EntityClass.*
import de.wwu.pi.acse.crudDslXX.generator.util.GeneratorWithImports
import de.wwu.pi.acse.crudDslXX.crudDslXX.EntryPage
import de.wwu.pi.acse.crudDslXX.crudDslXX.CompositeRef

class DetailsBeanGenerator extends GeneratorWithImports<EntryPage> {
	override doGenerate(EntryPage page) {
	var entityType = page.entity.entityClassName
	var entityName = entityType.toFirstLower
	var serviceName = page.entity.ejbServiceName
	'''
		package «page.entity.guiPackageString»;

		import java.util.Collection;

		import javax.ejb.EJB;
		import javax.ejb.EJBException;
		import javax.faces.bean.ManagedBean;
		import javax.faces.bean.ViewScoped;

		«IMPORTS_MARKER»
		import de.wwu.pi.acse.framework.web.Util;

		@ManagedBean
		@ViewScoped
		public class «page.detailsBeanClassName» {

			«page.entity.generateEjbDefinition(this, serviceName)
			»
			« val compositeReferences = page.entity.properties.filter(typeof(CompositeRef)) »
			«IF compositeReferences.size > 0»
				//Service for referenced classes of composite elements
				«generateServiceBeanAndGetAllForReferencedClasses(compositeReferences.map[type].toSet,#[page.entity])»
			«ENDIF»

			private long id;
			private «entityType» «entityName»;
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
					if (get«entityType»() != null)
						// Success
						return;
				} catch (EJBException e) {
					e.printStackTrace();
				}
				Util.redirectToRoot();
			}

			public «importedType(page.entity)» get«entityType»() {
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

			public String persist() {
				«entityName» = «serviceName».updateMasterData(«entityName»);
				return toPage();
			}

			private String toPage() {
				return "«page.entity.urlToDetailsPage»?faces-redirect=true&id=" + id;
			}

			public String remove() {
				«serviceName».remove(id);
				return "«page.entity.urlToListPage»";
			}

			«FOR compositeRef : compositeReferences»
				«val appendix = 'ForNew' + compositeRef.name.toFirstUpper»
				public String addTo«compositeRef.name.toFirstUpper»() {
					resetError();
					try  {
						«serviceName».«compositeRef.adderMethodName»(id« compositeRef.type.properties.filter[singleValued].join(', ',', ', null, [it.name + appendix]) »);
					} catch (EJBException e) {
						errorMessage = "«compositeRef.readableName» could not be added: " +
							Util.getCausingMessage(e);
					}

					if (isError()) return null;
					else return toPage();
				}

				public String «compositeRef.removeMethodName»(«importedType(compositeRef.type)» «compositeRef.type.name.toFirstLower») {
					«serviceName».«compositeRef.removeMethodName»(«compositeRef.type.name.toFirstLower»);
					return toPage();
				}

				«FOR singleProp : compositeRef.type.properties.filter[singleValued]»
					«singleProp.generateDeclaration(appendix)»
					«singleProp.generateGetter(appendix)»
					«singleProp.generateSetter(appendix)»
				«ENDFOR»
			«ENDFOR»
		}
	'''
	}
}
