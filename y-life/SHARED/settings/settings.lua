-- #######################################
-- ## Project: MTA Your-Life    	    ##
-- ## Name: Settings			     	##
-- ## Author: StiviK					##
-- ## Version: 1.0						##
-- #######################################

-- Usefull
ABCTable = {
	[1] = "A",
	[2] = "B",
	[3] = "C",
	[4] = "D",
	[5] = "E",
	[6] = "F",
	[7] = "G",
	[8] = "H",
	[9] = "I",
	[10] = "J",
	[11] = "K",
	[12] = "L",
	[13] = "M",
	[14] = "N",
	[15] = "O",
	[16] = "P",
	[17] = "Q",
	[18] = "R",
	[19] = "S",
	[20] = "T",
	[21] = "U",
	[22] = "V",
	[23] = "W",
	[24] = "X",
	[25] = "Y",
	[26] = "Z"
}

NumTable = {
	[1] = 1,
	[2] = 2,
	[3] = 3,
	[4] = 4,
	[5] = 5,
	[6] = 6,
	[7] = 7,
	[8] = 8,
	[9] = 9,
	[10] = 0
}



-- All Vehicle
validVehicles = { 602, 545, 496, 517, 401, 410, 518, 600, 527, 436, 589, 580, 419, 439, 533, 549, 526, 491, 474, 445, 467, 604, 426, 507, 547, 585,
405, 587, 409, 466, 550, 492, 566, 546, 540, 551, 421, 516, 529, 592, 553, 577, 488, 511, 497, 548, 563, 512, 476, 593, 447, 425, 519, 520, 460,
417, 469, 487, 513, 581, 510, 509, 522, 481, 461, 462, 448, 521, 468, 463, 586, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 485, 552, 431, 
438, 437, 574, 420, 525, 408, 416, 596, 433, 597, 427, 599, 490, 432, 528, 601, 407, 428, 544, 523, 470, 598, 499, 588, 609, 403, 498, 514, 524, 
423, 532, 414, 578, 443, 486, 515, 406, 531, 573, 456, 455, 459, 543, 422, 583, 482, 478, 605, 554, 530, 418, 572, 582, 413, 440, 536, 575, 534, 
567, 535, 576, 412, 402, 542, 603, 475, 449, 537, 538, 441, 464, 501, 465, 564, 568, 557, 424, 471, 504, 495, 457, 539, 483, 508, 571, 500, 
444, 556, 429, 411, 541, 559, 415, 561, 480, 560, 562, 506, 565, 451, 434, 558, 494, 555, 502, 477, 503, 579, 400, 404, 489, 505, 479, 442, 458, 
606, 607, 610, 590, 569, 611, 584, 608, 435, 450, 591, 594 }

function isValidVehicle (model)
	for i, v in pairs(validVehicles) do
		if (v == model) then
			return true;
		elseif (i == #validVehicles) then
			return false;
		end
	end
end



-- Spawn Text Settings
spawnText = {
	["register"] = {
		[1] = "Herzlich Willkommen, {PLAYER}!\n\nWir wünschen dir auf dem Server viel Spaß!"
	},
	["street"] = {
		[1] = "Willkommen, {PLAYER}!\n\nDu hattest eine kalte und\nUngemütliche Nacht...\n\nDu musst dir schnellstens eine Wohnung\nsuchen!",
		[2] = "Guten {TIMENAME}, {PLAYER}!"
	},
	["faction"] = {
		[1] = "Not implemented yet!"
	},
	["apartment"] = {
		[1] = "Not implemented yet!"
	},
	["house"] = {
		[1] = "Not implemented yet!"
	},
	["hotel"] = {
		[1] = "Not implemented yet!"
	},
	["jail"] = {
		[1] = "Guten {TIMENAME}, {PLAYER}!\n\nDu sitzt noch für {JAILTIME}\nim Gefängnis!"
	}
}


-- Fraktion's Settings
validFactionID = {
	[0] = true, -- Zivilist
	[1] = true -- Spedition
}

-- DO NOT EDIT THESE TABLES \\
factionMembers = {}
onlineFactionMembers = {}
--factionDBVehicles = {}
factionVehicles = {}

for id, _ in pairs(validFactionID) do
	factionMembers[id] = {}
	onlineFactionMembers[id] = {}
	--factionDBVehicles[id] = {}
	factionVehicles[id] = {}
end
-- BAD THINGS WILL HAPPEN //

StateFactions = {}

EvilFactions = {}

NeutralFactions = {}

factionNames = {
	[0] = "Zivilist",
	[1] = "Spediton"
}

factionRanks = {
	[0] = {
		[-1] = ""
	},
	[1] = {
		[0] = "", -- Leader
		[1] = "", -- Lowest Rank
		[2] = "",
		[3] = ""
	}
}

factionSquads = {
	[1] = {
		["alpha"] = {},
		["beta"] = {},
		["gamma"] = {},
		["delta"] = {}
	}
}

factionColors = {
	[0] = {r = 255, g = 255, b = 255},
	[1] = {r = 125, g = 125, b = 125}
}

factionDutyWeapons = { -- Works only with the Police Faction
	--[[
	[FactionID] = {
		[RANK] = {
			[Count: 1] = {weaponid, ammo},
			[Count: 2] = {weaponid, ammo}
		}
	}
	--]]

	[1] = {
		[1] = {
			[1] = {23, 10}
		},
		[2] = {
			[1] = {23, 20},
			[2] = {27, 20}
		},
		[3] = {
			[1] = {23, 30},
			[2] = {27, 30},
			[3] = {35, 30}
		},
		[0] = {
			[1] = {23, 100},
			[2] = {27, 100},
			[3] = {35, 100},
			[4] = {31, 100}
		},
	}
}

factionSkins = {
	[1] = {
		[1] = 280,
		[2] = 281,
		[3] = 282,
		[4] = 283,
		[5] = 284,
		[6] = 288,
	}
}

factionSpawns = {
	[1] = {x = 261.27213, y = 71.15079, z = 1003.24219, rot = -90, int = 6}
}



-- Newbie Settings
Skins =	{
	[1] = 89, 
	[2] = 128, 
	[3] = 129, 
	[4] = 134, 
	[5] = 135, 
	[6] = 136, 
	[7] = 137
}

spawnPoints = { 
	["street"] = {x = 1476.09241, y = -1687.03833, z = 14.04688, rot = 0}
}