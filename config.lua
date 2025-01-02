Config = {}

----------------------------------------------------
-------- Intervalle in Sekunden --------------------
----------------------------------------------------

-- Wartezeit für Antispam
Config.AntiSpamTimer = 3

-- Überprüfung und Zuweisung eines freien Platzes
Config.TimerCheckPlaces = 3

-- Aktualisierung der Nachricht (Emojis) und Zugriff auf den freien Platz für den Glücklichen
Config.TimerRefreshClient = 3

-- Aktualisierung der Punktzahl
Config.TimerUpdatePoints = 6

----------------------------------------------------
------------ Punkt-Einstellungen -------------------
----------------------------------------------------

-- Anzahl der Punkte, die für wartende Spieler verdient werden
Config.AddPoints = 1

-- Anzahl der Punkte, die für Spieler verloren gehen, die den Server betreten haben
Config.RemovePoints = 1

-- Anzahl der Punkte, die für Spieler verdient werden, die 3 identische Emojis haben (Lotterie)
Config.LoterieBonusPoints = 25

-- Vorrangiger Zugang
Config.Points = {
	-- {'steamID', Punkte},
	-- {'steam:0123456789', 1000}
}

----------------------------------------------------
------------- Nachrichtentexte ---------------------
----------------------------------------------------

-- Wenn Steam nicht erkannt wird
Config.NoSteam = "Steam wurde nicht erkannt. Bitte starte Steam und FiveM (neu) und versuche es erneut."

-- Wartezeit-Text
Config.EnRoute = "Du bist auf dem Weg"

-- "Punkte" für RP-Zwecke
Config.PointsRP = "Kilometer"

-- Position in der Warteschlange
Config.Position = "Du bist in Position "

-- Text vor den Emojis
Config.EmojiMsg = "Wenn die Emojis eingefroren sind, starte FiveM neu: "

-- Wenn der Spieler die Lotterie gewinnt
Config.EmojiBoost = "!!! Juhu, " .. Config.LoterieBonusPoints .. " " .. Config.PointsRP .. " gewonnen !!!"

-- Anti-Spam-Text
Config.PleaseWait_1 = "Bitte warte "
Config.PleaseWait_2 = " Sekunden. Die Verbindung wird automatisch gestartet!"

-- Sollte niemals angezeigt werden
Config.Accident = "Hoppla, Sie hatten gerade einen Unfall ... Wenn es wieder passiert, können Sie den Support informieren :)"

-- Im Falle negativer Punkte
Config.Error = " FEHLER : KONTAKTIERE DEN SUPPORT "

Config.EmojiList = {
	'🐌', 
	'🐍',
	'🐎', 
	'🐑', 
	'🐒',
	'🐘', 
	'🐙', 
	'🐛',
	'🐜',
	'🐝',
	'🐞',
	'🐟',
	'🐠',
	'🐡',
	'🐢',
	'🐤',
	'🐦',
	'🐧',
	'🐩',
	'🐫',
	'🐬',
	'🐲',
	'🐳',
	'🐴',
	'🐅',
	'🐈',
	'🐉',
	'🐋',
	'🐀',
	'🐇',
	'🐏',
	'🐐',
	'🐓',
	'🐕',
	'🐖',
	'🐪',
	'🐆',
	'🐄',
	'🐃',
	'🐂',
	'🐁',
	'🔥'
}
