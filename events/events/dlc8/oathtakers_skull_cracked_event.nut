this.oathtakers_skull_cracked_event <- this.inherit("scripts/events/event", {
	m = {
		Oathtaker = null
	},
	function create()
	{
		this.m.ID = "event.oathtakers_skull_cracked";
		this.m.Title = "Po drodze...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{%oathtaker% wpada do namiotu z drzacymi dlonmi, trzymajac czaszke Mlodego Anselma.%SPEECH_ON%Jest peknieta!%SPEECH_OFF%Zrywasz sie z miejsca i ogladzasz swiete szczatki Mlodego Anselma. Po tyle czaszki biegnie cienka szczelina. Na pierwszy rzut oka nie wyglada to zle, ale gdy wsuwasz maly palec i podnosisz, kosci rozchodza sie. Oboje wzdychacie i kladziecie czaszke na stole. Nie ma watpliwosci, ze wystarczy niewiele, by ja rozlamac.%SPEECH_ON%Co mamy zrobic? Jak to naprawic?%SPEECH_OFF%Rozwazasz to bardzo ostroznie. Ostatnim razem, gdy to sie stalo, odlamala sie szczeka Mlodego Anselma, a wraz z nia pekli Swietobiorcy - jedna grupa zostala Swietobiorcami, a druga stala sie dzikimi bluzniercami, Slubodawcami. Nie pozwolisz, by stalo sie to znowu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Napraw to.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Oathtaker.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{Wyciagasz kawalek sznurka i pokrywasz go bluszczem oraz zywica. Potem delikatnie rozchylasz pekniecie Mlodego Anselma i przeciagasz po nim palec z kolejna porcja zywicy. %oathtaker% patrzy nerwowo. Zadowolony, wkladasz sznurek wzdloz pekniecia i skladasz czesci czaszki, przyciskajac sznurek razem z kleistym bluszczem. Cofasz sie i patrzysz na swoje dzielo. %oathtaker% przelyka sline.%SPEECH_ON%Ja... ja nie sadze, zeby ktokolwiek zauwazyl.%SPEECH_OFF%Zastanawiasz sie nawet, czy lepiej byloby, gdyby znaleziono pekniecie bez prob naprawy, niz gdyby ktos zobaczyl robote skradajacego sie majstra, ktory probowal cos przemycic. Tak czy inaczej, zrobione - honor Mlodego Anselma zostal przywrocony. %oathtaker% ociera pot z czola.%SPEECH_ON%Wierze, ze to byla proba, kapitanie, i ze Mlody Anselm nas przez nia przeprowadzil. Jego sila przeplywa przeze mnie i nie ma slow, ktore opisalyby zaszczyt, jaki teraz czuje.%SPEECH_OFF%Co? Mlody Anselm pewnie nie mial pojecia o lepkich zywicach i bluszczu, a zapewne wiedzial jeszcze mniej teraz, gdy jest niema czaszka. Ale... zostawiasz %oathtaker% jego interpretacjom, choc dla ciebie sa one zbyt skromne.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powinienem byc grabarzem.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local resolveBoost = this.Math.rand(2, 4);
				_event.m.Oathtaker.getBaseProperties().Bravery += resolveBoost;
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Oathtaker.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolveBoost + "[/color] Determinacji"
				});

				if (!_event.m.Oathtaker.getSkills().hasSkill("trait.determined"))
				{
					local trait = this.new("scripts/skills/traits/determined_trait");
					_event.m.Oathtaker.getSkills().add(trait);
					this.List.push({
						id = 10,
						icon = trait.getIcon(),
						text = _event.m.Oathtaker.getName() + " jest teraz Zdeterminowany"
					});
				}

				_event.m.Oathtaker.improveMood(1.0, "Podwoila mu sie wiara w Mlodego Anselma");

				if (_event.m.Oathtaker.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Oathtaker.getMoodState()],
						text = _event.m.Oathtaker.getName() + this.Const.MoodStateEvent[_event.m.Oathtaker.getMoodState()]
					});
				}

				this.Characters.push(_event.m.Oathtaker.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "{[img]gfx/ui/events/event_183.png[/img]{Ucichasz %oathtaker% i kazesz mu zamknac plotno namiotu. Biorac czaszke, kladziesz ja na stole i od razu probujesz ja naprawic. Niestety, w chwili gdy twoje dlonie wkladaja jakikolwiek wysilek, pekniecie sie poszerza i odlamki odlatuja nie wiadomo dokad. Puszczasz czaszke, jakby cie oparzyla, a laska Anselma stukajaca pusto o stol. %oathtaker% patrzy na ciebie.%SPEECH_ON%Co teraz? Co mamy zrobic? Moze powinnismy zabrac najlepsza czesc i uciekac, zakladajac nowa bande?%SPEECH_OFF%Z pogarda pytasz glupca, czy bierze cie za Swietobiorce czy Slubodawce. Przelyka i potwierdza to pierwsze. Wlasnie tak, i jesli tak jest, pozostaje tylko jedno: twierdzic, ze Mlody Anselm chcial, aby czaszka pekla, i ze to dowod, jak bardzo %companyname% nie dorasta do bycia prawdziwymi Swietobiorcami. Zgadza sie, a ty pokazujesz reszcie ludzi czaszke i jej nowo powstale kostne pekniecia.\n\nNa poczatku boja sie tego pekniecia, ale wkrotce zgadzaja sie z toba, ze wplyw Mlodego Anselma slabnie nie przez Pierwszego Swietobiorce, lecz dlatego, ze wy wszyscy, ostatni Swietobiorcy, nie dotrzymujecie swoich Slubow! I ze musicie bardziej trzymac sie sciezki prawdziwego Swietobiorcy! Ludzie rycza i wiwatuja, a ich przekonanie odnawia pekniecie Mlodego Anselma.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobra improwizacja.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin")
					{
						bro.worsenMood(0.25, "Przekonany, ze nie dotrzymal slubow tak dobrze, jak powinien");

						if (this.Math.rand(1, 100) <= 33)
						{
							bro.getBaseProperties().Bravery += 1;
							this.List.push({
								id = 16,
								icon = "ui/icons/bravery.png",
								text = _event.m.Oathtaker.getName() + " zyskuje [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Determinacji"
							});
						}

						if (this.Math.rand(1, 100) <= 20 && !bro.getSkills().hasSkill("trait.deathwish"))
						{
							local trait = this.new("scripts/skills/traits/deathwish_trait");
							bro.getSkills().add(trait);
							this.List.push({
								id = 10,
								icon = trait.getIcon(),
								text = bro.getName() + " zyskuje Smiercze Zyczenie"
							});
						}
					}

					bro.improveMood(0.75, "Zostal zmuszony do podwojenia wysilkow w dotrzymywaniu slubow");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}

				this.Characters.push(_event.m.Oathtaker.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.getTime().Days < 40)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local haveSkull = false;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.paladin")
			{
				candidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
			{
				haveSkull = true;
			}
		}

		if (!haveSkull)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.oathtaker_skull_01" || item.getID() == "accessory.oathtaker_skull_02"))
				{
					haveSkull = true;
					break;
				}
			}
		}

		if (!haveSkull)
		{
			return;
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Oathtaker = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5 * candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"oathtaker",
			this.m.Oathtaker.getName()
		]);
	}

	function onClear()
	{
		this.m.Oathtaker = null;
	}

});

