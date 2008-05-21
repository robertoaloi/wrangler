package org.erlide.wrangler.refactoring.core.movefunction;

import org.erlide.wrangler.refactoring.core.WranglerRefactoring;
import org.erlide.wrangler.refactoring.ui.WranglerRefactoringWizard;

public class Movefunctionwizard extends WranglerRefactoringWizard {

	public Movefunctionwizard(WranglerRefactoring refactoring, int flags) {
		super(refactoring, flags);
	}

	@Override
	protected void addUserInputPages() {
		addPage(new TargetModuleNameInputPage("Get target module name"));
	}

	@Override
	protected String initTitle() {
		return "Move function to another module";
	}

}
