#!/bin/bash

# Synkroniser issues fra prosjekt 4 til prosjekt 10
# Kjør: bash sync-projects.sh

SOURCE_PROJECT="4"
TARGET_PROJECT="10" 
ORG="sikt-no"

echo "🔄 Synkroniserer fra prosjekt $SOURCE_PROJECT til $TARGET_PROJECT..."

# 1. Hent alle items fra kilde-prosjekt
echo "📥 Henter items fra prosjekt $SOURCE_PROJECT..."
gh project item-list $SOURCE_PROJECT --owner $ORG --format json > source_items.json

if [ ! -s source_items.json ]; then
    echo "❌ Kunne ikke hente items. Sjekk tilganger med: gh auth refresh -s read:project"
    exit 1
fi

# 2. Hent eksisterende items i mål-prosjekt
echo "📋 Henter eksisterende items i prosjekt $TARGET_PROJECT..."
gh project item-list $TARGET_PROJECT --owner $ORG --format json > target_items.json

# 3. Parse og kopier issues som ikke finnes i mål
echo "🔍 Finner issues som skal kopieres..."

node -e "
const source = JSON.parse(require('fs').readFileSync('source_items.json', 'utf8'));
const target = JSON.parse(require('fs').readFileSync('target_items.json', 'utf8'));

const targetUrls = new Set(target.items?.map(item => item.content?.url) || []);
const toCopy = source.items?.filter(item => 
    item.type === 'ISSUE' && 
    item.content?.url && 
    !targetUrls.has(item.content.url)
) || [];

console.log(\`📊 Fant \${toCopy.length} issues som skal kopieres\`);
toCopy.forEach((item, i) => {
    console.log(\`\${i+1}. \${item.content.title} (\${item.content.url})\`);
});

require('fs').writeFileSync('to_copy.json', JSON.stringify(toCopy, null, 2));
"

if [ ! -s to_copy.json ]; then
    echo "✅ Ingen nye issues å kopiere!"
    exit 0
fi

# 4. Kopier issues til mål-prosjekt
echo "📤 Kopierer issues til prosjekt $TARGET_PROJECT..."
node -e "
const toCopy = JSON.parse(require('fs').readFileSync('to_copy.json', 'utf8'));
toCopy.forEach(item => {
    console.log(\`Kopierer: \${item.content.title}\`);
    console.log(\`gh project item-add $TARGET_PROJECT --owner $ORG --url \${item.content.url}\`);
});
" > copy_commands.sh

chmod +x copy_commands.sh

echo "🚀 Kjører kopieringskommandoer..."
bash copy_commands.sh

echo "✅ Synkronisering fullført!"
echo "🧹 Rydder opp temporære filer..."
rm -f source_items.json target_items.json to_copy.json copy_commands.sh

echo "📋 Status: Sjekk prosjekt $TARGET_PROJECT på GitHub"