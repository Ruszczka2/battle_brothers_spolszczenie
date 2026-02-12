this.farmer_old_tricks_event <- this.inherit("scripts/events/event", {
	m = {
		Farmer = null
	},
	function create()
	{
		this.m.ID = "event.farmer_old_tricks";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_82.png[/img]Zastajesz %farmhand% siedzącego obok wozu kompanii. Przekłada źdźbło słomy między zębami, zgrzyta nim tu i tam, po czym wypluwa drobiny. Pytasz, o czym myśli. Rolnik wzrusza ramionami.%SPEECH_ON%O tym, co ojciec mówił mi o wiązaniu siana. Miał taki sposób: skręcał nadgarstek przy wbiciu i znowu przy wyciągnięciu. Nigdy nie umiałem tego drugiego dobrze zrobić.%SPEECH_OFF%Mężczyzna wyjmuje słomkę i strzepuje ją. Pytasz.%SPEECH_ON%Ale pierwszy etap potrafiłeś, tak? Gdy wbijasz się w siano i szarpiesz?%SPEECH_OFF%Kiwa głową. Mówisz mu, że do porządnego wypatroszenia człowieka potrzebuje tylko tej pierwszej części techniki. Widzisz, jak na jego twarzy pojawia się olśnienie.%SPEECH_ON%Tak... tak, racja! Czemu nie pomyślałem o tym wcześniej? Jest pan geniuszem! Spróbuję przy następnym wyjściu! To będzie jak wiązanie siana!%SPEECH_OFF%Tyle że z większą ilością krzyku i krwi, ale jasne.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tylko nie próbuj przerzucać ich przez ramię.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Farmer.getImagePath());
				local meleeSkill = this.Math.rand(2, 4);
				_event.m.Farmer.getBaseProperties().MeleeSkill += meleeSkill;
				this.List.push({
					id = 16,
					icon = "ui/icons/melee_skill.png",
					text = _event.m.Farmer.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + meleeSkill + "[/color] Umiejętności Walki Wręcz"
				});
				_event.m.Farmer.improveMood(1.0, "Realized he has some fighting knowledge");

				if (_event.m.Farmer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Farmer.getMoodState()],
						text = _event.m.Farmer.getName() + this.Const.MoodStateEvent[_event.m.Farmer.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() <= 2 && bro.getBackground().getID() == "background.farmhand")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Farmer = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"farmhand",
			this.m.Farmer.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Farmer = null;
	}

});

