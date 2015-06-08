package de.wwu.pi.acse.umlToApp.web.pages

import org.eclipse.uml2.uml.Class

abstract class AbstractViewGenerator {
	def generate(Class clazz) '''
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml"
			xmlns:h="http://java.sun.com/jsf/html"
			xmlns:f="http://java.sun.com/jsf/core"
			xmlns:p="http://xmlns.jcp.org/jsf/passthrough"
			xmlns:ui="http://java.sun.com/jsf/facelets">
		«clazz.generateBody»
		</html>
	'''
	
	def CharSequence generateBody(Class clazz)
}