package de.wwu.pi.acse.crudDslXX.generator.web.pages

import de.wwu.pi.acse.crudDslXX.crudDslXX.AbstractReference
import de.wwu.pi.acse.crudDslXX.crudDslXX.Attribute
import de.wwu.pi.acse.crudDslXX.crudDslXX.Button
import de.wwu.pi.acse.crudDslXX.crudDslXX.ButtonKind
import de.wwu.pi.acse.crudDslXX.crudDslXX.EntityList
import de.wwu.pi.acse.crudDslXX.crudDslXX.EntryPage
import de.wwu.pi.acse.crudDslXX.crudDslXX.ErrorMessage
import de.wwu.pi.acse.crudDslXX.crudDslXX.Field
import de.wwu.pi.acse.crudDslXX.crudDslXX.Label
import de.wwu.pi.acse.crudDslXX.crudDslXX.Panel

import static de.wwu.pi.acse.crudDslXX.generator.util.GUIHelper.*

import static extension de.wwu.pi.acse.crudDslXX.generator.util.ClassHelper.*
import static extension de.wwu.pi.acse.crudDslXX.util.ModelUtil.*

class CreateViewGenerator extends AbstractViewGenerator<EntryPage> {
	def beanName(EntryPage page) '''«page.createBeanClassName.toFirstLower»'''
	def entityName(EntryPage page) '''«page.entity.entityClassName.toFirstLower»'''
	
	override generateBody(EntryPage page) '''
		<ui:composition template="/resources/master.xhtml">
			<ui:define name="title">Create «page.actualTitle»</ui:define>
			<ui:define name="content">
				<div class="inputForm">
					<h:form>
						<h2>«page.actualTitle»</h2>
							«FOR uielem: page.elements »
								<div>
								«uielem.generateUIElement»
								</div>
							«ENDFOR»
					</h:form>
				</div>
				<div class="result">
					<h:outputText rendered="#{«page.beanName».error}"
						styleClass="error"
						value="#{«page.beanName».errorMessage}" />
				</div>
			</ui:define>
		</ui:composition>
	'''
	
	def dispatch CharSequence generateUIElement(Label label) {
		if (label.field == null)
			'''<h:outputText style="form-label" value="«label.actualText»"></h:outputText>'''
		else
			'''<h:outputLabel value="«label.actualText»" for="«label.field.name»" />'''
	}
	
	def dispatch CharSequence generateUIElement(Field field) {
		val tag_id = field.name
		val entityName = field.referingPage.entityName 
		val beanName = field.referingPage.beanName
		val idValue = '''#{«beanName».«entityName».«field.property.name»}'''
		
		val property = field.property
		switch (property) {
			Attribute: inputForAttribute(property, idValue, tag_id)
			AbstractReference: generateSingleReference(property, field, idValue, tag_id, beanName)
		}
	}
	
	def dispatch CharSequence generateUIElement(ErrorMessage err_msg) {
		val referingField = err_msg.field
		'''
			<h:message styleClass="error" for="«referingField.name»" />
		'''
	}
	
	def dispatch CharSequence generateUIElement(EntityList list) '''
		<h:outputText value="No referenced «list.referingEntity.readableName»"></h:outputText>
	'''
	
	def dispatch CharSequence generateUIElement(Button button) {
		// Do not print delete buttons on create page
		if (button.kind == ButtonKind.DELETE)
			return ''''''

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
	
	def dispatch CharSequence generateUIElement(Panel panel) '''
		<h:panelGrid columns="«panel.column_number»"
«««			columnClasses="form-label,form-input,form-message error"
			footerClass="form-footer">
			«FOR uiElem : panel.pageElem»
				«uiElem.generateUIElement»
			«ENDFOR»
		</h:panelGrid>
	'''
	
	def generateSingleReference(AbstractReference ref, Field field, CharSequence idValue, CharSequence tag_id, CharSequence beanName) {
		htmlEntitySelect(idValue, tag_id, ref, beanName)
	}
}

