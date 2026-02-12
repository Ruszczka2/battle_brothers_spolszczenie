this.wardogs_fight_each_other_event <- this.inherit("scripts/events/event", {
	m = {
		Houndmaster = null,
		Otherbrother = null,
		Wardog1 = null,
		Wardog2 = null
	},
	function create()
	{
		this.m.ID = "event.wardogs_fight_each_other";
		this.m.Title = "Podczas obozu...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_37.png[/img]Seria szczeknięć, po której następuje przytłumione warczenie, przerywa twoją pracę. Wychodzisz z namiotu i widzisz, że dwa psy bojowe, %randomwardog1% i %randomwardog2%, walczą. Zacisnęły szczęki na karkach siebie nawzajem. Kilku braci próbuje interweniować, ale za każdym razem psy na chwilę się rozdzielają i kłapią na ludzi, jakby mówiły, że ta walka jest między nimi i tylko nimi.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Niech psy same to rozstrzygną.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Niech ktoś rozdzieli psy!",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Houndmaster != null)
				{
					this.Options.push({
						Text = "%houndmaster%, jesteś treserem psów, zajmij się tym!",
						function getResult( _event )
						{
							return "I";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_37.png[/img]Postanawiasz się cofnąć i pozwolić naturze zrobić swoje. Gdy kurz opada, podchodzisz, by zobaczyć, jak się to skończyło.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I co?",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 20)
						{
							return "E";
						}
						else if (r <= 35)
						{
							return "F";
						}
						else
						{
							return "G";
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_37.png[/img]Krzyczysz na %otherbrother%, by rozdzielił dwa psy bojowe. Bierze długi kij i opuszcza go w futrzaną, wściekłą kotłowaninę. Psy piszczą, gdy metal wchodzi między nie. Jeden chwyta kij i szarpie go, wciągając brata w sam środek walki. Człowiek i bestie mieszają się, gdy cała trójka walczy o własne przetrwanie, na zmianę odpierając ataki. Gdy kurz opada, sprawdzasz, kto lub co jeszcze stoi.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "I co?",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 10)
						{
							return "E";
						}
						else if (r <= 50)
						{
							return "F";
						}
						else if (r <= 90)
						{
							return "G";
						}
						else
						{
							return "H";
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Otherbrother.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_37.png[/img]Niestety oba psy padły. Zginęły z zakrwawionym futrem zaciśniętym w szczękach, każde dzieląc w sobie i zwycięstwo, i porażkę. Każesz %randombrother% zakopać ciała, by zapach nie przyciągnął jeszcze bardziej wściekłych bestii.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Biedne bestie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog1.getIcon(),
					text = "Tracisz " + _event.m.Wardog1.getName()
				});
				this.World.Assets.getStash().remove(_event.m.Wardog1);
				_event.m.Wardog1 = null;
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog2.getIcon(),
					text = "Tracisz " + _event.m.Wardog2.getName()
				});
				this.World.Assets.getStash().remove(_event.m.Wardog2);
				_event.m.Wardog2 = null;
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_27.png[/img]Po bitwie każesz %randombrother% obejrzeć psy bojowe. Warczą, gdy podchodzi, ale to wszystko, na co je stać, bo walka wybiła z nich cały ogień. Zgłasza kilka wybitych zębów i to, że każdy trochę utyka, ale nie są kulawe. Z czasem będą jak nowe do walki. Oby tylko nie ze sobą...",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Taka ich natura.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_37.png[/img]Jeden pies bojowy odchodzi z potyczki, kulejąc i zostawiając martwego kundla. To, że zwycięzca nawet nie zjadł ani nie próbował zjeść przegranego, mówi wszystko o pochodzeniu nazwy tych zwierząt. Każesz %randombrother% zająć się ocalałym, a kilku innych braci grzebie ciało poległego.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Biedna bestia.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List.push({
					id = 10,
					icon = "ui/items/" + _event.m.Wardog1.getIcon(),
					text = "Tracisz " + _event.m.Wardog1.getName()
				});
				this.World.Assets.getStash().remove(_event.m.Wardog1);
				_event.m.Wardog1 = null;
			}

		});
		this.m.Screens.push({
			ID = "H",
			Text = "[img]gfx/ui/events/event_34.png[/img]%otherbrother% zdołał rozdzielić dwa psy bojowe, zanim się pozabijały. Niestety zapłacił za to wysoką cenę, pełną ugryzień i zadrapań. Przeżyje, ale nie sposób nie zauważyć, że teraz jest bardzo nerwowy i boi się psów.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To naprawdę zaciekłe bestie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Otherbrother.getImagePath());
				local injury = _event.m.Otherbrother.addInjury(this.Const.Injury.DogBrawl);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Otherbrother.getName() + " doznaje " + injury.getNameOnly()
				});
			}

		});
		this.m.Screens.push({
			ID = "I",
			Text = "[img]gfx/ui/events/event_27.png[/img]Rozkazujesz %houndmaster%, treserowi psów, by coś zrobił. Kiwając głową, podchodzi spokojnie między dwa walczące psy. Szczekają i kłapią na siebie, ale oba zatrzymują się, przyglądając się nadchodzącemu mężczyźnie. Jeden warczy, ale w końcu siada. Drugi cofa się, ogon ma rozwścieczony, ale w oczach wciąż tli się ogień. Treser kuca i głaszcze oba psy po głowach. Jeden kundel kładzie się, a drugi robi to samo.\n\n Mężczyzna powoli zbliża psy do siebie, niemal dotykają się nosami, po czym szepcze coś do obu. Powoli, ale pewnie, bestialna energia opuszcza psy, a ich łagodniejsze usposobienie bardziej pasuje do pilnowania dzieci niż do walki w bandzie najemników. Treser wstaje, a psy radośnie podążają za nim. Kiwając głową, mówi:%SPEECH_ON%Tylko mała sprzeczka między psami, hehe.%SPEECH_OFF%Odchodzi, a reszta kompanii patrzy z rozdziawionymi ustami, jakby właśnie oglądali jakiś pochód druidycznej magii.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prawdziwy mistrz rzemiosła.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_houndmaster = [];
		local candidates_other = [];
		local candidates_wardog = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.houndmaster")
			{
				candidates_houndmaster.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		local stash = this.World.Assets.getStash().getItems();

		foreach( item in stash )
		{
			if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
			{
				candidates_wardog.push(item);
			}
		}

		if (candidates_wardog.len() < 2)
		{
			return;
		}

		this.m.Otherbrother = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_houndmaster.len() != 0)
		{
			this.m.Houndmaster = candidates_houndmaster[this.Math.rand(0, candidates_houndmaster.len() - 1)];
		}

		local r = this.Math.rand(0, candidates_wardog.len() - 1);
		this.m.Wardog1 = candidates_wardog[r];
		candidates_wardog.remove(r);
		r = this.Math.rand(0, candidates_wardog.len() - 1);
		this.m.Wardog2 = candidates_wardog[r];
		this.m.Score = candidates_wardog.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"otherbrother",
			this.m.Otherbrother.getName()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster != null ? this.m.Houndmaster.getNameOnly() : ""
		]);
		_vars.push([
			"randomwardog1",
			this.m.Wardog1 != null ? this.m.Wardog1.getName() : ""
		]);
		_vars.push([
			"randomwardog2",
			this.m.Wardog2 != null ? this.m.Wardog2.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Houndmaster = null;
		this.m.Otherbrother = null;
		this.m.Wardog1 = null;
		this.m.Wardog2 = null;
	}

});

