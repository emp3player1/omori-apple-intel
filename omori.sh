#!/bin/sh

echo ""
echo "/-------------------------------------------\\"
echo "|     - OMORI PATCH TOOL FOR INTEL -        |"
echo "|             by Snowp and ynx0             |"
echo "|                                           |"
echo "| github.com/SnowpMakes/omori-apple-silicon |"
echo "|             https://snowp.io              |"
echo "\\-------------------------------------------/"
echo ""

OMORI=~/Library/Application\ Support/Steam/steamapps/common/OMORI

if [ ! -d "${OMORI}" ]; then
  echo "[!!] Please make sure you have Omori installed on steam before using this tool.";
  exit 1;
fi;

echo "Backing up original Omori.app.."
if [ -f "${OMORI}.original" ]; then
  rm -rf "${OMORI}.original"
fi;
cp -r "${OMORI}" "${OMORI}.original";

TMPFOLDER=$(mktemp -d /tmp/omori-patch.XXXXXX) || exit 1
cd "$TMPFOLDER";

mv "${OMORI}" "./Omori.original.app";

# SKIP: Downloading nwjs for Intel.. (we copy it instead)
echo "Copying manually downloaded nwjs.zip.."
cp ~/Downloads/nwjs-sdk-v0.77.0-osx-x64.zip nwjs.zip

echo "Downloading node polyfill patch.."
curl -#L -o node-polyfill-patch.js https://github.com/SnowpMakes/omori-apple-silicon/releases/download/v1.1.0/node-polyfill-patch.js
echo "Downloading greenworks patches for Intel.."
curl -#L -o greenworks.js https://github.com/SnowpMakes/omori-apple-silicon/releases/download/v1.1.0/greenworks.js
curl -#L -o greenworks-osx64.node https://github.com/SnowpMakes/greenworks-x64/releases/download/v1.0.0/greenworks-osx64.node
echo "Downloading steamworks api.."
curl -# -o steam.zip https://dl.snowp.io/omori-apple-silicon/steam.zip

echo "Extracting nwjs.."
unzip -q nwjs.zip
echo "Extracting steamworks.."
unzip -qq steam.zip

echo "Patching game.."
mv ./nwjs-v0.77.0-osx-x64/nwjs.app ./Omori.app
mv -f ./Omori.original.app/Contents/Resources/app.nw ./Omori.app/Contents/Resources/
mv -f ./Omori.original.app/Contents/Resources/app.icns ./Omori.app/Contents/Resources/
mv -f ./node-polyfill-patch.js ./Omori.app/Contents/Resources/app.nw/js/libs/
mv -f ./greenworks.js ./Omori.app/Contents/Resources/app.nw/js/libs/
mv -f ./greenworks-osx64.node ./Omori.app/Contents/Resources/app.nw/js/libs/
mv -f ./steam/libsteam_api.dylib ./Omori.app/Contents/Resources/app.nw/js/libs/
mv -f ./steam/libsdkencryptedappticket.dylib ./Omori.app/Contents/Resources/app.nw/js/libs/

echo "Finished. Moving patched Omori.app back to original location.."
mv "./Omori.app" "${OMORI}"

echo ""
echo "Done! You can now launch Omori."
echo "Note that if you update Omori or check the integrity of the game files, you'll need to reapply the patch."
echo ""
echo ""
