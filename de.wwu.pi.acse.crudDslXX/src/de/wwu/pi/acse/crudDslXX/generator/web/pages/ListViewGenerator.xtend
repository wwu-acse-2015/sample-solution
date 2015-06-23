package de.wwu.pi.acse.crudDslXX.generator.web.pages

import static extension de.wwu.pi.acse.crudDslXX.util.ModelUtil.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.ClassHelper.*
import static extension de.wwu.pi.acse.crudDslXX.generator.util.GUIHelper.*
import de.wwu.pi.acse.crudDslXX.crudDslXX.ListPage
import de.wwu.pi.acse.crudDslXX.crudDslXX.Property

class ListViewGenerator extends AbstractViewGenerator<ListPage> {
	override generateBody(ListPage page) '''
		<ui:composition template="/resources/master.xhtml">
			<ui:define name="title">«page.actualTitle» List</ui:define>
			<ui:define name="content">
				<h2>«page.actualTitle» List</h2>
				<h:dataTable value="#{«page.listViewClassName.toFirstLower».all}" var="cur"
					styleClass="data-table" headerClass="data-cell header-cell"
					columnClasses="«generateColumnClasses(page)»"
					rendered="#{not empty «page.listViewClassName.toFirstLower».all}">
					«FOR property : page.columnList.properties»
						<h:column>
							<f:facet name="header">«property.readableName»</f:facet>
							<h:outputText value="#{cur.«property.name»}">
								«converter(property)»
							</h:outputText>
						</h:column>
					«ENDFOR»
					<h:column>
						«generateLink(page.entity, "#{cur.id}")»
					</h:column>
				</h:dataTable>
				<h:form>
					<h:commandButton value="Create new «page.entity.readableName»" action="create?faces-redirect=true" />
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
	
	def generateColumnClasses(ListPage clazz) {
		clazz.columnList.properties.map["data-cell"] .join(",").concat(",data-cell");
	}
}
