::mods_hookBaseClass("skills/injury_permanent/permanent_injury", function ( o )
{
	while (!("addTooltipHint" in o))
	{
		o = o[o.SuperName];
	}

	o.addTooltipHint = function ( _tooltip )
	{
		_tooltip.push({
			id = 6,
			type = "hint",
			icon = "ui/icons/days_wounded.png",
			text = "Na Stałe"
		});
	};
});
::mods_hookBaseClass("skills/injury/injury", function ( o )
{
	while (!("addTooltipHint" in o))
	{
		o = o[o.SuperName];
	}

	o.getName = function ()
	{
		return this.m.IsTreated ? this.m.Name + " (Opatrzona)" : this.m.Name;
	};
	o.addTooltipHint = function ( _tooltip )
	{
		if (this.m.IsContentWithReserve)
		{
			_tooltip.push({
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Na razie nie przeszkadza mu bycie w rezerwie"
			});
		}

		if (this.m.IsFresh && !this.m.IsAlwaysInEffect && !this.getContainer().getActor().getCurrentProperties().IsAffectedByFreshInjuries && this.m.IsHealingMentioned)
		{
			_tooltip.push({
				id = 7,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Będzie odczuwalna dopiero po zakończeniu walki dzięki Żelaznej Woli"
			});
		}

		if (!this.m.IsAlwaysInEffect && !this.getContainer().getActor().getCurrentProperties().IsAffectedByInjuries && this.m.IsHealingMentioned)
		{
			if (("State" in this.Tactical) && this.Tactical.State != null)
			{
				_tooltip.push({
					id = 7,
					type = "text",
					icon = "ui/icons/warning.png",
					text = "Będzie odczuwalna dopiero po zakończeniu walki dzięki Żelaznej Woli"
				});
			}
			else
			{
				_tooltip.push({
					id = 7,
					type = "text",
					icon = "ui/icons/warning.png",
					text = "Będzie znów odczuwalna dopiero po zakończeniu walki dzięki Żelaznej Woli"
				});
			}
		}

		if (("State" in this.World) && this.World.State != null && this.World.Assets.getMedicine() <= 0 && this.m.IsHealingMentioned)
		{
			_tooltip.push({
				id = 7,
				type = "hint",
				icon = "ui/icons/warning.png",
				text = "Nie wyleczy się, gdyż nie masz medykamentów"
			});
		}
		else
		{
			local ht = this.getHealingTime();
			local d;

			if (this.m.IsHealingMentioned)
			{
				if (ht.Max > 1 && ht.Min == ht.Max)
				{
					d = "Wyleczy się za " + ht.Min + " dni";
				}
				else if (ht.Max > 1)
				{
					d = "Wyleczy się za " + ht.Min + " do " + ht.Max + " dni";
				}
				else
				{
					d = "Wyleczy się do jutra";
				}

				_tooltip.push({
					id = 6,
					type = "hint",
					icon = "ui/icons/days_wounded.png",
					text = d
				});
			}
			else
			{
				if (ht.Max > 1 && ht.Min == ht.Max)
				{
					d = "Minie za " + ht.Min + " dni";
				}
				else if (ht.Max > 1)
				{
					d = "Minie za " + ht.Min + " do " + ht.Max + " dni";
				}
				else
				{
					d = "Przejdzie do jutra";
				}

				_tooltip.push({
					id = 6,
					type = "hint",
					icon = "ui/icons/action_points.png",
					text = d
				});
			}
		}
	};
});

