this.cultist_finale_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Sacrifice = null
	},
	function create()
	{
		this.m.ID = "event.cultist_finale";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]%cultist% wchodzi do twojego namiotu, a za nim wpada silny, rześki podmuch wiatru, unosząc twoje zwoje i notatki. Podchodzi, z dłońmi splecionymi przed sobą, a jego ruchy mają coś z kapłańskiej powagi.%SPEECH_ON%Panie, zostałem wezwany i powierzono mi poważną sprawę.%SPEECH_OFF%Pytasz, o kogo do diabła mu chodzi. Kultysta pochyla się, jakby słowa ciążyły mu na języku.%SPEECH_ON%Davkul, panie.%SPEECH_OFF%Ach, oczywiście, a kto inny? Mówisz mu, by wyjaśnił, czego potrzebuje. Odpowiada.%SPEECH_ON%Nie, nie ja, Davkul. To Davkul potrzebuje - i potrzebuje krwi, ofiary.%SPEECH_OFF%Mówisz mu, że kompania może zatrzymać się w następnym mieście i kupić jakieś kury, jagnięta albo cokolwiek mu potrzeba, jeśli to takie ważne. %cultist% kręci głową.%SPEECH_ON%Krew jakiegoś psotnego bydlęcia? Nie, on żąda krwi wojownika. Prawdziwego ducha walki, a on zaufał mi, że znajdę człowieka takiej miary - i znalazłem.%SPEECH_OFF%Kultysta prostuje się, a światło świecy w namiocie nagle staje się chwiejne i niespokojne.%SPEECH_ON%Davkul żąda krwi %sacrifice%.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A jeśli na to szaleństwo się zgodzę albo nie?",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]Podchodząc do migoczącej świecy, %cultist% trzyma dłoń nad płomieniem, a ogień zastyga w bezruchu, stojąc pionowo i nieruchomo. Widziałeś bardziej ożywione sople. Mówi, wpatrując się w blask.%SPEECH_ON%Jeśli to zrobimy, Davkul będzie bardzo zadowolony. Jeśli nie, cóż, zobaczymy. Nawet ja nie wiem, co wtedy się stanie.%SPEECH_OFF%Mówisz kultystzie, że prosi cię o zabicie jednego z własnych ludzi. Będzie musiał się bardziej postarać. Słysząc to, podchodzi i chwyta cię za ramiona. Namiot rozpływa się, zapadając w fałdy ogromnej i niezmiennej ciemności. Kultysta znika. W jego miejscu jest czarny płaszcz, jego ramiona spoczywają na twoich barkach, a głowa to płyta granitu, z wyszczerbionymi i popękanymi krawędziami. Wygląda, jakby za tą maską, za tym daremnym wysiłkiem ochrony twojego umysłu przed prawdziwym obliczem, kryło się coś więcej. Odzywa się głos, gardłowy, grzmiący, a jednak zwężony do brutalnego szeptu tylko dla ciebie.%SPEECH_ON%Dam ci Śmierć, śmiertelniku, i rozgrzana swymi pociechami, Śmierć spadnie na twoich wrogów. %sacrifice% nie przepadnie, będzie z tobą zawsze, to ci obiecuję.%SPEECH_OFF%Biel gwałtownie wraca, podmuch wiatru, płaty namiotu wyginają się na zewnątrz, płomienie świec przechylają się niemożliwie, nie gasnąc, i lodowaty chłód sprawia, że widzisz swój pierwszy oddech unoszący się w powietrzu. %cultist% nigdzie nie widać. Szybko się podnosisz i dotykasz twarzy oraz skóry, upewniając się, że jesteś tym, kim powinieneś być. Wizja jednak zostaje, a jej pulsujący odcisk pozostawia ponurą rzeczywistość, że to, co zasugerował kultysta, trzeba potraktować całkiem poważnie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zrób to, co trzeba.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Absolutnie nie!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]Ulegasz niepodważalnemu wrażeniu, że Davkul byłby wielce niezadowolony z twojego nieposłuszeństwa. Ale %sacrifice% zasłużył też na pożegnalne słowo. Uspokajasz twarz, wychodzisz z namiotu i idziesz porozmawiać z człowiekiem. Może sam dźwięk jego głosu otrzeźwi cię, zanim zrobisz krok w szaleńczą pustkę, do której ten czyn z pewnością cię wzywa.\n\n Gdy docierasz do jego namiotu, zauważasz, że klapa jest już otwarta i łagodnie faluje na wietrze. Wchodzisz do środka i widzisz najemnika w łóżku, z narzuconym na niego kocem. Siadasz i mówisz kilka słów, licząc w głębi, że obudzi się w trakcie.%SPEECH_ON%Byłeś dobry, %sacrifice_short%, lepszy, niż mógłbym prosić. Prawdziwy brat dla %companyname% i wojownik, z którego każdy kapitan byłby dumny.\n\nHej, nie zostawiaj mnie tu do gadania. Wiem, że nie śpisz, łobuzie.%SPEECH_OFF%Sięgasz po koc i odsuwasz go. Podskakujesz i niemal przewracasz cały namiot. W łóżku nie leży %sacrifice%, lecz tułów, którego ciało rozerwano i naciągnięto na zbroję z nieznanego metalu, zębów użyto jako nitów, ścięgien jako rzemyków, kości jako naramienników, a napierśnik jest czystą rzezią. %cultist% stoi w wejściu namiotu.%SPEECH_ON%Davkul jest wielce zadowolony i obdarzył nas aspektem Śmierci.%SPEECH_OFF%To... to nie jest to, czego się spodziewałeś. Nawet nie wiesz, czego się spodziewałeś, ale czegoś takiego nie dało się przewidzieć ani przygotować. Co się stało, to się stało, a dusza %sacrifice% niech spoczywa w pokoju. Ty raczej nigdy nie będziesz.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oby starzy bogowie nie patrzyli na mnie tej nocy.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sacrifice.getImagePath());
				local dead = _event.m.Sacrifice;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Sacrificed to Davkul",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Sacrifice.getName() + " poległ"
				});
				_event.m.Sacrifice.getItems().transferToStash(this.World.Assets.getStash());
				_event.m.Sacrifice.getSkills().onDeath(this.Const.FatalityType.None);
				this.World.getPlayerRoster().remove(_event.m.Sacrifice);
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/armor/legendary/armor_of_davkul");
				item.m.Description = "Makabryczny aspekt Davkula, pradawnej mocy nie z tego świata, oraz ostatnich szczątków " + _event.m.Sacrifice.getName() + ", z których ciała został uformowany. Nigdy się nie złamie, lecz wciąż na nowo odrasta mu bliznowata skóra na tym miejscu.";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Otrzymujesz " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.improveMood(2.0, "Appeased Davkul");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else
					{
						bro.worsenMood(3.0, "Horrified by the death of " + _event.m.Sacrifice.getName());

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_33.png[/img]Mimo grozy, której właśnie byłeś świadkiem, decydujesz, że %sacrifice% ma żyć. Kiedy tylko wstajesz, by powiedzieć o tym %cultist%, połowa świec w namiocie nagle gaśnie. Smugi dymu unoszą się ku górze, tworząc skręconą mgłę, przez którą na moment przysięgasz, że widzisz ostre, gniewne oblicze, które odwraca się i znika. Masz wrażenie, że %cultist% już wie, jakiego dokonałeś wyboru. Zostajesz w namiocie i zapalasz świece na nowo.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Gdzieś po drodze ta kompania skręciła w złą stronę.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.worsenMood(2.0, "Was denied the chance to appease Davkul");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 200)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.cultists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 12)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local sacrifice_candidates = [];
		local cultist_candidates = [];
		local bestCultist;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				cultist_candidates.push(bro);

				if ((bestCultist == null || bro.getLevel() > bestCultist.getLevel()) && bro.getBackground().getID() == "background.cultist")
				{
					bestCultist = bro;
				}
			}
			else if (bro.getLevel() >= 11 && !bro.getSkills().hasSkill("trait.player") && !bro.getFlags().get("IsPlayerCharacter") && !bro.getFlags().get("IsPlayerCharacter"))
			{
				sacrifice_candidates.push(bro);
			}
		}

		if (cultist_candidates.len() <= 5 || bestCultist == null || bestCultist.getLevel() < 11 || sacrifice_candidates.len() == 0)
		{
			return;
		}

		this.m.Cultist = bestCultist;
		this.m.Sacrifice = sacrifice_candidates[this.Math.rand(0, sacrifice_candidates.len() - 1)];
		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist.getName()
		]);
		_vars.push([
			"sacrifice",
			this.m.Sacrifice.getName()
		]);
		_vars.push([
			"sacrifice_short",
			this.m.Sacrifice.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.Sacrifice = null;
	}

});

