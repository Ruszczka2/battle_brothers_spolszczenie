this.how_far_is_the_sun_event <- this.inherit("scripts/events/event", {
	m = {
		Historian = null,
		Monk = null,
		Cultist = null,
		Archer = null,
		Other = null
	},
	function create()
	{
		this.m.ID = "event.how_far_is_the_sun";
		this.m.Title = "W obozie...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]Podczas odpoczynku ludzie zaczynają rozmowę o tym, jak daleko jest słońce. %otherbrother% spogląda w górę, krzywiąc się i zaciskając zęby, niemal oślepiając się przy tych pomiarach. W końcu opuszcza wzrok.%SPEECH_ON%Założyłbym się, że to jakieś dziesięć do piętnastu mil.%SPEECH_OFF%Kiwa głową na własne, zapewne trafne podsumowanie.%SPEECH_ON%Ano, pewnie nawet nie tak daleko. Słyszałem opowieść o łuczniku z dalekiej krainy, który trafił je strzałą.%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				if (_event.m.Historian != null)
				{
					this.Options.push({
						Text = "%historianfull%, co masz do powiedzenia?",
						function getResult( _event )
						{
							return "Historian";
						}

					});
				}

				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Założę się, że %monkfull% zna prawdę.",
						function getResult( _event )
						{
							return "Monk";
						}

					});
				}

				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "Widzę, że myślisz, %cultistfull%. Co powiesz?",
						function getResult( _event )
						{
							return "Cultist";
						}

					});
				}

				if (_event.m.Archer != null)
				{
					this.Options.push({
						Text = "%archerfull%, może spróbujesz strzału?",
						function getResult( _event )
						{
							return "Archer";
						}

					});
				}

				this.Options.push({
					Text = "Dość gadania o gwiazdach. Wracamy na drogę.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "Historian",
			Text = "[img]gfx/ui/events/event_05.png[/img]%historian%, historyk, włącza się do rozmowy.%SPEECH_ON%Wątpię w wiarygodność tej opowieści o trafieniu go łukiem. Znam znacznie bardziej prawdziwą historię: na wschodnich górach są ludzie, którzy mają wielkie lunety, by wpatrywać się w nocne niebo. Uważają, że słońce jest bardzo daleko. Co najmniej dziesięć tysięcy mil. Uważają też, że nocne światła to inne słońca, a nie dusze zmarłych bohaterów.%SPEECH_OFF%%otherbrother% podnosi się.%SPEECH_ON%Pilnuj języka, głupcze, i nie mów źle o naszych przodkach.%SPEECH_OFF%Historyk kiwa głową.%SPEECH_ON%Oczywiście! To była tylko myśl.%SPEECH_OFF%Co za bzdury. Jak na rzekomo mądrego człowieka, %historian% gada straszne głupoty. Kilku braci śmieje się z jego niedorzecznych pomysłów.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ale z niego ubaw.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Historian.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Historian.getID() || bro.getBackground().getID() == "background.historian" || bro.getSkills().hasSkill("trait.bright"))
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Entertained by " + _event.m.Historian.getName() + "\'s silly notions about the sun");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
			ID = "Monk",
			Text = "[img]gfx/ui/events/event_05.png[/img]%monk%, mnich, włącza się do rozmowy.%SPEECH_ON%Słońce nie jest ani daleko, ani blisko. To oko wielu bogów, przez które spoglądają na nas.%SPEECH_OFF%%otherbrother% kiwa głową, lecz potem, ciekaw, pyta o księżyc. Mnich uśmiecha się z pewnością.%SPEECH_ON%Czy myślisz, że bogowie świeciliby na nas przez wszystkie godziny? Oczywiście, że przyciemniają światła, aby dać nam, śmiertelnym, miłą noc do spania.%SPEECH_OFF%Kiwasz głową. Zaprawdę starzy bogowie zawsze nad nami czuwają.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech będą błogosławieni.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getEthnicity() == 1 || bro.getID() == _event.m.Monk.getID() || bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist" || bro.getBackground().getID() == "background.historian")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Encouraged by " + _event.m.Monk.getName() + "\'s preaching");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
			ID = "Cultist",
			Text = "[img]gfx/ui/events/event_05.png[/img]%cultist%, kultysta, wstaje i spogląda na słońce. Gdy wciąż się w nie wpatruje, na jego twarzy powoli pojawia się cień, jakby jakaś istota osłaniała go od światła. Nagle unosi rękę i zaczyna kreślić nią powietrzne rytuały. Przysięgasz, że ciemność na jego twarzy porusza się jak odcisk tych rysunków, niczym zmienny tatuaż. Gdy kończy, siada.%SPEECH_ON%Słońce umiera.%SPEECH_OFF%Ludzie wyglądają na zaniepokojonych. Jeden wtrąca.%SPEECH_ON%Umiera? Co masz na myśli?%SPEECH_OFF%%cultist% patrzy na niego.%SPEECH_ON%Davkul chce, by wszyscy umarli.%SPEECH_OFF%Jeden z mężczyzn pyta, czy ten rzekomy Davkul też umrze. Kultysta kiwa głową.%SPEECH_ON%Kiedy nie będzie już nic do umierania, Davkul wreszcie spocznie. Okrutniejszy bóg już by odszedł. To z łaski Davkula odejdzie jako ostatni, i za to go chwalimy.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eee, jasne.",
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
					if (bro.getID() == _event.m.Cultist.getID())
					{
						bro.improveMood(1.0, "Relished the opportunity to talk about the dying sun");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().getID() == "background.cultist")
					{
						bro.improveMood(0.5, "Relished " + _event.m.Cultist.getName() + "\'s speech about the dying sun");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getEthnicity() == 1)
					{
						bro.worsenMood(1.0, "Angry about the heretical ramblings of " + _event.m.Cultist.getName());

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getSkills().hasSkill("trait.superstitious") || bro.getSkills().hasSkill("trait.mad"))
					{
						bro.worsenMood(1.0, "Terrified at the prospect of a dying sun");

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
			ID = "Archer",
			Text = "[img]gfx/ui/events/event_05.png[/img]%archer% podejmuje wyzwanie, chwytając łuk i kilka strzał. Oblizuje palec i unosi go.%SPEECH_ON%Wiatr dobry na strzelanie do gwiazd.%SPEECH_OFF%Łucznik osadza strzałę, naciąga cięciwę i celuje. Oślepiające światło natychmiast go razi.%SPEECH_ON%Cholera, nic nie widzę.%SPEECH_OFF%Jego celowanie chwieje się, gdy ciemne plamy zalewają mu wzrok. Strzała zostaje wypuszczona i mija słońce. I to bardzo. Patrzy na kompanię, zgaszonym wzrokiem i wyciągniętymi dłońmi, próbując się uspokoić, gdy wzrok wraca.%SPEECH_ON%Trafiłem?%SPEECH_OFF%%otherbrother% ukrywa chichot.%SPEECH_ON%W samo sedno!%SPEECH_OFF%Ludzie wybuchają śmiechem.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dobry strzał, panie!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Archer.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Entertained by " + _event.m.Archer.getName() + "\'s attempt to shoot the sun");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
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
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidate_historian = [];
		local candidate_monk = [];
		local candidate_cultist = [];
		local candidate_archer = [];
		local candidate_other = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.historian")
			{
				candidate_historian.push(bro);
			}
			else if (bro.getBackground().getID() == "background.monk")
			{
				candidate_monk.push(bro);
			}
			else if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				candidate_cultist.push(bro);
			}
			else if (bro.getBackground().getID() == "background.hunter" || bro.getBackground().getID() == "background.poacher" || bro.getBackground().getID() == "background.sellsword")
			{
				candidate_archer.push(bro);
			}
			else if (bro.getEthnicity() != 1 && bro.getBackground().getID() != "background.slave")
			{
				candidate_other.push(bro);
			}
		}

		if (candidate_other.len() == 0)
		{
			return;
		}

		local options = 0;

		if (candidate_historian.len() != 0)
		{
			options = ++options;
		}

		if (candidate_monk.len() != 0)
		{
			options = ++options;
		}

		if (candidate_cultist.len() != 0)
		{
			options = ++options;
		}

		if (candidate_archer.len() != 0)
		{
			options = ++options;
		}

		if (options < 2)
		{
			return;
		}

		if (candidate_historian.len() != 0)
		{
			this.m.Historian = candidate_historian[this.Math.rand(0, candidate_historian.len() - 1)];
		}

		if (candidate_monk.len() != 0)
		{
			this.m.Monk = candidate_monk[this.Math.rand(0, candidate_monk.len() - 1)];
		}

		if (candidate_cultist.len() != 0)
		{
			this.m.Cultist = candidate_cultist[this.Math.rand(0, candidate_cultist.len() - 1)];
		}

		if (candidate_archer.len() != 0)
		{
			this.m.Archer = candidate_archer[this.Math.rand(0, candidate_archer.len() - 1)];
		}

		this.m.Other = candidate_other[this.Math.rand(0, candidate_other.len() - 1)];
		this.m.Score = options * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getNameOnly() : ""
		]);
		_vars.push([
			"historianfull",
			this.m.Historian != null ? this.m.Historian.getName() : ""
		]);
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
		_vars.push([
			"monkfull",
			this.m.Monk != null ? this.m.Monk.getName() : ""
		]);
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"cultistfull",
			this.m.Cultist != null ? this.m.Cultist.getName() : ""
		]);
		_vars.push([
			"archer",
			this.m.Archer != null ? this.m.Archer.getNameOnly() : ""
		]);
		_vars.push([
			"archerfull",
			this.m.Archer != null ? this.m.Archer.getName() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Historian = null;
		this.m.Monk = null;
		this.m.Cultist = null;
		this.m.Archer = null;
		this.m.Other = null;
	}

});

