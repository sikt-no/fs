import type { FeatureModel, Note, Rule } from '../shared/model';

const qCount = (notes: Note[]) => notes.filter(n => n.kind === 'question').reduce((n, q) => n + q.items.length, 0);
/** Åpne spørsmål i regelen og scenarioene under den */
const ruleQ = (r: Rule) => qCount(r.notes) + r.scenarios.reduce((n, s) => n + qCount(s.notes), 0);

interface Props {
  model?: FeatureModel;
  onJump: (key: string) => void;
  onFoldAll: () => void;
  onOpenAll: () => void;
}

export function Outline({ model, onJump, onFoldAll, onOpenAll }: Props) {
  let num = 0;
  return (
    <aside class="outline">
      <div class="outline-head">
        <span class="mono">INNHOLD</span>
        <div>
          <button class="smallbtn" onClick={onFoldAll}>Fold alle</button>
          <button class="smallbtn" onClick={onOpenAll}>Utvid</button>
        </div>
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '2px' }}>
        {model?.rules.map((r, ri) => {
          if (r.name === null) return null;
          num++;
          const n = r.scenarios.filter(s => s.kind !== 'Bakgrunn').length;
          const q = ruleQ(r);
          const draft = r.tags.includes('@draft');
          return (
            <button key={ri} class={'orow' + (draft ? ' draft' : '')} onClick={() => onJump(String(ri))}>
              <span class="num">{num}</span>
              <span class="txt">
                <span>{r.name}</span>
                <span class="mono">
                  {n} {n === 1 ? 'scenario' : 'scenarioer'}
                  {draft && ' · utkast'}
                  {q > 0 && <span class="oq"> · ? {q}</span>}
                </span>
              </span>
            </button>
          );
        })}
        {model && model.questions.length > 0 && (
          <button class="orow" onClick={() => onJump('q')}>
            <span class="num">?</span>
            <span class="txt"><span>Åpne spørsmål</span><span class="mono">{model.questions.length} punkter</span></span>
          </button>
        )}
      </div>
    </aside>
  );
}
