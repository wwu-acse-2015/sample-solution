package de.wwu.pi.acse.crudDslXX.generator.util

import static extension de.wwu.pi.acse.crudDslXX.util.ModelUtil.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.ClassHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.PackageHelper.*
import java.util.Collection
import de.wwu.pi.acse.crudDslXX.crudDslXX.Entity
import de.wwu.pi.acse.crudDslXX.crudDslXX.AttributeType
import de.wwu.pi.acse.crudDslXX.crudDslXX.Attribute
import de.wwu.pi.acse.crudDslXX.crudDslXX.AbstractReference
import de.wwu.pi.acse.crudDslXX.crudDslXX.Page
import de.wwu.pi.acse.crudDslXX.crudDslXX.ListPage
import de.wwu.pi.acse.crudDslXX.crudDslXX.EntryPage

class GUIHelper {

//  -------------  WebBeanHelperHelper

	def static generateEjbDefinition(Entity entity, GeneratorWithImports<? extends Page> generator)
		'''«entity.generateEjbDefinition(generator, entity.ejbServiceName)»'''

	def static generateEjbDefinition(Entity entity, GeneratorWithImports<? extends Page> generator, CharSequence ejbName) {
		'''
			@EJB« /* pay attention to the imported declaration */»
			private «generator.imported(entity.logicPackageString + '.' + entity.serviceClassName)» «ejbName»;
		'''
	}

	def static ejbServiceName(Entity entity)
		'''«entity.name.toFirstLower»Service'''

	def static generateServiceBeanAndGetAllForReferencedClasses(GeneratorWithImports<? extends Page> generator, Page page) {
		generateServiceBeanAndGetAllForReferencedClasses(generator, #[page.entity], #[])
	}

	def static generateServiceBeanAndGetAllForReferencedClasses(GeneratorWithImports<? extends Page> generator, Collection<Entity> entities, Collection<Entity> excludeEntities) {
		'''
		«FOR referencedEntity : entities.map[it.singleReferences.map[type]].flatten.toSet.filter[ !excludeEntities.contains(it)]»
			«referencedEntity.generateEjbDefinition(generator)»

			public Collection<«generator.importedType(referencedEntity)»> getAllOfType«referencedEntity.entityClassName»() {
				return «referencedEntity.ejbServiceName».getAll();
			}
		«ENDFOR»
		'''
	}

//  -------------  WebHelper

	public static val webpageExtension = 'xhtml'
	
	def static listWebpageName(ListPage page) {
		page.name
	}
	
	def static detailsWebpageName(EntryPage page) {
		page.name
	}
	
	def static createWebpageName(EntryPage page) {
		page.name + 'create'
	}
	
	def static urlPath(Entity entity) {
		entity.entityClassName.toFirstLower
	}

	def static urlToListPage(Entity entity) {
		'''/«entity.urlPath»/«entity.listPage.listWebpageName».«webpageExtension»'''
	}

	def static urlToCreatePage(Entity entity) {
		'''/«entity.urlPath»/«entity.entryPage.createWebpageName».«webpageExtension»'''
	}

	def static urlToDetailsPage(Entity entity) {
		'''/«entity.urlPath»/«entity.entryPage.detailsWebpageName».«webpageExtension»'''
	}

	def static inputForAttribute(Attribute att, CharSequence idValue, CharSequence tagId) {
		switch (att.type) {
			case AttributeType.DATE: htmlDateInput(idValue, tagId)
			default: htmlTextInput(idValue, tagId)
		}
	}

	def static htmlEntitySelect(CharSequence idValue, CharSequence tagId, AbstractReference ref, CharSequence beanName)
	'''
		<h:selectOneMenu id="«tagId»" value="«idValue»" converter="#{«ref.type.converterClassName.toFirstLower»}">
			«IF !ref.required»
				<f:selectItem itemLabel="Select nothing" itemValue="#{null}"/>
			«ENDIF»
				<f:selectItems value="#{«beanName».allOfType«ref.type.entityClassName»}" />
		</h:selectOneMenu>
	'''

	def static htmlTextInput(CharSequence idValue, CharSequence tagId) '''
		<h:inputText id="«tagId»" value="«idValue»" />
	'''

	def static htmlDateInput(CharSequence idValue, CharSequence tagId) '''
		<h:inputText id="«tagId»" value="«idValue»" p:placeholder="e.g. 2015-06-30 13:30">
			<f:convertDateTime pattern="yyyy-MM-dd HH:mm" timeZone="Europe/Berlin"/>
		</h:inputText>
	'''

	def static htmlButton(CharSequence label, CharSequence actionValue) '''
		<h:commandButton value="«label»" action="«actionValue»" />
	'''

	def static generateLink(Entity entity, CharSequence idValue) {
		entity.generateLink(idValue, "Details")
	}

	def static generateLink(Entity entity, CharSequence idValue, CharSequence displayValue) {
		entity.generateLink(idValue, displayValue, null)
	}

	def static generateLink(Entity entity, CharSequence idValue, CharSequence displayValue, CharSequence linkId) '''
		<h:link«if(linkId!=null) {' id="' + linkId +'"'}» outcome="«entity.urlToDetailsPage»">
			<f:param name="id" value="«idValue»"></f:param>
			«displayValue»
		</h:link>
	'''
}
