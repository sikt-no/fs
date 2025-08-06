// Script for å kopiere alle issues fra FS Offentlig saksoversikt til FS Saksoversikt (intern)
// Kjør med: node copy-issues-to-internal-project.js
// Krever at GITHUB_TOKEN environment variabel er satt

const https = require('https');

const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
const REPO_OWNER = 'sikt-no';
const REPO_NAME = 'fs';

if (!GITHUB_TOKEN) {
  console.error('❌ GITHUB_TOKEN environment variabel må være satt');
  process.exit(1);
}

// GitHub API helper function
function makeRequest(path, options = {}) {
  return new Promise((resolve, reject) => {
    const requestOptions = {
      hostname: 'api.github.com',
      path: path,
      method: options.method || 'GET',
      headers: {
        'Authorization': `token ${GITHUB_TOKEN}`,
        'User-Agent': 'FS-Issue-Sync-Script',
        'Accept': 'application/vnd.github.v3+json',
        'Content-Type': 'application/json',
        ...options.headers
      }
    };

    const req = https.request(requestOptions, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const parsed = data ? JSON.parse(data) : null;
          if (res.statusCode >= 200 && res.statusCode < 300) {
            resolve(parsed);
          } else {
            reject(new Error(`HTTP ${res.statusCode}: ${data}`));
          }
        } catch (e) {
          reject(e);
        }
      });
    });

    req.on('error', reject);
    
    if (options.body) {
      req.write(JSON.stringify(options.body));
    }
    
    req.end();
  });
}

async function main() {
  try {
    console.log('🔍 Henter prosjekter for fs-repoet...');
    
    // Hent alle prosjekter for repoet
    const projects = await makeRequest(`/repos/${REPO_OWNER}/${REPO_NAME}/projects`);
    console.log(`Fant ${projects.length} prosjekter:`);
    projects.forEach(p => console.log(`  - ${p.name} (#${p.number})`));
    
    // Finn FS Offentlig saksoversikt
    const offentligProject = projects.find(p => 
      p.name.toLowerCase().includes('offentlig') && 
      p.name.toLowerCase().includes('saksoversikt')
    );
    
    if (!offentligProject) {
      console.error('❌ Fant ikke FS Offentlig saksoversikt prosjekt');
      return;
    }
    
    console.log(`✅ Fant FS Offentlig saksoversikt: ${offentligProject.name}`);
    
    // Finn FS Saksoversikt (intern)
    let internProject = projects.find(p => 
      p.name.toLowerCase().includes('saksoversikt') && 
      p.name.toLowerCase().includes('intern')
    );
    
    // Hvis intern prosjekt ikke finnes, opprett det
    if (!internProject) {
      console.log('📝 Oppretter FS Saksoversikt (intern) prosjekt...');
      internProject = await makeRequest(`/repos/${REPO_OWNER}/${REPO_NAME}/projects`, {
        method: 'POST',
        body: {
          name: 'FS Saksoversikt (intern)',
          body: 'Intern saksoversikt for FS produktet - inneholder alle saker inkludert sensitive og interne forhold.'
        }
      });
      console.log(`✅ Opprettet intern prosjekt: ${internProject.name}`);
      
      // Opprett standard kolonner
      const columns = ['Backlog', 'Under arbeid', 'Ferdig'];
      for (const columnName of columns) {
        await makeRequest(`/projects/${internProject.id}/columns`, {
          method: 'POST',
          body: { name: columnName }
        });
        console.log(`  ✅ Opprettet kolonne: ${columnName}`);
      }
    } else {
      console.log(`✅ Fant eksisterende intern prosjekt: ${internProject.name}`);
    }
    
    // Hent kolonner for begge prosjekter
    console.log('🔍 Henter prosjekt-kolonner...');
    const offentligColumns = await makeRequest(`/projects/${offentligProject.id}/columns`);
    const internColumns = await makeRequest(`/projects/${internProject.id}/columns`);
    
    console.log(`FS Offentlig har ${offentligColumns.length} kolonner`);
    console.log(`FS Intern har ${internColumns.length} kolonner`);
    
    // Hent alle kort fra offentlig prosjekt
    console.log('📋 Henter alle kort fra offentlig prosjekt...');
    let allCards = [];
    
    for (const column of offentligColumns) {
      const cards = await makeRequest(`/projects/columns/${column.id}/cards`);
      console.log(`  - ${column.name}: ${cards.length} kort`);
      allCards.push(...cards.map(card => ({...card, columnName: column.name})));
    }
    
    console.log(`Totalt ${allCards.length} kort å kopiere`);
    
    // Kopier hvert kort til intern prosjekt
    let copiedCount = 0;
    let skippedCount = 0;
    
    for (const card of allCards) {
      if (card.content_url && card.content_url.includes('/issues/')) {
        // Dette er et issue-kort
        const issueId = card.content_url.split('/').pop();
        console.log(`📝 Kopierer issue #${issueId} til intern prosjekt...`);
        
        try {
          // Finn tilsvarende kolonne i intern prosjekt (eller bruk første)
          let targetColumn = internColumns.find(c => 
            c.name.toLowerCase() === card.columnName.toLowerCase()
          ) || internColumns[0];
          
          // Opprett kort i intern prosjekt
          await makeRequest(`/projects/columns/${targetColumn.id}/cards`, {
            method: 'POST',
            body: {
              content_id: parseInt(card.content_url.split('/').pop()),
              content_type: 'Issue'
            }
          });
          
          copiedCount++;
          console.log(`  ✅ Kopierte issue #${issueId} til kolonne "${targetColumn.name}"`);
          
          // Vent litt mellom API-kall for å unngå rate limiting
          await new Promise(resolve => setTimeout(resolve, 100));
          
        } catch (error) {
          if (error.message.includes('422')) {
            console.log(`  ⚠️  Issue #${issueId} finnes allerede i intern prosjekt`);
            skippedCount++;
          } else {
            console.error(`  ❌ Feil ved kopiering av issue #${issueId}:`, error.message);
          }
        }
      }
    }
    
    console.log('\n🎉 Kopiering fullført!');
    console.log(`✅ Kopierte: ${copiedCount} issues`);
    console.log(`⚠️  Hoppet over: ${skippedCount} issues (allerede eksisterer)`);
    console.log(`📊 Totalt behandlet: ${allCards.length} kort`);
    
  } catch (error) {
    console.error('❌ Feil under kjøring:', error);
    process.exit(1);
  }
}

main();