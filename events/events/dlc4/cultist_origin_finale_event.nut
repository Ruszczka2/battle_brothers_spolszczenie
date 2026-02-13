this.cultist_origin_finale_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Sacrifice = null
	},
	function create()
	{
		this.m.ID = "event.cultist_origin_finale";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]%cultist% wchodzi do twojego namiotu, a silny, przenikliwy wiatr wpada za nim, unosząc twoje zwoje i notatki. Idzie do przodu, z rękami skrzyżowanymi przed sobą, a w jego podejściu jest coś kapłańskiego.%SPEECH_ON%Panie, przemówiono do mnie i to sprawa poważna, za którą powierzono mi odpowiedzialność.%SPEECH_OFF%Unosisz dłoń i każesz mu milczeć. Ostrożnie gasisz każdą świecę w namiocie, aż zostaje tylko jedna. Przybliżasz ją do twarzy...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Przemów do mnie, Davkulu.",
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
			Text = "[img]gfx/ui/events/event_33.png[/img]Klękając przed świecą, trzymasz dłoń nad płomieniem, a ogień zamiera, wyprostowany i nieruchomy. Widziałeś bardziej żywe sople. Wpatrujesz się w blask, a namiot rozpływa się, znikając w fałdach ogromnej i niezmiennej ciemności. Kultysta znika. Na jego miejscu jest czarny płaszcz, jego ramiona spoczywają na twoich barkach, a głowa to granitowa płyta, o krawędziach wyszczerbionych i pękających. Wygląda na to, że coś kryje się za tą maską, za tym daremnym wysiłkiem, by chronić twój umysł przed jej prawdziwym obliczem. Wyciągasz rękę do maski, ale jakaś niewidzialna siła cię powstrzymuje.%SPEECH_ON%W swoim czasie ujrzysz wszystko, czym jestem.%SPEECH_OFF%Głos jest donośny, a jednak zwężony do brutalnego szeptu słyszalnego tylko dla ciebie.%SPEECH_ON%Dam ci Śmierć, śmiertelniku, a rozgrzana jej komfortem, Śmierć spadnie na twoich wrogów. %sacrifice% nie zostanie utracony, będzie z tobą zawsze, to ci obiecuję.%SPEECH_OFF%Biel powraca jak trzask, podmuch wiatru, płaty namiotu odginają się na zewnątrz, płomień świecy przechyla się niemożliwie, nie gasnąc, a lodowaty chłód sprawia, że pierwszy oddech widać w powietrzu. %cultist% nie ma nigdzie. Szybko wstajesz i dotykasz twarzy i skóry, upewniając się, że jesteś tym, kim masz być. Ku twojemu rozczarowaniu Davkul zniknął, a ty wciąż jesteś sobą.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ofiara musi być złożona.",
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
			Text = "[img]gfx/ui/events/event_33.png[/img]Davkul byłby bardzo niezadowolony z twojego nieposłuszeństwa, choć nie czujesz żadnego innego impulsu poza wykonaniem tego, o co prosi. Ty i %cultist% idziecie do namiotu %sacrifice%. Podnosi się, jakby już na was czekał, widzi nóż w orszaku kompanii i kiwa głową na jego widok. %cultist% klęka obok mężczyzny i uświadamiasz sobie, że rozmawiali już wcześniej, a pytanie, które ci zadano, mogło być próbą twojej wiary w Davkula. Cieszysz się, że ją przeszedłeś.\n\n%sacrifice% rozpina koszulę, a %cultist% przebija mu pierś tak, jakby wkładał klucz do zamka, po czym przekręca go tak samo. Ofiara sapie i napina się, bo żadna pobożność wobec Davkula nie potrafi odsunąć sposobu, w jaki śmierć bywa dopuszczona, a jest to ból i cierpienie. Ale uśmiecha się, a światło w jego oczach nie tyle gaśnie, co zostaje zastąpione mrokiem, jakiego jeszcze nie widziałeś. I tak po prostu znika.\n\n%cultist% zabiera się do pracy na wciąż ciepłych zwłokach, nacinając skórę szybkimi cięciami i głęboko rozcinając ścięgna. Rozrywa klatkę piersiową. Czarna mgła towarzyszy każdemu ruchowi ostrza i zdaje się wesoło kołysać za każdym ruchem. Gdy %cultist% kończy, %sacrifice% został przemieniony w płytę pancerza: ciało rozdarte i rozciągnięte, zęby jako nity, ścięgna jako paski, kości jako naramienniki, kirys absolutnej rzezi. Pulsuje i porusza się, jakby to, co się w nim zamanifestowało, wciąż żyło. %cultist% odwraca się do ciebie, a jego dłonie są czerwone od krwi.%SPEECH_ON%Davkul czeka na nas wszystkich.%SPEECH_OFF%Kiwasz głową i obejmujesz towarzysza.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Stało się i jest to dobre.",
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
					text = _event.m.Sacrifice.getName() + " zginął"
				});
				_event.m.Sacrifice.getItems().transferToStash(this.World.Assets.getStash());
				this.World.getPlayerRoster().remove(_event.m.Sacrifice);
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/armor/legendary/armor_of_davkul");
				item.m.Description = "Makabryczny aspekt Davkula, pradawnej mocy nie z tego świata, oraz ostatnie szczątki " + _event.m.Sacrifice.getName() + ", z którego ciała został uformowany. Nigdy się nie złamie, zamiast tego będzie na miejscu odrastać jego bliznowata skóra.";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
					{
						bro.improveMood(2.0, "Udobruchał Davkula");

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
						bro.worsenMood(3.0, "Przerażony śmiercią " + _event.m.Sacrifice.getName());

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
			Text = "[img]gfx/ui/events/event_33.png[/img]Czujesz, że to próba. Nie taka, którą zdaje się poprzez poświęcenie jednego z ludzi, lecz wręcz przeciwnie. Davkul mógł wysłać fałszywych wiernych, by sprawdzić, czy zrobisz wszystko, co mówią, tylko dlatego, że tak mówią. Nie wiesz, skąd to wiesz, po prostu wiesz, a to właśnie taka pewność, którą człowiek powinien się kierować. Gdy już masz powiedzieć %cultist%owi o swojej decyzji, połowa świec w pomieszczeniu nagle gaśnie. Smugi dymu snują się w pozostałym mroku, skręcającą się mgłą, przez którą na moment przysięgasz, że widzisz sczerniałe oblicze znikające w wejściu do namiotu. Czujesz, że %cultist% już wie, jaki wybór podjąłeś. Zostajesz w namiocie i czekasz na obecność Davkula. Gdy jej nie czujesz, po prostu zapalasz świece na nowo i mówisz do pustego pomieszczenia.%SPEECH_ON%Davkul czeka na nas wszystkich.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A wraz z nim, ciemność.",
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
						bro.worsenMood(2.0, "Odmówiono mu szansy na udobruchanie Davkula");

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
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 150)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.cultists")
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

				if (bro.getLevel() >= 11)
				{
					sacrifice_candidates.push(bro);
				}
			}
		}

		if (cultist_candidates.len() <= 5 || bestCultist == null || bestCultist.getLevel() < 11 || sacrifice_candidates.len() < 2)
		{
			return;
		}

		for( local i = 0; i < sacrifice_candidates.len(); i = ++i )
		{
			if (bestCultist.getID() == sacrifice_candidates[i].getID())
			{
				sacrifice_candidates.remove(i);
				break;
			}
		}

		this.m.Cultist = bestCultist;
		this.m.Sacrifice = sacrifice_candidates[this.Math.rand(0, sacrifice_candidates.len() - 1)];
		this.m.Score = cultist_candidates.len();
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

