import type { MainInfo, MainStatus } from '../shared/api';

/** «for 4 min siden», «for 2 t siden», «for 3 dager siden» */
export function ago(date: string, now: number): string {
  const min = Math.floor((now - Date.parse(date)) / 60_000);
  if (!(min >= 1)) return 'nå nettopp';
  if (min < 60) return `for ${min} min siden`;
  const h = Math.floor(min / 60);
  if (h < 24) return `for ${h} t siden`;
  const d = Math.floor(h / 24);
  return `for ${d} ${d === 1 ? 'dag' : 'dager'} siden`;
}

/** Infolinja i banneret: «3 nye commits på main · 7 .feature-filer endret · sist av @kari for 4 min siden» */
export function mainInfoText(info: MainInfo, now: number): string {
  const parts = [info.commits === 1 ? '1 ny commit på main' : `${info.commits} nye commits på main`];
  if (info.features) parts.push(`${info.features} .feature-${info.features === 1 ? 'fil' : 'filer'} endret`);
  const when = info.date ? ago(info.date, now) : null;
  if (info.author) parts.push(`sist av ${info.author}${when ? ' ' + when : ''}`);
  else if (when) parts.push(`sist ${when}`);
  return parts.join(' · ');
}

/** Banneret vises når main er nyere, med mindre brukeren har valgt «Senere» for akkurat denne commiten */
export function bannerShown(status: MainStatus | null, laterSha: string | null): boolean {
  return !!status?.behind && status.remote !== laterSha;
}
