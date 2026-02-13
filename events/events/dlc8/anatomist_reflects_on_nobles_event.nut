this.anatomist_reflects_on_nobles_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_reflects_on_nobles";
		this.m.Title = "W czasie obozu...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_39.png[/img]{%anatomist% anatomista siedzi przy ognisku. Wygląda na głęboko zamyślonego. Będąc trochę dupkiem, uznajesz, że to idealna chwila, by podejść i zacząć go wypytywać, zwłaszcza o najbardziej irytujące pytanie na świecie: \"O czym myślisz?\" Anatomista mruży oczy i wypuszcza długie westchnienie. Mówi,%SPEECH_ON%Rozważam naturę bytów tego świata, zwłaszcza tych najwyżej i najniżej. Zrozum, łobuzie, że w naszych podróżach spotkaliśmy wielu możnych, a wrażenie, jakie na mnie wywarli, jest skrajnie rozczarowujące. Dzikie zwierzęta funkcjonują na równej zasadzie: ten, kto je, i ten, kto żebrze o okruchy lub sam jest okruchem, są rozdzieleni talentem, czystym w swojej wrodzoności. Czy aksjomat, że bycie najlepszym pozwala wznieść się na szczyt, obowiązuje tylko w świecie zwierząt? Uważałem, że nasi władcy, a teraz dobroczyńcy, będą odzwierciedlać te prawdy. Zamiast tego wciąż spotykam błaznów. Niezdolnych, których głównym talentem jest balansowanie przyjemnościami: zbyt wiele i chłopi oburzają się na zbytki, zbyt mało i lud uważa, że władcy marnują swój niezwykle szczęśliwy los. Moja ocena bliźnich spada z każdym dniem. Ośmielę się powiedzieć, ośmielę się powiedzieć, łobuzie... łobuzie, słuchasz mnie?%SPEECH_OFF%Kręcisz patykiem w ogniu, gdy słyszysz swoje przezwisko. Spoglądasz i mówisz, że te myśli nie są ci obce, ale to tylko myśli. Mimo presji otoczenia wciąż decydujesz, o czym myślisz. Jeśli tak go to dręczy, powinien to po prostu odłożyć. W końcu nie ma kontroli nad światem, a takie rozważania nie przyniosą większej zmiany. To zwykłe narzekanie. Anatomista wpatruje się w ciebie. Przytakuje.%SPEECH_ON%Uznaję, że dobrze, iż nie rozpamiętuję tych spraw, bo ich błędów nie uczyniła moja ręka i moja ręka nie może ich odwrócić.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "O to chodzi.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local resolve_boost = this.Math.rand(2, 4);
				_event.m.Anatomist.getBaseProperties().Bravery += resolve_boost;
				_event.m.Anatomist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve_boost + "[/color] determinacji"
				});
				_event.m.Anatomist.improveMood(1.0, "Lepiej rozumie granice swojej woli");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1500)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Score = 3 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});

