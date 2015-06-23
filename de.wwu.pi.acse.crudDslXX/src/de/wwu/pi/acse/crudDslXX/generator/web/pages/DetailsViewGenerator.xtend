package de.wwu.pi.acse.crudDslXX.generator.web.pages

import de.wwu.pi.acse.crudDslXX.crudDslXX.AbstractReference
import de.wwu.pi.acse.crudDslXX.crudDslXX.Attribute
import de.wwu.pi.acse.crudDslXX.crudDslXX.Button
import de.wwu.pi.acse.crudDslXX.crudDslXX.ButtonKind
import de.wwu.pi.acse.crudDslXX.crudDslXX.ColumnList
import de.wwu.pi.acse.crudDslXX.crudDslXX.EntityList
import de.wwu.pi.acse.crudDslXX.crudDslXX.EntryPage
import de.wwu.pi.acse.crudDslXX.crudDslXX.Field
import de.wwu.pi.acse.crudDslXX.crudDslXX.Property
import de.wwu.pi.acse.crudDslXX.crudDslXX.Reference

import static extension de.wwu.pi.acse.crudDslXX.generator.entity.EntityClass.oppositeNameInJava
import static extension de.wwu.pi.acse.crudDslXX.generator.util.ClassHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.GUIHelper.*
import static extension de.wwu.pi.acse.crudDslXX.util.ModelUtil.*

class DetailsViewGenerator  extends CreateViewGenerator {

	override beanName(EntryPage page) '''«page.detailsBeanClassName.toFirstLower»'''
	override entityName(EntryPage page) '''«page.entity.entityClassName.toFirstLower»'''
	
	override generateBody(EntryPage page) {
		
		val beanName = page.beanName
		val entityName = page.entityName
		'''
			<ui:composition template="/resources/master.xhtml">
				<ui:define name="metadata">
					<f:metadata>
						<f:viewParam name="id" value="#{«beanName».id}"></f:viewParam>
						<f:event listener="#{«beanName».ensureInitialized}" type="preRenderView"></f:event>
					</f:metadata>
				</ui:define>
				<ui:define name="title">«page.actualTitle»</ui:define>
				<ui:define name="content">
					<div class="details">
						<h2>«page.actualTitle» ##{«beanName».«entityName».id}</h2>
						<h:form>
							«FOR uielem: page.elements »
								«uielem.generateUIElement»
							«ENDFOR»
						</h:form>
					</div>
					<div class="result">
						<h:outputText rendered="#{«beanName».error}"
							styleClass="error"
							value="#{«beanName».errorMessage}" />
					</div>
				</ui:define>
			</ui:composition>
		'''
	}
	
	override dispatch CharSequence generateUIElement(Button button) {
		val label = button.actualText
		val beanName = button.referingPage.beanName
		val action = switch (button.kind) {
			case ButtonKind.DELETE: '''#{«beanName».remove}'''
			case ButtonKind.CREATE_EDIT: '''#{«beanName».persist}'''
			default: ''''''
		}
		if(action.isEmpty)
			return ''''''
		htmlButton(label,action)
	}
	
	override dispatch generateUIElement(EntityList entityList) {
		val isComposite = entityList.referingEntity.isComposite
		val beanName = entityList.referingPage.beanName
		val entityName = entityList.referingPage.entityName 
		'''
			<h:dataTable value="#{«beanName».«entityName».«entityList.reference.nameInJava»}" var="cur"
			styleClass="data-table" headerClass="data-cell header-cell"
			columnClasses="«entityList.columnList.generateColumnClasses»">
			<!-- columns for properties of the referenced entity -->
				«FOR multiRefProperty : entityList.columnList.properties»
						«multiRefProperty.generateContentColumn(entityList)»
				«ENDFOR»
			
«««			generate last column of list
			«IF isComposite»
«««				Add and Remove Button
				« val ref = entityList.reference»
					<h:column>
						<h:commandButton value="Remove" action="#{«beanName».removeFrom«ref.nameInJava.toFirstUpper»(cur)}" />
						<f:facet name="footer">
							<h:commandButton value="Add" action="#{«beanName».addTo«ref.nameInJava.toFirstUpper»()}" />
						</f:facet>
					</h:column>
			«ELSE»
«««				Link to details page
				« val ref = (entityList.reference as Reference)»
					<h:column>
						«IF ref.opposite.entity.isComposite»
							<!-- link to owning class, since composite classes have no details view -->
							«val owningRef = ref.opposite.entity.owningReference»
							«owningRef.entity.generateLink('''#{cur.«owningRef.oppositeNameInJava».id}''')»
						«ELSE»
							«ref.opposite.entity.generateLink("#{cur.id}")»
						«ENDIF»
					</h:column>
			«ENDIF»
			</h:dataTable>
		'''
	}
	
	def generateContentColumn(Property p, EntityList entityList) {
		val footerContent = entityList.generateColumnFooter(p)
		'''
			<h:column>
				<f:facet name="header">«p.readableName»</f:facet>
				«p.generateDisplayValue»
				«IF(footerContent != null && footerContent.length > 0)»
					<f:facet name="footer">
					«footerContent»
					</f:facet>
				«ENDIF»
			</h:column>
		'''
	}
	
	def dispatch generateDisplayValue(AbstractReference p) '''
				<h:panelGroup rendered="#{cur.«p.nameInJava» != null}">
					«p.type.generateLink('''#{cur.«p.nameInJava».id}''', '''#{cur.«p.nameInJava»}''')»
				</h:panelGroup>
			'''

	def dispatch generateDisplayValue(Property p) {
			'''
				<h:outputText value="#{cur.«p.nameInJava»}">
					«p.converter»
				</h:outputText>
			'''
	}
	
	def converter(Property property) {
		if (property.isDate)
			'''<f:convertDateTime pattern="yyyy-MM-dd HH:mm" timeZone="Europe/Berlin"/>'''
	}
	def generateColumnFooter(EntityList list, Property p) {
		if(list.referingEntity.isComposite) {
			//If it is an EntityList for Composite elements add input fields
			val beanName = list.referingPage.beanName
			val suffix = "ForNew" + list.reference.nameInJava.toFirstUpper
			val idValue = '''#{«beanName».«p.nameInJava»«suffix»}'''
			val tagId = p.nameInJava+suffix
			
			switch (p)	
			{
				Attribute: inputForAttribute(p,idValue,tagId)
				AbstractReference: htmlEntitySelect(idValue, tagId, p, beanName)
			}
		} else {
			// in usual cases do not create footer elements
			''''''
		}
	}
		
	def generateColumnClasses(ColumnList list) {
		list.properties.map["data-cell"] .join(",").concat(",data-cell");
	}
	
	// override way of generating single reference --> no select field (drop down) but link
	override generateSingleReference(AbstractReference singleRef, Field field, CharSequence idValue, CharSequence tag_id, CharSequence beanName) {
		val ref = (field.property as Reference)
		val jsfPropertyExpression = beanName + "." + field.referingPage.entityName + "." + field.property.nameInJava
		'''
			<h:panelGroup rendered="#{«jsfPropertyExpression» != null}">
				«ref.type.generateLink('''#{«jsfPropertyExpression».id}''', '''#{«jsfPropertyExpression»}''', ref.nameInJava)»
			</h:panelGroup>
			<h:panelGroup rendered="#{«jsfPropertyExpression» == null}">
				No «ref.type.readableName» associated
			</h:panelGroup>
		'''
	}
}