package de.wwu.pi.acse.umlToApp.web.pages

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Property

import static extension de.wwu.pi.acse.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.GUIHelper.*

class ListViewGenerator extends AbstractViewGenerator {
	override generateBody(Class clazz) '''
		<ui:composition template="/resources/master.xhtml">
			<ui:define name="title">«clazz.readableLabel» List</ui:define>
			<ui:define name="content">
				<h2>«clazz.readableLabel» List</h2>
				<h:dataTable value="#{«clazz.listViewClassName.toFirstLower».all}" var="cur"
					styleClass="data-table" headerClass="data-cell header-cell"
					columnClasses="«generateColumnClasses(clazz)»"
					rendered="#{not empty «clazz.listViewClassName.toFirstLower».all}">
					«FOR property : clazz.singleValueProperties»
						<h:column>
							<f:facet name="header">«property.readableLabel»</f:facet>
							<h:outputText value="#{cur.«property.name»}">
								«converter(property)»
							</h:outputText>
						</h:column>
					«ENDFOR»
					<h:column>
						«generateLink(clazz, "#{cur.id}")»
					</h:column>
				</h:dataTable>
				<h:form>
					<h:commandButton value="Create new «clazz.readableLabel»" action="create?faces-redirect=true" />
				</h:form>
			</ui:define>
		</ui:composition>
	'''
	
	def converter(Property property) {
		if (property.isDate) {
			'''
				<f:convertDateTime pattern="yyyy-MM-dd HH:mm" timeZone="Europe/Berlin"/>
			'''
		}
	}
	
	def generateColumnClasses(Class clazz) {
		clazz.singleValueProperties.map["data-cell"] .join(",").concat(",data-cell");
	}
}
