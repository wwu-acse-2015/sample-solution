package de.wwu.pi.acse.crudDslXX.generator.web.beans

import de.wwu.pi.acse.crudDslXX.crudDslXX.ListPage
import de.wwu.pi.acse.crudDslXX.generator.util.GeneratorWithImports

import static extension de.wwu.pi.acse.crudDslXX.generator.util.ClassHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.GUIHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.PackageHelper.*

class ListBeanGenerator extends GeneratorWithImports<ListPage> {
	override doGenerate(ListPage page) '''
		package «page.entity.guiPackageString»;
		
		import java.util.Collection;
		
		import javax.ejb.EJB;
		import javax.faces.bean.ManagedBean;
		«IMPORTS_MARKER»
		
		@ManagedBean
		public class «page.listViewClassName» {
		
			«page.entity.generateEjbDefinition(this)»
		
			public Collection<«importedType(page.entity)»> getAll() {
				return «page.entity.ejbServiceName».getAll();
			}
		}
	'''
}
