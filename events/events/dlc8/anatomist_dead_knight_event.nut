this.anatomist_dead_knight_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Noble = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_dead_knight";
		this.m.Title = "Wzdłuż drogi...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_75.png[/img]{%anatomist% anatomista dostrzega coś błyszczącego nieco z boku głównej drogi. Podchodzisz i przyglądasz się. W oddali widać coś ciemnego i metalicznego. Może zwłoki rycerza? Choć zastanawiasz się, jak trafił tam sam. %anatomist% zastanawia się na głos, czy z ciała o domniemanej wielkiej sprawności bojowej nie dałoby się czegoś nauczyć. Kręcisz głową.%SPEECH_ON%Rycerze rzadko umierają sami, a jeśli już, to do cholery nie trzymają przy sobie pancerza. To śmierdzi pułapką od początku do końca.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Chodźmy po to.",
					function getResult( _event )
					{
						if (_event.m.Noble != null)
						{
							return "C";
						}
						else if (this.World.FactionManager.isUndeadScourge())
						{
							return "E";
						}
						else if (this.Math.rand(1, 100) <= 30)
						{
							return "D";
						}
						else
						{
							return "B";
						}
					}

				},
				{
					Text = "Nie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_46.png[/img]{Wbrew lepszemu osądowi idziesz sprawdzić. Czujesz się dość naga, idąc przez otwarty teren do rycerza, jak złodziej sięgający przez cały korytarz. Gdy docierasz do rycerza, zatrzymujesz się i rozglądasz. Brak ruchu w okolicy. Żadnych bandytów, żadnej zasadzki. Żadnej watahy wilków. Wzruszasz ramionami i patrzysz w dół. Mężczyzna ma przyzwoity pancerz i niezły, choć używany miecz. Jego twarz jest wyschnięta, a oczu brak. Zaschnięte ptasie odchody tworzą skorupę na otarciach napierśnika. Każesz %anatomist% wydobyć go ze zbroi i zanieść wszystko z powrotem do wozu.%SPEECH_ON%Co? Czemu ja mam to zrobić?%SPEECH_OFF%Mówisz mu, że jeśli chce badać ciało, to ceną jest rozebranie go. Odchodząc, mówisz, by wkładając to do ekwipunku, nie zgniatał żywności, bo pancerz wygląda na ciężki. I niech zmyje te ptasie odchody. %anatomist% wzdycha, ale i tak cieszy się z dostępu do zwłok jednego \"bohatera\". Czasem zastanawiasz się, co anatomista zrobiłby, gdyby znalazł ciebie martwego w taki sposób...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prościzna.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local armor_list = [
					"decayed_coat_of_scales",
					"decayed_reinforced_mail_hauberk"
				];
				local item = this.new("scripts/items/armor/" + armor_list[this.Math.rand(0, armor_list.len() - 1)]);
				item.setCondition(item.getConditionMax() / 2 - 1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/arming_sword");
				item.setCondition(item.getConditionMax() / 2 - 1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Anatomist.improveMood(0.75, "Mógł zbadać zwłoki bohaterskiego rycerza");

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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_78.png[/img]{Wyruszasz w stronę sterty pancerza, mając nadzieję, że to nie pułapka, na jaką wygląda. %anatomist% idzie niemal przy twoim boku, oczy pożerają mu tę perspektywną \"naukę\", a dłonie trzymają otwartą księgę, do której już gorliwie pisze.\n\nKu zaskoczeniu, idzie z wami %noble%, człowiek ze szlacheckiego rodu, który zdaje się rozpoznawać sam pancerz. Rzeczywiście, gdy się zbliżacie, wykrzykuje, że to jego dobry przyjaciel sprzed lat. Kiwasz głową z powagą, ale i tak mówisz, że pancerz lepiej posłuży kompanii, zamiast niszczeć tu na ziemi. Mężczyzna przytakuje.%SPEECH_ON%Myślę, że wolałby to samo. Zdejmę go z niego.%SPEECH_OFF%Zanim zacznie, %noble% odwraca się do %anatomist% i mówi mu, żeby nawet nie ważył się dotknąć jego przyjaciela. Wracasz z anatomistą do wozu, bo dałeś mu zadanie niesienia samego pancerza. Spocony anatomista jest zły, że nie miał szansy obejrzeć zwłok, a %noble% wyraźnie przejęty, że zwłoki należały do dobrego przyjaciela. Ostatecznie wygląda na to, że ten przeklęty trup przyniósł więcej żalu, niż był wart.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przynajmniej mamy pancerz.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Noble.getImagePath());
				local armor_list = [
					"armor/decayed_reinforced_mail_hauberk",
					"helmets/decayed_closed_flat_top_with_mail"
				];
				local item = this.new("scripts/items/" + armor_list[this.Math.rand(0, armor_list.len() - 1)]);
				item.setCondition(item.getConditionMax() / 2 - 1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Anatomist.worsenMood(1.0, "Odebrano mu szansę zbadania obiecujących zwłok");

				if (_event.m.Anatomist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}

				_event.m.Noble.worsenMood(2.0, "Zobaczył rozkładające się szczątki starego przyjaciela");

				if (_event.m.Noble.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_21.png[/img]{Decydujesz się podejść. Gdy idziesz przez pozornie otwartą równinę, masz wrażenie, że ktoś cię obserwuje. Coś w tym wszystkim jest nie tak. W połowie drogi odwracasz się do %anatomist% i mówisz mu, że trzeba zawrócić. Kręci głową i mówi, że doszliście już tak daleko, więc czemu teraz się cofać? Zanim zdążysz odpowiedzieć, strzała śwista obok ucha, a anatomista pada do tyłu, trzymając się za ramię.\n\nZbierasz go i wleczesz z powrotem do wozu, strzały wbijają się w ziemię wokół was, kępy ziemi pryskają na buty, aż zaczynają uderzać w sam wóz. Zbierając kompanię do kontrataku, widzisz, jak domniemani napastnicy uznają, że to nie ma sensu, i uciekają, a kilku z nich zabiera pancerz rycerza. Jak sądziłeś, to była brigandzka pułapka. %anatomist% na szczęście przeżyje i już zapisuje w swojej księdze to doświadczenie, albo, sądząc po jego fascynacji strzałą tkwiącą w nim, zapisuje coś o swojej makabrycznej ranie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Następnym razem posłucham intuicji.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local injury = _event.m.Anatomist.addInjury(this.Const.Injury.Accident2);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " cierpi na " + injury.getNameOnly()
				});
				_event.m.Anatomist.improveMood(1.0, "Mógł z bliska zbadać ciekawą ranę");

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
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_184.png[/img]{Wbrew lepszemu osądowi idziesz i sprawdzasz. Czujesz się dość naga, idąc przez otwarty teren do rycerza, jak złodziej sięgający przez cały korytarz. Zbliżając się do zwłok, odwracasz się, by zapytać %anatomist%, co planuje z ciałem. Widzisz, że anatomista stoi sztywno, z odchyloną głową i szeroko otwartymi oczami, a nerwowa, drgająca dłoń wskazuje do przodu. Odwracasz się i widzisz, jak zwłoki się poruszają, powoli podnosząc się z ziemi, jęcząc, rechocząc. Hełm wysuwa się do przodu, a przez jego szczeliny sączy się plugastwo. Dobijasz się po miecz.\n\nCzarny rycerz podnosi się z ziemi, a jego rękawice opadają, ukazując blade ciało pod spodem. Obraca się ku tobie, a w pieniącym się hełmie jarzy się delikatna czerwień. Rąbiesz mieczem i głowa stwora spada, brzęcząc o ziemię, a z szyi ulatuje powietrze. Chowając miecz, mówisz %anatomist%, że jeśli chce czegoś do badania, to proszę bardzo.%SPEECH_ON%I pamiętaj, żeby zanieść jego zbroję do wozu. Używaj nóg, kiedy się schylasz, nie chcę, żebyś sobie kręgosłup uszkodził.%SPEECH_OFF%Mijasz anatomistę. Ten patrzy osłupiały, potem zamyka usta i wyciąga pióro oraz zwoje. Strach mija, a na pierwszy plan wraca jego zwykła postawa.%SPEECH_ON%Świeży okaz, z bliska, niedawno zmarły, a może ponownie zmarły? Tak czy inaczej...możemy się z tego wiele nauczyć.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Możesz też nauczyć się schylać na nogach, raz-dwa.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local armor_list = [
					"armor/decayed_reinforced_mail_hauberk",
					"helmets/decayed_closed_flat_top_with_mail"
				];
				local item = this.new("scripts/items/" + armor_list[this.Math.rand(0, armor_list.len() - 1)]);
				item.setCondition(item.getConditionMax() / 2 - 1);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Anatomist.addXP(200, false);
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/xp_received.png",
					text = _event.m.Anatomist.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+200[/color] doświadczenia"
				});
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

		if (this.World.getTime().Days <= 25)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];
		local noble_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
			else if (bro.getBackground().isNoble())
			{
				noble_candidates.push(bro);
			}
		}

		if (noble_candidates.len() > 0)
		{
			this.m.Noble = noble_candidates[this.Math.rand(0, noble_candidates.len() - 1)];
		}

		if (anatomist_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Score = 5 + anatomist_candidates.len();
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
			"noble",
			this.m.Noble != null ? this.m.Noble.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Noble = null;
	}

});

