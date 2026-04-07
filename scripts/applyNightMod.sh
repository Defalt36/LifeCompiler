#!/bin/bash
cd ../OneLife
git remote add defalt "https://github.com/Defalt36/TwoLife.git"
git fetch defalt night-mod-new
git cherry-pick c7fffdd9b7957ecefcc835eb5b0b8c516c2ec631
git mergetool

echo -e "Editing Settings...\n"

echo "daylightMode: Defines which behavior the mod will have."
echo -e "daylightMode 0: Disable mod.\ndaylightMode 1: Server controled game time (server have to be compatible)."
echo -e "daylightMode 2: Always midnight.\ndaylightMode 3: Real word based time (timezone.ini based)."
echo -e "daylightMode 4: Night lats 20min. timezone.ini controls hours' offset."
read -rp "New value for daylightMode.ini [default 4]: " v
echo "${v:-4}" > $GAMEDIR/gameSource/settings/daylightMode.ini
echo -e "Done.\n"

echo "nightDarkness: Set how dark the effect will be at peak. 1.0f will be pure black."
read -rp "New value for nightDarkness.ini [default 0.9f]: " v
echo "${v:-0.9f}" > $GAMEDIR/gameSource/settings/nightDarkness.ini
echo -e "Done.\n"

echo "nightFrequency: Set the frequency interval for the night cycles. e.g. set to 36 makes it 40min (24h/36=40 min)"
read -rp "New value for nightFrequency.ini [default 72]: " v
echo "${v:-72}" > $GAMEDIR/gameSource/settings/nightFrequency.ini
echo -e "Done.\n"

echo "nightCurve: This changes the mathematic function that regulates the night intensity throughout the day."
read -rp "New value for nightCurve.ini [default 20]: " v
echo "${v:-20}" > $GAMEDIR/gameSource/settings/nightCurve.ini
echo -e "Done.\n"

echo "timezone: Set your current UTC timezone or GMT offset equivalent."
read -rp "New value for timezone.ini [default 0]: " v
echo "${v:-0}" > $GAMEDIR/gameSource/settings/timezone.ini
echo -e "Done.\n"

echo "maxSources: Maximum light sources."
read -rp "New value for maxSources.ini [default 150]: " v
echo "${v:-150}" > $GAMEDIR/gameSource/settings/maxSources.ini
echo -e "Done.\n"

echo "maxBlockers: Maximum light obstacles."
read -rp "New value for maxBlockers.ini [default 250]: " v
echo "${v:-250}" > $GAMEDIR/gameSource/settings/maxBlockers.ini
echo -e "Done.\n"

echo "Edited INI settings in ${GAMEDIR}. Note the main binary OneLife.exe is unaltered."
