package de.wwu.pi.acse.crudDslXX.util

import de.wwu.pi.acse.crudDslXX.crudDslXX.AbstractReference
import de.wwu.pi.acse.crudDslXX.crudDslXX.Attribute
import de.wwu.pi.acse.crudDslXX.crudDslXX.AttributeType
import de.wwu.pi.acse.crudDslXX.crudDslXX.Button
import de.wwu.pi.acse.crudDslXX.crudDslXX.ColumnList
import de.wwu.pi.acse.crudDslXX.crudDslXX.CompositeRef
import de.wwu.pi.acse.crudDslXX.crudDslXX.CrudModel
import de.wwu.pi.acse.crudDslXX.crudDslXX.Entity
import de.wwu.pi.acse.crudDslXX.crudDslXX.EntityList
import de.wwu.pi.acse.crudDslXX.crudDslXX.EntryPage
import de.wwu.pi.acse.crudDslXX.crudDslXX.Field
import de.wwu.pi.acse.crudDslXX.crudDslXX.Label
import de.wwu.pi.acse.crudDslXX.crudDslXX.ListPage
import de.wwu.pi.acse.crudDslXX.crudDslXX.MultiplicityKind
import de.wwu.pi.acse.crudDslXX.crudDslXX.Page
import de.wwu.pi.acse.crudDslXX.crudDslXX.PageElement
import de.wwu.pi.acse.crudDslXX.crudDslXX.Panel
import de.wwu.pi.acse.crudDslXX.crudDslXX.Property
import de.wwu.pi.acse.crudDslXX.crudDslXX.Reference
import java.util.List
import org.eclipse.emf.ecore.EObject

class ModelUtil {

	def static listPages(CrudModel model) {
		model.pages.filter(typeof(ListPage))
	}

	def static entryPages(CrudModel model) {
		model.pages.filter(typeof(EntryPage))
	}

	def static CrudModel getModelElement(EObject obj) {
		if(obj instanceof CrudModel)
			return obj as CrudModel;
		getModelElement(obj.eContainer)
	}

	//==========================================================================================
	// Extensions for Entity Part
	//==========================================================================================

	def static allEntities(CrudModel model) {
		model.eAllContents.filter(typeof(Entity))
	}

	def static Iterable<Property> getProperties(Entity e) {
		e.properties.toSet
	}

	def static requiredProperties(Entity entity) {
		entity.getProperties.filter[it.required]
	}

	def static attributes(Entity entity) {
		entity.getProperties.filter(typeof(Attribute))
	}

	def static references(Entity entity) {
		entity.getProperties.filter(typeof(Reference))
	}

	def static composites(Entity entity) {
		entity.getProperties.filter(typeof(CompositeRef))
	}
	
	def static multiReferences(Entity entity) {
		entity.properties.filter(typeof(AbstractReference)).filter[!singleValued]
	}
		
	def static singleReferences(Entity entity) {
		entity.properties.filter(typeof(AbstractReference)).filter[singleValued]
	}

	def static singleValueProperties(Entity entity) {
		entity.properties.filter[singleValued]
	}

	def static required(Property p) {
		switch(p) {
			Attribute: !p.optional
			Reference: p.multiplicity == MultiplicityKind.SINGLE
			CompositeRef: true
		}
	}

	def static isComposite(Entity entity) {
		entity.eContainer instanceof CompositeRef
	}
	
	def static owningReference(Entity entity) {
		if(!entity.composite)
			throw new Exception("entity is not a composite entity")
		entity.eContainer as CompositeRef
	}

	def static optional(Property p) {
		!p.required
	}

	def static getEntity(Property prop) {  //TODO rename to declaringEntity
		prop.eContainer as Entity
	}
	
	def static dispatch getType(Reference ref) {
		ref.type
	}
	def static dispatch getType(CompositeRef ref) {
		ref.type
	}

	def static multivalued(Reference r) {
		r.multiplicity == MultiplicityKind.MULTIPLE
	}

		def dispatch static isDate(Property p) {
		false
	}
	def dispatch static isDate(Attribute att) {
		att.type == AttributeType.DATE
	}

	def dispatch static isString(Property p) {
		false
	}
	def dispatch static isString(Attribute att) {
		att.type == AttributeType.STRING
	}

	def dispatch static isNumberObject(Property p) {
		false
	}
	def dispatch static isNumberObject(Attribute att) {
		att.type == AttributeType.INTEGER
	}

	def dispatch static isSingleValued(Attribute att) {
		true
	}
	def dispatch static isSingleValued(Reference ref) {
		ref.multiplicity == MultiplicityKind.SINGLE
	}
	def dispatch static isSingleValued(CompositeRef ref) {
		false
	}

	//==========================================================================================
	// Mappings between Entity Part and UI Part
	//==========================================================================================

	def static listPage(Entity entity) {
		entity.getModelElement.listPages.filter[it.entity == entity].head
	}
	
	def static entryPage(Entity entity) {
		entity.getModelElement.entryPages.filter[it.entity == entity].head
	}

	def static fieldForProperty(Property p, EntryPage page) {
		page.allFields.filter[property == p].head
	}

	//==========================================================================================
	// Extensions for UI Part
	//==========================================================================================

	def static Entity getEntityForColumns(ColumnList list) {
		var surroundingElem = list.eContainer
		switch surroundingElem {
			PageElement: surroundingElem.referingEntity
			// Page is supertype of EntryPage and ListPage
			Page: surroundingElem.entity
		}
	}

	def dispatch static Entity getReferingEntity(EntityList p) {
		p.reference.type
	}

	def dispatch static Entity getReferingEntity(PageElement p) {
		var surroundingElem = p.eContainer
		switch surroundingElem {
			Panel: surroundingElem.referingEntity
			Page: surroundingElem.entity
		}
	}
	
	def static EntryPage getReferingPage(PageElement uiElem)	{
		val suroundingElem = uiElem.eContainer
		switch (suroundingElem) {
			EntryPage: return suroundingElem
			PageElement: return suroundingElem.referingPage
		}
	}

	def static allUIElements(EntryPage page) {
		return page.elements.map[findSubElements].flatten
	}
	
	def static dispatch List<PageElement> findSubElements(PageElement elem) {
		#[elem]
	}
	
	def static dispatch List<PageElement> findSubElements(Panel panel) {
		(panel.pageElem.map[it.findSubElements].flatten + #[panel]).toList
	}

	def static allFields(EntryPage page) {
		page.allUIElements.filter(typeof(Field))
	}

	def static allFieldsToAttributes(EntryPage page) {
		page.allFields.filter[property instanceof Attribute]
	}

	def static allFieldsToReferences(EntryPage page) {
		page.allFields.filter[property instanceof Reference]
	}

	def static allFieldsToMultiReferences(EntryPage page) {
		page.allFieldsToReferences.filter[(property as Reference).multivalued]
	}

	// from http://stackoverflow.com/a/2560017
	private static val REGEX_FOR_CAPITAL =
		"(?<=[A-Z])(?=[A-Z][a-z])" + '|' +
    	"(?<=[^A-Z])(?=[A-Z])" + '|' +
    	"(?<=[A-Za-z])(?=[^A-Za-z])"

	def private static camelCaseToLabel(String camelCaseString) {
		camelCaseString.replaceAll(REGEX_FOR_CAPITAL, " ")
	}

	def static actualTitle(CrudModel model)	{
		(model.title ?: model.name.split("\\.").last).camelCaseToLabel
	}
	
	def static actualTitle(Page page) {
		page.title ?: (page.entity.name.camelCaseToLabel + page.titleSuffix)
	}

	def private static dispatch titleSuffix(ListPage page) {
		" List Page"
	}

	def private static dispatch titleSuffix(EntryPage page) {
		" Entry Form"
	}

	def static actualText(Label l) {
		l.text ?: l.name.camelCaseToLabel.toFirstUpper
	}

	def static actualText(Button b) {
		b.text ?: b.kind.literal.camelCaseToLabel.toFirstUpper
	}
	
	def static readableName(Entity e) {
		e.name.camelCaseToLabel.toFirstUpper
	}
	
	def static readableName(Property e) {
		e.name.camelCaseToLabel.toFirstUpper
	}
}