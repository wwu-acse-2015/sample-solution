package de.wwu.pi.acse.umlToApp.web.pages

import org.eclipse.uml2.uml.Class

import static extension de.wwu.pi.acse.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.GUIHelper.*

class CreateViewGenerator extends AbstractViewGenerator {
	override generateBody(Class clazz) '''
		<ui:composition template="/resources/master.xhtml">
			<ui:define name="title">Create «clazz.readableLabel»</ui:define>
			<ui:define name="content">
				<div class="inputForm">
					<h:form>
						<h:panelGrid columns="3"
							columnClasses="form-label,form-input,form-message error"
							footerClass="form-footer">
							«FOR property : clazz.singleValueProperties»
								«generateElementsFor(clazz, property)»
							«ENDFOR»
							<f:facet name="footer">
								<h:commandButton value="Submit" action="#{«clazz.createBeanClassName.toFirstLower».persist}" />
							</f:facet>
						</h:panelGrid>
					</h:form>
				</div>
				<div class="result">
					<h:outputText rendered="#{«clazz.createBeanClassName.toFirstLower».error}"
						styleClass="error"
						value="#{«clazz.createBeanClassName.toFirstLower».errorMessage}" />
				</div>
			</ui:define>
		</ui:composition>
	'''
}