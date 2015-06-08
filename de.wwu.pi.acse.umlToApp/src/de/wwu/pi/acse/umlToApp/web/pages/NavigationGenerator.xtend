package de.wwu.pi.acse.umlToApp.web.pages

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Model

import static extension de.wwu.pi.acse.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.GUIHelper.*
import static extension de.wwu.pi.acse.umlToApp.util.ModelAndPackageHelper.*

class NavigationGenerator {
	def generate(Model model) '''
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml"
		  xmlns:h="http://java.sun.com/jsf/html"
		  xmlns:f="http://java.sun.com/jsf/core"
		  xmlns:c="http://java.sun.com/jsp/jstl/core"
		  xmlns:ui="http://java.sun.com/jsf/facelets">
		<body>
			«model.generateListLinks»
		</body>
		</html>
	'''

	def generateListLinks(Model model) {
		model.allEntities.filter[!isCompositeEntity].map[generateListLink].join(" | ")
	}
		
	def generateListLink(Class clazz) '''
		<h:link outcome="/«clazz.javaType.toFirstLower»/list.xhtml">«clazz.readableLabel»</h:link>
	'''
	
}
