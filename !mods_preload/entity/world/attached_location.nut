::mods_hookBaseClass("entity/world/attached_location", function ( o )
{
	while (!("getDescription" in o))
	{
		o = o[o.SuperName];
	}

	o.getName = function ()
	{
		return this.m.IsActive ? this.world_entity.getName() : "Ruiny";
	};
	o.getDescription = function ()
	{
		if (this.m.IsActive)
		{
			return this.world_entity.getDescription();
		}
		else
		{
			return "W miejscu, gdzie niegdyś była część pobliskiej osady, teraz stoją spalone i opuszczone ruiny.";
		}
	};
});

