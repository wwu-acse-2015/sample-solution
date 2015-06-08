package de.wwu.pi.acse.umlToApp.workflow;

import org.eclipse.xtext.ISetup;

import com.google.inject.Guice;
import com.google.inject.Injector;

public class UmlToAppGeneratorSetup implements ISetup {

	@Override
	public Injector createInjectorAndDoEMFRegistration() {
		return Guice.createInjector(new UmlToAppGeneratorModule());
	}

}
