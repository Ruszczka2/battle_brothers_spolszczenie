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
			Text = "[img]gfx/ui/events/event_183.png[/img]{%oathtaker% wpada do namiotu z drżącymi dłońmi, trzymając czaszkę Młodego Anselma.%SPEECH_ON%Jest pęknięta!%SPEECH_OFF%Zrywasz się z miejsca i oglądasz święte szczątki Młodego Anselma. Po tyle czaszki biegnie cienka szczelina. Na pierwszy rzut oka nie wygląda to źle, ale gdy wsuwasz mały palec i podnosisz, kości rozchodzą się. Oboje wzdychacie i kładziecie czaszkę na stole. Nie ma wątpliwości, że wystarczy niewiele, by ją rozłamać.%SPEECH_ON%Co mamy zrobić? Jak to naprawić?%SPEECH_OFF%Rozważasz to bardzo ostrożnie. Ostatnim razem, gdy to się stało, odłamała się szczęka Młodego Anselma, a wraz z nią pękli Świętobiorcy - jedna grupa została Świętobiorcami, a druga stała się dzikimi bluźniercami, Ślubodawcami. Nie pozwolisz, by stało się to znowu.}",
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
			Text = "[img]gfx/ui/events/event_183.png[/img]{Wyciągasz kawałek sznurka i pokrywasz go bluszczem oraz żywicą. Potem delikatnie rozchylasz pęknięcie Młodego Anselma i przeciągasz po nim palec z kolejną porcją żywicy. %oathtaker% patrzy nerwowo. Zadowolony, wkładasz sznurek wzdłuż pęknięcia i składasz części czaszki, przyciskając sznurek razem z kleistym bluszczem. Cofasz się i patrzysz na swoje dzieło. %oathtaker% przełyka ślinę.%SPEECH_ON%Ja... ja nie sądzę, żeby ktokolwiek zauważył.%SPEECH_OFF%Zastanawiasz się nawet, czy lepiej byłoby, gdyby znaleziono pęknięcie bez prób naprawy, niż gdyby ktoś zobaczył robotę skradającego się majstra, który próbował coś przemycić. Tak czy inaczej, zrobione - honor Młodego Anselma został przywrócony. %oathtaker% ociera pot z czoła.%SPEECH_ON%Wierzę, że to była próba, kapitanie, i że Młody Anselm nas przez nią przeprowadził. Jego siła przepływa przeze mnie i nie ma słów, które opisałyby zaszczyt, jaki teraz czuję.%SPEECH_OFF%Co? Młody Anselm pewnie nie miał pojęcia o lepkich żywicach i bluszczu, a zapewne wiedział jeszcze mniej teraz, gdy jest niema czaszka. Ale... zostawiasz %oathtaker% jego interpretacjom, choć dla ciebie są one zbyt skromne.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Powinienem być grabarzem.",
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

				_event.m.Oathtaker.improveMood(1.0, "Podwoiła mu się wiara w Młodego Anselma");

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
			Text = "[img]gfx/ui/events/event_183.png[/img]{Ucichasz %oathtaker% i każesz mu zamknąć płótno namiotu. Biorąc czaszkę, kładziesz ją na stole i od razu próbujesz ją naprawić. Niestety, w chwili gdy twoje dłonie wkładają jakikolwiek wysiłek, pęknięcie się poszerza i odłamki odlatują nie wiadomo dokąd. Puszczasz czaszkę, jakby cię oparzyła, a laska Anselma stukająca pusto o stół. %oathtaker% patrzy na ciebie.%SPEECH_ON%Co teraz? Co mamy zrobić? Może powinniśmy zabrać najlepszą część i uciekać, zakładając nową bandę?%SPEECH_OFF%Z pogardą pytasz głupca, czy bierze cię za Świętobiorcę czy Ślubodawcę. Przełyka i potwierdza to pierwsze. Właśnie tak, i jeśli tak jest, pozostaje tylko jedno: twierdzić, że Młody Anselm chciał, aby czaszka pękła, i że to dowód, jak bardzo %companyname% nie dorasta do bycia prawdziwymi Świętobiorcami. Zgadza się, a ty pokazujesz reszcie ludzi czaszkę i jej nowo powstałe kostne pęknięcia.\n\nNa początku boją się tego pęknięcia, ale wkrótce zgadzają się z tobą, że wpływ Młodego Anselma słabnie nie przez Pierwszego Świętobiorcę, lecz dlatego, że wy wszyscy, ostatni Świętobiorcy, nie dotrzymujecie swoich Ślubów! I że musicie bardziej trzymać się ścieżki prawdziwego Świętobiorcy! Ludzie ryczą i wiwatują, a ich przekonanie odnawia pęknięcie Młodego Anselma.}",
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
						bro.worsenMood(0.25, "Przekonany, że nie dotrzymał ślubów tak dobrze, jak powinien");

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
								text = bro.getName() + " zyskuje Śmiercze Życzenie"
							});
						}
					}

					bro.improveMood(0.75, "Został zmuszony do podwojenia wysiłków w dotrzymywaniu ślubów");

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

