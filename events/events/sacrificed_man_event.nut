this.sacrificed_man_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null,
		Other = null,
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.sacrificed_man";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%Dziwny widok: jeden martwy mężczyzna przyszpilony do ziemi włóczniami. Jego własna krew posłużyła do obrysowania zwłok, a inne dziwne rytuały namalowano jego życiodajną posoką. %otherbrother% zaczyna zbierać włócznie. Próbujesz go powstrzymać, ale już za późno. Unosi jedną z broni.%SPEECH_ON%Co? Są dobrej jakości. Czemu mielibyśmy je tu zostawić?%SPEECH_OFF%Cóż, jeśli było tu jakieś boskie zabezpieczenie, już zostało złamane. Zbieracie włócznie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Spoczywaj w pokoju.",
					function getResult( _event )
					{
						if (_event.m.Cultist != null)
						{
							return "Cultist";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/militia_spear");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/weapons/militia_spear");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Cultist",
			Text = "%terrainImage%Zanim odejdziesz, %cultist% pochyla się nad poświęconym mężczyzną i szepcze mu do ucha. Chwilę później głowa martwego mężczyzny szarpie się. Jego oczy się rozszerzają, a nozdrza drgają. Kultysta spogląda na ciebie.%SPEECH_ON%On nie był martwy. Jego krew miała nasycić Davkula. Gdybyśmy potrzebowali jego śmierci, spalilibyśmy go.%SPEECH_OFF%Robi pauzę, zwracając się do mężczyzny, którego rany tajemniczo goją się na twoich oczach jak błoto wypełniające odcisk stopy. %cultist% gładzi go po policzku.%SPEECH_ON%Chodź, przyjacielu, i służ Davkulowi.%SPEECH_OFF%Niepoświęcony mężczyzna zrywa się na nogi i instynktownie zwraca się ku tobie. Jakimś sposobem już wie, że to ty tu dowodzisz, i przyklęka.%SPEECH_ON%Jeśli pozwolisz, będę walczył dla ciebie i tym samym szerzył wiarę Davkula.%SPEECH_OFF%Jego głos brzmi jak automat, jakby przez ostatni rok ćwiczył tę przysięgę.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Witaj więc w %companyname%.",
					function getResult( _event )
					{
						return "Recruit";
					}

				},
				{
					Text = "Naprawdę mi tego nie trzeba. Jesteś zdany na siebie.",
					function getResult( _event )
					{
						return "Deny";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"cultist_background"
				]);
				_event.m.Dude.setTitle("Poświęcony");
				_event.m.Dude.getBackground().m.RawDescription = "Znalazłeś tego człowieka jako ofiarę, lecz powstał z przeznaczenia, by służyć Davkulowi. Poprosił, by walczyć dla ciebie, a ty z jakiegoś powodu się zgodziłeś.";
				_event.m.Dude.getBackground().buildDescription(true);

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Recruit",
			Text = "%terrainImage%Decydujesz się przyjąć mężczyznę. %otherbrother% stoi z boku drogi z parą włóczni w rękach.%SPEECH_ON%Bierzemy je, prawda?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oczywiście, że tak.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Cultist.improveMood(1.0, "Zrekrutowałeś współwyznawcę");

				if (_event.m.Cultist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Deny",
			Text = "%terrainImage%Odmawiasz nawróconemu wyznawcy. Kiwie głową.%SPEECH_ON%Oczywiście. Znajdę inne sposoby, by służyć Davkulowi. Żegnaj, bracie.%SPEECH_OFF%Kłania się %cultist%, po czym odchodzi. %otherbrother% stoi z boku z parą włóczni w rękach.%SPEECH_ON%Bierzemy je, prawda?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oczywiście, że tak.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Cultist.worsenMood(1.0, "Nie udało ci się zrekrutować współwyznawcy");

				if (_event.m.Cultist.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local playerTile = this.World.State.getPlayer().getTile();
		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;

		foreach( t in towns )
		{
			local d = playerTile.getDistanceTo(t.getTile());

			if (d >= 6 && d <= 12)
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_cultist = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				candidates_cultist.push(bro);
			}
			else if (bro.getBackground().getID() != "background.slave")
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		if (candidates_cultist.len() != 0)
		{
			this.m.Cultist = candidates_cultist[this.Math.rand(0, candidates_cultist.len() - 1)];
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		this.m.Score = 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other.getName()
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
		this.m.Other = null;
		this.m.Dude = null;
	}

});

