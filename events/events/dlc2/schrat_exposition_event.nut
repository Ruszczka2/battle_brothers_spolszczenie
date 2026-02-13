this.schrat_exposition_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.schrat_exposition";
		this.m.Title = "W drodze...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Na drodze spotykasz młodego wędrowca. Jego słomiany kapelusz jest wywinięty na lewą stronę, jakby miał łapać deszcz. Ma laskę z końcem startym na kulkę, by pomagała w błotnistych drogach. Gdy się zbliżasz, prostuje się i opiera dłonie na szczycie kija.%SPEECH_ON%Ej, wy najemnicy? Ja bym omijał lasy, gdybym był wami. Mówią, że drzewa teraz tam chodzą. Nie zagrażają złośliwie, ale i niedźwiedzica nie robi tego ze złości, gdy odgryza wam jaja za zbytnie zbliżenie. To sprawa natury, wiecie?%SPEECH_OFF%Eee, jasne. | Przy drodze znajduje się mężczyzna, który czyta jakieś tomy. Spogląda w górę, odwraca jedną stronę, byś zobaczył rysunek drzewa z długimi gałęziami sięgającymi ziemi. Pień jest usiany oczami.%SPEECH_ON%Nazywają je schratami. Drzewa, które drapią i zabijają wszystko, co się zbliży, ale nie sądzę, że to do końca trafne. Nie sądzę, że to zwierzęta, myślę, że to wyrachowane i sprytne potwory z mściwym podejściem do wtargnięć. Więc na nie nie wchodźcie, rozumiecie? Trzymajcie się z dala od lasów.%SPEECH_OFF%Nie mając nastroju na pogawędki o drzewach, życzysz mu powodzenia w naukach i szybko idziesz dalej. | Starsza kobieta niosąca kosz mija się z twoją kompanią. Wskazuje na towar, stos pociętego drewna na opał.%SPEECH_ON%Jak chcecie trochę drewna, hej, lepiej trzymajcie się z daleka od miejsca, skąd je wzięłam.%SPEECH_OFF%Pytasz, co ma na myśli. Uśmiecha się chytrze.%SPEECH_ON%Schrat w lesie patrzył, jak to robię, dał mi porządną zgodę, by ogrzać się tym tutaj podpałkiem. Mojemu wujkowi nie dał. Rozerwał go na pół i powiesił jego mięso. Może dla ozdoby, wiecie?%SPEECH_OFF%Eee, oczywiście.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Takiego wroga nie wolno lekceważyć.",
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type == this.Const.World.TerrainType.Desert || currentTile.Type == this.Const.World.TerrainType.Oasis || currentTile.TacticalType == this.Const.World.TerrainTacticalType.DesertHills)
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
	}

});

