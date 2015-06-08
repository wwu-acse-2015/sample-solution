package de.wwu.pi.acse.umlToApp.web.pages

import org.eclipse.uml2.uml.Model

import static extension de.wwu.pi.acse.umlToApp.util.GUIHelper.*

class MasterPageGenerator {
	def generate(Model model) '''
		«val displayName = model.name.split("\\.").last.camelCaseToLabel»
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml"
		  xmlns:h="http://java.sun.com/jsf/html"
		  xmlns:f="http://java.sun.com/jsf/core"
		  xmlns:ui="http://java.sun.com/jsf/facelets">
		<f:view>
		  <ui:insert name="metadata" />
		  <h:head>
		    <h:outputStylesheet name="default.css" />
		    <!-- set page title by param -->
		    <title>«displayName» - <ui:insert name="title">Title</ui:insert></title>
		  </h:head>
		  <h:body>
		    <div id="header">
		      <ui:insert name="header">
		        <h1><span id="title">«displayName»</span></h1>
		      </ui:insert>
		    </div>
		    <div id="navigation">
		      <ui:insert name="navigation">
		        <ui:include src="/resources/navigation.xhtml" />
		      </ui:insert>
		    </div>
		    <div id="content">
		      <!-- Display global error/success messages -->
		      <h:messages id="messages" fatalClass="success" errorClass="error"
		        warnClass="warning" infoClass="info" globalOnly="true" />
		      <ui:insert name="content"></ui:insert>
		    </div>
		    <div id="footer">
		      <ui:insert name="footer">&copy; Practical Computer Science</ui:insert>
		    </div>
		  </h:body>
		</f:view>
		</html>
	'''
}
