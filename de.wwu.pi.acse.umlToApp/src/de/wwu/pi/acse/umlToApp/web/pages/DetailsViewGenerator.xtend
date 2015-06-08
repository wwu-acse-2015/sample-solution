package de.wwu.pi.acse.umlToApp.web.pages

import org.eclipse.uml2.uml.AggregationKind
import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Property

import static extension de.wwu.pi.acse.umlToApp.data.EntityClass.*
import static extension de.wwu.pi.acse.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.GUIHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.ModelAndPackageHelper.*

class DetailsViewGenerator extends AbstractViewGenerator {
	override generateBody(Class clazz) {
		val beanName = clazz.detailsBeanClassName.toFirstLower
		val entityName = clazz.javaType.toFirstLower
		'''
			<ui:composition template="/resources/master.xhtml">
				<ui:define name="metadata">
					<f:metadata>
						<f:viewParam name="id" value="#{«beanName».id}"></f:viewParam>
						<f:event listener="#{«beanName».ensureInitialized}" type="preRenderView"></f:event>
					</f:metadata>
				</ui:define>
				<ui:define name="title">«clazz.readableLabel» Details</ui:define>
				<ui:define name="content">
					<div class="details">
						<h2>«clazz.readableLabel» ##{«beanName».«entityName».id}</h2>
						<h:form>
							<h:panelGrid columns="3" columnClasses="form-label,form-input,form-message error"
								footerClass="form-footer">
								«FOR property : clazz.singleValueProperties»
									«val jsfPropertyExpression = beanName + "." + entityName +"." + property.name»
									«IF property.type.isEntity»
										<h:outputLabel value="«property.readableLabel»" for="«property.name»" />
										<h:panelGroup rendered="#{«jsfPropertyExpression» != null}">
											«property.opposite.class_.generateLink('''#{«jsfPropertyExpression».id}''', '''#{«jsfPropertyExpression»}''', property.name)»
										</h:panelGroup>
										<h:panelGroup rendered="#{«jsfPropertyExpression» == null}">
											No «property.readableLabel» associated
										</h:panelGroup>
										<h:message for="«property.name»" />
									«ELSE»
										«generateElementsFor(clazz, property, beanName)»
									«ENDIF»
								«ENDFOR»
								<f:facet name="footer">
									<h:commandButton value="Submit changes" action="#{«beanName».submitMasterDataChanges}" />
									<h:commandButton value="Remove «clazz.readableLabel»" action="#{«beanName».remove}" />
								</f:facet>
							</h:panelGrid>
							«FOR multiRef : clazz.multiReferences»
								«val isComposite = multiRef.aggregation == AggregationKind.COMPOSITE_LITERAL»
								<h3>«multiRef.readableLabel»</h3>
								<h:dataTable value="#{«beanName».«entityName».«multiRef.name»}" var="cur"
									styleClass="data-table" headerClass="data-cell header-cell"
									columnClasses="data-cell,data-cell,data-cell">
								«IF isComposite»
								<!-- columns for properties of the referenced entity -->
									«FOR multiRefProperty : (multiRef.type as Class).singleValueProperties.filter[it.type != clazz]»
										<h:column>
											«multiRefProperty.generateHeaderAndDisplayValue»
											«val suffix = "ForNew" + multiRef.name.toFirstUpper»
											<f:facet name="footer">
												«val elementId = multiRefProperty.name+suffix»
												«multiRefProperty.generateInputElementFor('''#{«beanName».«multiRefProperty.name»«suffix»}''', beanName, elementId)»
											</f:facet>
										</h:column>
									«ENDFOR»
									<h:column>
										<h:commandButton value="Remove" action="#{«beanName».removeFrom«multiRef.name.toFirstUpper»(cur)}" />
										<f:facet name="footer">
											<h:commandButton value="Add" action="#{«beanName».addTo«multiRef.name.toFirstUpper»()}" />
										</f:facet>
									</h:column>
								«ELSE»
								<!-- columns for properties of the referenced entity -->
									«FOR multiRefProperty : (multiRef.type as Class).singleValueProperties.filter[it.type != clazz]»
										<h:column>
											«multiRefProperty.generateHeaderAndDisplayValue»
										</h:column>
									«ENDFOR»
									<h:column>
										«IF multiRef.opposite.class_.isCompositeEntity»
											<!-- link to owning class, since composite classes have no details view -->
											«val owningReference = multiRef.opposite.class_.owningReferenceForComposite»
											«owningReference.opposite.class_.generateLink('''#{cur.«owningReference.name».id}''')»
										«ELSE»
											«multiRef.opposite.class_.generateLink("#{cur.id}")»
										«ENDIF»
									</h:column>
								«ENDIF»
								</h:dataTable>
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
	
	def generateHeaderAndDisplayValue(Property p) '''
		<f:facet name="header">«p.readableLabel»</f:facet>
		«p.generateDisplayValue»
	'''

	def generateDisplayValue(Property p) {
		if (p.type.isEntity) '''
				<h:panelGroup rendered="#{cur.«p.name» != null}">
					«(p.type as Class).generateLink('''#{cur.«p.name».id}''', '''#{cur.«p.name»}''')»
				</h:panelGroup>
			'''
		else
			'''
				<h:outputText value="#{cur.«p.name»}">
					«p.converter»
				</h:outputText>
			'''
	}
}