this.kings_guard_1_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.kings_guard_1";
		this.m.Title = "Na drodze...";
		this.m.Cooldown = 9999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Śnieżne pustkowia niewiele mają do zaoferowania, więc znalezienie półnagiego człowieka w tym mrozie jest dość niezwykłe. To, że w ogóle żyje, jeszcze bardziej. Przykucasz obok niego. Ma puste oczy, a szron utrudnia ich mruganie. Wargi ma poszarpane i purpurowe. Nos - głęboko czerwony, na granicy czerni. Pytasz, czy potrafi mówić. Kiwnięciem głowy odpowiada.%SPEECH_ON%Barbarzyńcy. Wzięli. Mnie.%SPEECH_OFF%Pytasz, gdzie są porywacze. Wzrusza ramionami i kontynuuje w lodowatym rytmie.%SPEECH_ON%Znudziło. Im. Się. I. Odeszli.%SPEECH_OFF%To pasuje do prymitywów, by porzucić więźnia w lodzie. Wyjaśnia, że był niegdyś krzepkim szermierzem. Uśmiech przeciska się przez ból.%SPEECH_ON%Gwardia. Królewska. W. Krainie. Bez. Króla. Mogło. Być. Gorzej?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Mamy dla ciebie miejsce, przyjacielu.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "W tym świecie jesteś zdany na siebie.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"cripple_background"
				], false);
				_event.m.Dude.setTitle("");
				_event.m.Dude.getBackground().m.RawDescription = "Znalazłeś %name% na północy, zamarzniętego na pół śmierci. Twierdzi, że kiedyś był w Gwardii Królewskiej, ale teraz widzisz tylko kalekę.";
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.getFlags().set("IsSpecial", true);
				_event.m.Dude.getBaseProperties().Bravery += 15;
				_event.m.Dude.getSkills().update();
				_event.m.Dude.m.PerkPoints = 2;
				_event.m.Dude.m.LevelUps = 2;
				_event.m.Dude.m.Level = 3;
				_event.m.Dude.m.XP = this.Const.LevelXP[_event.m.Dude.m.Level - 1];
				_event.m.Dude.m.Talents = [];
				local talents = _event.m.Dude.getTalents();
				talents.resize(this.Const.Attributes.COUNT, 0);
				talents[this.Const.Attributes.MeleeSkill] = 2;
				talents[this.Const.Attributes.MeleeDefense] = 3;
				talents[this.Const.Attributes.RangedDefense] = 3;
				_event.m.Dude.m.Attributes = [];
				_event.m.Dude.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(1.5, "Został porwany przez barbarzyńców i pozostawiony na śmierć w zimnie");
				_event.m.Dude.getFlags().set("IsKingsGuard", true);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{Poklepujesz mężczyznę po głowie, ale mówisz, że to już koniec. Kiwając głową, odpowiada.%SPEECH_ON%Mów. Za. Siebie. Najemniku.%SPEECH_OFF%Uśmiecha się ponownie, ale tym razem uśmiech nie odpuszcza. Przymarza. Dosłownie. Pochyla się do przodu, oczy ma otwarte i nie mruga, i w takim stanie odchodzi. Ruszasz z ludźmi z powrotem na drogę, o ile można tak nazwać te zaśnieżone trakty.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To już dla ciebie koniec.",
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
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{Prawie zamarznięty mężczyzna dołącza do kompanii. Jest zniszczoną kupą nieszczęścia, ale jeśli mówił prawdę, może kiedyś stanie się wojownikiem, o którym ledwo potrafił mówić.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Zobaczymy.",
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
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Snow)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

