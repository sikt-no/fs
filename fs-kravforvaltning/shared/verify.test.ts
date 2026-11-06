import assert from 'node:assert/strict';
import { test } from 'node:test';
import { htmlOf, isVerifyFile, isVerifyHtml, isVerifyName, isVerifyReport, reportName } from './verify.ts';

test('verify-rapportene og rapportvisningen kjennes på navnet, i krav/, tasks/ og akseptansetest/', () => {
  for (const p of [
    'krav/02 Opptak/13 Søknad og saksbehandling/02 Behandling/verify-automatisk_kvalifisering-2026-11-03-1519.md',
    'krav/_Flyter/10 Opptaksløpet/verify-saksbehandlertildeling-2026-10-22-1419.md',
    'tasks/opptak/tidlig-opptak/spec/verify-2026-11-02-1236.md',
    'akseptansetest/kvoter-i-opptaket-2027/verify-2026-11-05-0935.md',
  ])
    assert.ok(isVerifyReport(p) && !isVerifyHtml(p), p);
  assert.ok(isVerifyHtml('akseptansetest/kvoter-i-opptaket-2027/verify-2026-11-05-0935.html'));
  for (const p of [
    'krav/02 Opptak/x.feature',
    'krav/README.md',
    'krav/a/verifisering.md',
    'tasks/opptak/x/spec/verify-2026-10-05/01-se-liste.png',
    'fs-kravforvaltning/verify-x.md',
    'krav/../tasks/verify-x.md',
    'krav//verify-x.md',
  ])
    assert.ok(!isVerifyFile(p), p);
  assert.ok(isVerifyName('/abs/krav/a/verify-x.md'));
  assert.ok(isVerifyName('C:\\repo\\krav\\a\\verify-x.html'));
  assert.ok(!isVerifyName('krav/a/b.md'));
  assert.equal(htmlOf('akseptansetest/a/verify-2026-11-05-0935.md'), 'akseptansetest/a/verify-2026-11-05-0935.html');
});

test('reportName gir navnet og datoen fra filnavnet', () => {
  assert.deepEqual(reportName('krav/a/verify-automatisk_kvalifisering-2026-11-03-1519.md'), { name: 'automatisk_kvalifisering', date: '2026-11-03 15:19' });
  assert.deepEqual(reportName('tasks/opptak/x/spec/verify-2026-11-02-1236.md'), { name: 'verify', date: '2026-11-02 12:36' });
  assert.deepEqual(reportName('krav/a/verify-søknadsmangler-2026-10-08.md'), { name: 'søknadsmangler', date: '2026-10-08' });
  assert.deepEqual(reportName('krav/a/verify-10 Regelverk-2026-10-14-1524-2.md'), { name: '10 Regelverk', date: '2026-10-14 15:24-2' });
  assert.deepEqual(reportName('krav/a/verify-fjerne-roller.md'), { name: 'fjerne-roller', date: null });
});
