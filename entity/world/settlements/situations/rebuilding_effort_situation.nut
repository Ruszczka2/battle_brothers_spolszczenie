this.rebuilding_effort_situation <- this.inherit("scripts/entity/world/settlements/situations/situation", {
	m = {
		Target = ""
	},
	function create()
	{
		this.situation.create();
		this.m.ID = "situation.rebuilding_effort";
		this.m.Name = "Próba Odbudowy";
		this.m.Description = "Osada stara się odbudować pobliskie miejsce, więc na materiały budowlane jest duży popyt i ciężko o nie w okolicy.";
		this.m.Icon = "ui/settlement_status/settlement_effect_15.png";
		this.m.Rumors = [
			"W końcu zaczynają odbudowywać okolice %settlement%. To miejsce było w ruinie wystarczająco długo.",
			"Ponoć całymi wozami sprowadzają teraz drewno do %settlement%. Nowy burmistrz z pewnością stara się odbudować osadę."
		];
		this.m.IsStacking = false;
		this.m.ValidDays = 5;
	}

	function getDescription()
	{
		if (this.m.Target != "")
		{
			return "Osada stara się odbudować pobliską lokację, którą jest " + this.m.Target.tolower() + ", więc na materiały budowlane jest duży popyt i ciężko o nie w okolicy.";
		}
		else
		{
			return this.m.Description;
		}
	}

	function getAddedString( _s )
	{
		return _s + " podejmuje próbę odbudowy";
	}

	function getRemovedString( _s )
	{
		return _s + " zakończyło próbę odbudowy";
	}

	function isValid()
	{
		if (this.m.Target == "")
		{
			return false;
		}

		return this.situation.isValid();
	}

	function onAdded( _settlement )
	{
		_settlement.resetShop();
		local candidates = [];

		foreach( a in _settlement.getAttachedLocations() )
		{
			if (a.isActive())
			{
				continue;
			}

			candidates.push(a);
		}

		if (candidates.len() != 0)
		{
			this.m.Target = candidates[this.Math.rand(0, candidates.len() - 1)].getRealName();
		}
	}

	function onUpdate( _modifiers )
	{
		_modifiers.BuildingPriceMult *= 1.35;
		_modifiers.BuildingRarityMult *= 0.5;
	}

	function onRemoved( _settlement )
	{
		if (this.World.Contracts.getActiveContract() != null && this.World.Contracts.getActiveContract().getID() == "contract.raze_attached_location")
		{
			return;
		}

		local candidates = [];

		foreach( a in _settlement.getAttachedLocations() )
		{
			if (a.isActive())
			{
				continue;
			}

			candidates.push(a);
		}

		if (candidates.len() != 0)
		{
			local a = candidates[this.Math.rand(0, candidates.len() - 1)];
			a.setActive(true);
		}
	}

	function onSerialize( _out )
	{
		this.situation.onSerialize(_out);
		_out.writeString(this.m.Target);
	}

	function onDeserialize( _in )
	{
		this.situation.onDeserialize(_in);
		this.m.Target = _in.readString();
	}

});

