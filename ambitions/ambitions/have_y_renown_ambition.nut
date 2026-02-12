this.have_y_renown_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.have_y_renown";
		this.m.Duration = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Staliśmy się już rozpoznawalni w niektórych stronach, nadal jednak\ndaleko nam do legendarnej kompanii. Zwiększymy swoją sławę jeszcze bardziej!";
		this.m.UIText = "Osiągnij \'Wspaniałą\' sławę";
		this.m.TooltipText = "Stań się znany jako \'Wspaniały\' (2.750 sławy) w krainie. Swoją sławę możesz zwiększyć wypełniając kontrakty i wygrywając bitwy.";
		this.m.SuccessText = "[img]gfx/ui/events/event_82.png[/img]Marching through forests and over plains, the band has smashed any opposition they\'ve been sent after. Trampling foes, shattering battle lines, and sending heads flying, the %companyname% find that they are seldom alone. Crows circle high over the company as they march, they sing as the men take their supper, and more often than not they feast well after their daily work is done.\n\nIn their wake, the men leave scorched earth and outlandish rumors everywhere their booted feet have tread, each tale burgeoning in the telling until everyone from milkmaids to blacksmiths to burgomeisters seems to be talking about your exploits. Gossip is a currency valued in every corner of the land, and neither broad rivers nor tall peaks will slow the tales of your victories, and in turn, the prices you can now demand for your services.";
		this.m.SuccessButtonText = "Ludzie teraz wiedzą co to %companyname%!";
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 30)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() >= 2650)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (this.World.Assets.getBusinessReputation() >= 2750)
		{
			return true;
		}

		return false;
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

