this.beat_up_old_man_event <- this.inherit("scripts/events/event", {
	m = {
		AggroDude = null
	},
	function create()
	{
		this.m.ID = "event.beat_up_old_man";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 60 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_17.png[/img]{Natrafiasz na starca, który kuśtyka drogą. Opiera się o laskę i czeka na twoje podejście. Ma siwe oczy, ale przechyla głowę, jakby chciał cię zobaczyć uszami.%SPEECH_ON%Dźwięk brzęczących zbroi. Ciężkie kroki. Równe oddechy. Więcej wojowników dla krainy wojny.%SPEECH_OFF%Starzec prostuje się, jakby chciał powiedzieć: \'mam rację?\'. Mówisz mu, że nie przyszedłeś go skrzywdzić.%SPEECH_ON%Więc tak, jak zwykle mam rację. Nie byłoby jednak wielkim problemem przebić mnie na wylot. Słuch mi siada i pewnie kiedy go stracę, to i ja odejdę.%SPEECH_OFF%Zatrzymuje się i odwraca głowę.%SPEECH_ON%Czy coś mówiłeś?%SPEECH_OFF%Zauważasz, że mężczyzna ma ładny, wysadzany pierścień na jednym z kościstych palców. %aggro_bro% przysuwa się do ciebie.%SPEECH_ON%Moglibyśmy go wziąć... wiesz, jak zabranie ciastka dziecku. Naprawdę ślepemu, bardziej bezradnemu niż zwykle dziecku.%SPEECH_OFF% | Stary człowiek z laską opiera się o kamienny mur. Jego dłoń gładzi kamienie znajomym gestem. Patrzy na ciebie, a na jednym z kościstych palców połyskuje wysadzany klejnotami pierścień.%SPEECH_ON%Dobry wieczór, panowie. Piękny dzień, prawda?%SPEECH_OFF%Przyglądając mu się, uświadamiasz sobie, że jest niewidomy. | Podchodzisz do starca stojącego pośrodku drogi, opierającego się o laskę. Wpatruje się w drogowskaz. Kręci głową.%SPEECH_ON%Wiem, że tu jest znak. Jeśli dobrze pamiętam, %randomtown% jest w tamtą stronę.%SPEECH_OFF%Odwraca się do ciebie z uśmiechem. Jego oczy błyszczą na biało, oślepłe ze starości. Na jednym z kościstych palców połyskuje bardzo ładny, bardzo drogi pierścień z klejnotem.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Bezpiecznej drogi, starcze.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Ten wysadzany pierścień. Oddawaj.",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_17.png[/img]{Podchodzisz do mężczyzny. Unosi głowę.%SPEECH_ON%To przyspieszone kroki, nieznajomy, ale nie słyszę dźwięku miecza...%SPEECH_OFF%Gwałtownym pchnięciem przewracasz go na ziemię. Kurczowo trzyma laskę, której koniec skierowany jest w górę, jakbyś miał nadziać się na jej zaokrąglony czubek. Odsuwasz mu rękę kopniakiem i nadeptujesz na nadgarstek, pochylając się po pierścień.%SPEECH_ON%Przebij mi od razu serce, ty bękarcie!%SPEECH_OFF%Odchodzisz od niego i oddajesz mu laskę, pomagając mu nawet wstać.%SPEECH_ON%Bez urazy, starcze.%SPEECH_OFF% | Kopiesz starca, aż upada. Stęka, jakbyś kopnął ciężarną lochę. Odwraca się i trzyma za brzuch, pyta dlaczego, ale ty kopiesz go raz jeszcze, żeby leżał na plecach. Z tej pozycji łatwo zabierasz mu pierścień i odchodzisz. | Starzec cmoka swoimi starymi wargami, wydając ten obrzydliwy, suchy trzask. W odpowiedzi zamachujesz się i uderzasz go pięścią prosto w brzuch. Nie spodziewając się tego, przyjmuje cios w całości, tracąc powietrze z płuc i zwalając się z nóg. Gdy łapie oddech, zabierasz mu pierścień i odchodzisz. | Starzec stoi, opierając się o laskę. Unosi głowę.%SPEECH_ON%Hmm, cisza. Dźwięk złej intencji między obcymi. Ja stoję w mroku, ty w świetle, ale gdzie wkrótce będziemy?%SPEECH_OFF%Wybijasz mu laskę spod ręki i przewraca się na niezdarną kupę, jego kościste ciało zapada się niczym chybotliwa chata. Przewraca się i wygłasza mądrości o przemocy między ludźmi. Kopiesz go w klatkę piersiową i każesz mu się zamknąć. Pierścień z łatwością schodzi z palca i odchodzisz. | Trzaskasz palcami. Starzec odchyla się.%SPEECH_ON%Czyż przemoc nie jest odpowiedzią? Ten świat nie potrzebuje jej więcej.%SPEECH_OFF%Szybkim ciosem kładziesz go na ziemi, a on zwija się w suchym, duszącym się bezwładzie. Zabierając pierścień, odpowiadasz.%SPEECH_ON%Mam gdzieś, czego potrzebuje ten świat, a czego nie. Ja mam swój świat, a ty swój. Po prostu skrzyżowały się drogi, to wszystko. I wiesz co, starcze? Mój świat jest większy.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Takie jest życie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-1);
				local item = this.new("scripts/items/loot/signet_ring_item");
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Zyskujesz " + item.getName()
				});
				this.World.Assets.getStash().add(item);
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getBackground().isOffendedByViolence() && !bro.getBackground().isNoble() || bro.getSkills().hasSkill("trait.bloodthirsty") || bro.getSkills().hasSkill("trait.brute"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.AggroDude = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"aggro_bro",
			this.m.AggroDude.getName()
		]);
	}

	function onClear()
	{
		this.m.AggroDude = null;
	}

});

