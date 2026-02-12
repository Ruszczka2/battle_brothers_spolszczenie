this.world_screen_topbar_ambition_module <- this.inherit("scripts/ui/screens/ui_module", {
	m = {},
	function clearEventListener()
	{
	}

	function create()
	{
		this.m.ID = "TopbarAmbitionModule";
		this.ui_module.create();
	}

	function destroy()
	{
		this.clearEventListener();
		this.ui_module.destroy();
	}

	function setText( _text )
	{
		this.m.JSHandle.asyncCall("setText", _text);
	}

	function onRequestCancel()
	{
		if (!this.World.Ambitions.hasActiveAmbition())
		{
			return;
		}

		if (!this.World.Ambitions.getActiveAmbition().isCancelable())
		{
			return;
		}

		this.World.State.showDialogPopup("Anuluj Ambicję", "Anulowanie ambicji pozwoli ci wybrać inną, jednakże spowoduje też, że twoi ludzie będą zawiedzeni tobą jako przywódcą.\n\nCzy na pewno chcesz anulować?", this.onCancelAmbition.bindenv(this), null);
	}

	function onCancelAmbition()
	{
		this.World.Ambitions.cancelAmbition();
	}

});

