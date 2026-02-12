this.fangshire <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.fangshire";
		this.m.Name = "Fangshire";
		this.m.Description = "Fangshire to czaszka północnego tygrysa, która gnieździe twarz ludzi głęboko i mrocznie za dwoma ostrymi kłami. Początkowo noszona przez Bjarunda Bestię, zaciekłego północnego najeźdźcę, napawała strachem serca jego wrogów, gdy wyruszał na krwawe napady i spalił wiele wiosek wzdłuż wybrzeża. Kiedy Bjarunda w końcu ubito, Fangshire został zabrany jako trofeum i trafił dalej na południe. Plotki głoszą, że oczy noszącej go osoby błyszczą ostrym żółtym światłem, pozwalając doskonale widzieć w nocy.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.IsIndestructible = true;
		this.m.Variant = 24;
		this.updateVariant();
		this.m.ImpactSound = [
			"sounds/enemies/skeleton_hurt_03.wav"
		];
		this.m.Value = 300;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = -5;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Pozwala niosącej go osobie widzieć w nocy i neguje wszystkie nocne kary."
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.IsAffectedByNight = false;
	}

});

