package de.wwu.pi.acse.dsl.generator.workflow;

import org.eclipse.xtext.ISetup;

import com.google.inject.Guice;
import com.google.inject.Injector;

public class CrudDslGeneratorSetup implements ISetup {

	@Override
	public Injector createInjectorAndDoEMFRegistration() {
		return Guice.createInjector(new CrudDslGeneratorModule());
	}

}
