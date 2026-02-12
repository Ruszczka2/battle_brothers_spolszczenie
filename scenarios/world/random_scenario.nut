this.random_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.random";
		this.m.Name = "Losowy";
		this.m.Description = "[p=c][img]gfx/ui/events/event_74.png[/img][/p][p]Rozpocznij kampanię z losowo wybranym scenariuszem. Jakże ekscytujące![/p]";
		this.m.Difficulty = 0;
		this.m.Order = 900;
	}

	function isValid()
	{
		return this.Const.DLC.Wildmen;
	}

});

