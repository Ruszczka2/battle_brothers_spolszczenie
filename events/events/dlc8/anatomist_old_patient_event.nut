this.anatomist_old_patient_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_old_patient";
		this.m.Title = "W %townname%";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_77.png[/img]{Mieszkańcy %townname% w większości patrzyli na ciebie i anatomistów jak na błąkające się diabły. Ale nagle jakiś mężczyzna schodzi z ganku i maszeruje przez drogę w stronę %anatomist% anatomisty, z wyprostowaną postawą, sprężystym krokiem i szerokim uśmiechem. Chwyta anatomistę za rękę i zaczyna nią energicznie potrząsać.%SPEECH_ON%Do diabła, wiedziałem, że kiedyś wrócisz! Nie poznajesz mnie? Przechodziłeś tędy lata temu, wiele lat temu, obaj wyglądaliśmy wtedy młodziej. Miałem ten wielki worek na plecach, który mi wyciąłeś, i od tamtego czasu moje życie jest o wiele lepsze! Do diabła, daj mi chwilę, nie ruszaj się, zaraz wracam!%SPEECH_OFF%Mężczyzna szybko wraca do domu. Patrzysz na %anatomist%, który mówi, że pamięta tego człowieka: miał ogromny guz na kręgosłupie, a młody anatomista wyciął go szczypcami, nożami i sporą liczbą szmat. Żałuje, że nie zachował tej masy do badań, ale w tamtych czasach był innym typem lekarza. Mężczyzna wraca z bronią, którą wyciąga w twoją stronę.%SPEECH_ON%Gdy wróciłem do zdrowia, poszedłem na pola bitew. Byłem w tym całkiem dobry, ale wiesz, życie się zmienia i ciągle się zmienia. Widziałem cię z tym najemnikiem, więc uznałem, że u ciebie też się zmieniło. Proszę, weź to.%SPEECH_OFF%Gdy tylko anatomista się waha, ty sam bierzesz broń, by dobroczynna okazja nie przepadła. Dziękujesz mężczyźnie. Ten jeszcze raz potrząsa dłońmi %anatomist%, po czym żegna się. Anatomista wpatruje się w niego, gdy odchodzi.%SPEECH_ON%Moglibyśmy na nim eksperymentować, teraz gdy w pełni przypominam sobie jego przypadek. Ta masa na jego plecach zapewne wróci, mógłbym... po prostu... go otworzyć i zobaczyć...%SPEECH_OFF%Powstrzymujesz anatomistę przed rozważaniem rozcinania miejscowej ludności i wracacie na drogę.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gdzie indziej znajdziesz do badań wiele czarnych mas.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local weapons = [
					"weapons/arming_sword",
					"weapons/winged_mace",
					"weapons/warhammer",
					"weapons/fighting_spear",
					"weapons/fighting_axe",
					"weapons/military_cleaver"
				];
				local weapon = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				this.World.Assets.getStash().add(weapon);
				this.List.push({
					id = 10,
					icon = "ui/items/" + weapon.getIcon(),
					text = "Zyskujesz " + weapon.getName()
				});

				if (this.Math.rand(1, 100) <= 75)
				{
					_event.m.Anatomist.improveMood(0.75, "Zobaczył dowód, że jego dawna praca była skuteczna");
				}
				else
				{
					_event.m.Anatomist.improveMood(0.5, "Dawny pacjent podziękował mu za pomoc medyczną");
				}

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() || t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomistCandidates.push(bro);
			}
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = 5;
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
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Town = null;
	}

});

