this.kings_guard_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.kings_guard";
		this.m.Name = "Gwardzista Królewski";
		this.m.Icon = "ui/backgrounds/background_59.png";
		this.m.BackgroundDescription = "";
		this.m.GoodEnding = "Gdy znalazłeś %name% zamarzającego na północnych pustkowiach, wziąłeś go za zwykłego chłopa. Jak się okazało, był prawdziwym Gwardzistą Królewskim, nie tylko z tytułu, ale i z czynów. Walczył jak człowiek, który chroni swego seniora przed całym światem. Na szczęście przez pewien czas tym \"seniorem\" byłeś ty. Ostatnio słyszałeś, że wyruszył do południowych krain i strzeże młodego króla nomadów, próbującego obalić miejscowych wezyrów.";
		this.m.BadEnding = "Nigdy tak naprawdę nie dowiedziałeś się, jakiego króla %name% rzekomo \"strzegł\" przed dołączeniem do %companyname%, ale teraz nie ma to znaczenia. Po twojej nagłej emeryturze Gwardzista Królewski udał się na południowe pustynie. Przez pewien czas służył wezyrowi, ale nie zdołał ochronić władcy przed trucizną nałożnicy. Za karę ekwipunek %name% przetopiono w kocioł i wlano mu do gardła.";
		this.m.HiringCost = 0;
		this.m.DailyCost = 30;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onAdded()
	{
		this.character_background.onAdded();
		local actor = this.getContainer().getActor();
		actor.setTitle("Gwardzista Królewski");
	}

});

