this.gain_addiction_event <- this.inherit("scripts/events/event", {
	m = {
		Addict = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.gain_addiction";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_12.png[/img]{Krzycząc i wrzeszcząc, %other% wciąga %addict%a do twojego namiotu, rzuca go na ziemię i dobywa broni na mężczyznę, który rozgląda się otępiały i zdezorientowany. Żądasz wyjaśnień. %addict% strąca broń sprzed twarzy i próbuje wstać, ale %other% kopie go z powrotem na ziemię.%SPEECH_ON%Wpadł po uszy w te mikstury, kapitanie. Ledwo możemy trzymać go z dala od zapasów.%SPEECH_OFF%%addict% bełkocze, mruczy i milknie, po czym kiwa głową. Mówi wyraźnie, jak pijak próbujący wyjaśnić swoje przestępstwo strażnikowi.%SPEECH_ON%Nie mam problemu, panie.%SPEECH_OFF%Wstajesz i sprawdzasz jego czoło. Jest zimne, a jednak spocone. %other% spluwa.%SPEECH_ON%Zrobi się trochę agresywny, jeśli konfrontować go z tymi miksturami, panie. Myślę, że się od tego cholerstwa uzależnił.%SPEECH_OFF%Kiwasz głową i mówisz im obu, by starali się trzymać to w ryzach. | %addict% wchodzi do twojego namiotu z potem na czole i podbitymi oczami.%SPEECH_ON%Panie, pomyślałem, że powiem ci o tym osobiście, wiesz, żeby wziąć pełną odpowiedzialność.%SPEECH_OFF%Wyjaśnia, że uzależnił się od mikstur. Mówi, że zrobi wszystko, by to opanować. Kiwasz głową i dziękujesz mu za szczerość. Wieści cię niepokoją, ale na razie niewiele da się zrobić. | Ludzie wyjaśniają, że %addict% mocno przylgnął do mikstur, fiolek i flaszek, tych, które niosą „ducha” większego niż dobre piwo i miód. Nie wiesz, czy to przez nadużycie, czy dlatego, że trudno mu znieść trudy życia najemnika. Kilku ludziom każesz mieć na niego oko. To najlepsze, co możesz teraz zrobić.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Droga zbiera żniwo, ale czy ludzie dadzą radę?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Addict.getImagePath());
				local trait = this.new("scripts/skills/traits/addict_trait");
				_event.m.Addict.getSkills().add(trait);
				this.List.push({
					id = 10,
					icon = trait.getIcon(),
					text = _event.m.Addict.getName() + " jest teraz uzależniony"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates_addict = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getFlags().get("PotionsUsed") >= 4 && this.Time.getVirtualTimeF() - bro.getFlags().get("PotionLastUsed") <= 3.0 * this.World.getTime().SecondsPerDay)
			{
				candidates_addict.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_addict.len() == 0 || candidates_other.len() == 0)
		{
			return;
		}

		this.m.Addict = candidates_addict[this.Math.rand(0, candidates_addict.len() - 1)];
		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = 5 + candidates_addict.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"addict",
			this.m.Addict.getName()
		]);
		_vars.push([
			"other",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Addict = null;
		this.m.Other = null;
	}

});

