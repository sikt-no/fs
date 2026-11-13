// Statusfargene og statusprikken i Flyter, felles for fanene i Flyter.tsx og kartet i FlowMap.tsx.
import type { Status } from '../shared/model';
import type { PhaseStatus } from './flows';

export const STC: Record<Status, string> = {
  draft: 'var(--st-draft)',
  planned: 'var(--st-planned)',
  'in-progress': 'var(--st-in-progress)',
  implemented: 'var(--st-implemented)',
  deprecated: 'var(--st-deprecated)',
};
export const stColor = (s: Status | null) => (s ? STC[s] : 'var(--st-none)');

/** Fargen og etiketten på fasen. Fasen uten krav er stiplet */
export function phaseLook(s: PhaseStatus, overview: boolean) {
  if (s === 'missing') return { c: 'var(--muted)', fill: 'transparent', dashed: true, l: overview ? 'mangler flyt' : 'mangler krav' };
  if (s === 'broken') return { c: 'var(--err)', fill: 'var(--err)', dashed: false, l: 'finnes ikke' };
  return { c: STC[s], fill: STC[s], dashed: false, l: s === 'implemented' ? 'levert' : s };
}

export const Dot = ({ c, fill = c, dashed = false, z = 7 }: { c: string; fill?: string; dashed?: boolean; z?: number }) => (
  <span class="fl-dot" style={{ width: z + 'px', height: z + 'px', background: fill, border: `1.5px ${dashed ? 'dashed' : 'solid'} ${c}` }} />
);
