import { useState } from 'preact/hooks';
import { answersFor, type Answers, type Pick, type Question } from '../shared/question';
import type { ChatItem } from './claudeChat';
import { transport } from './transport';

type QuestionItem = Extract<ChatItem, { kind: 'question' }>;

/** Svarer på spørsmålene fra AskUserQuestion; `null` er «Hopp over» (eller at panelet lukkes: `closed`) */
export function answerQuestion(item: QuestionItem, answers: Answers | null, reason: 'user' | 'closed' = 'user') {
  return transport.call('claudeAnswer', { id: item.id, answers, reason }).catch(() => false);
}

const STATE: Record<Exclude<QuestionItem['state'], 'pending' | 'answered'>, string> = {
  skipped: 'Hoppet over: Claude spør i teksten i stedet',
  timeout: 'Ikke besvart innen 30 minutter',
  closed: 'Ikke besvart: panelet ble lukket',
  ended: 'Ikke besvart: kjøringen ble avsluttet',
};

const NO_PICK: Pick = { labels: [], other: '' };

/**
 * Kortet «Claude spør deg»: ett eller flere spørsmål med valg (radioknapper, eller avkryssing ved flervalg), alltid
 * med «Annet» og et tekstfelt, og forhåndsvisningen til valget som er markert. «Send svar» når alle har svar.
 */
export function QuestionCard({ item }: { item: QuestionItem }) {
  const [picks, setPicks] = useState<Record<string, Pick>>({});
  const [otherOn, setOtherOn] = useState<Record<string, boolean>>({});
  const [sending, setSending] = useState(false);
  const pending = item.state === 'pending';
  const pickOf = (q: Question) => picks[q.question] ?? NO_PICK;
  const effective = Object.fromEntries(item.questions.map(q => [q.question, { ...pickOf(q), other: otherOn[q.question] ? pickOf(q).other : '' }]));
  const answers = answersFor(item.questions, effective);

  const update = (q: Question, p: Partial<Pick>) => setPicks(ps => ({ ...ps, [q.question]: { ...pickOf(q), ...p } }));
  const choose = (q: Question, label: string, on: boolean) => {
    if (q.multiSelect) update(q, { labels: on ? [...pickOf(q).labels, label] : pickOf(q).labels.filter(l => l !== label) });
    else {
      update(q, { labels: [label] });
      setOtherOn(o => ({ ...o, [q.question]: false }));
    }
  };
  const chooseOther = (q: Question, on: boolean) => {
    setOtherOn(o => ({ ...o, [q.question]: on }));
    if (on && !q.multiSelect) update(q, { labels: [] });
  };
  const send = async (a: Answers | null) => {
    setSending(true);
    if (!(await answerQuestion(item, a))) setSending(false);
  };

  return (
    <div class={'cperm cq' + (pending ? '' : ' answered ' + item.state)} role={pending ? 'group' : undefined} aria-label="Claude spør deg">
      <div class="cperm-head">Claude spør deg</div>
      {item.questions.map((q, qi) => {
        const pick = pickOf(q);
        const preview = q.options.find(o => o.preview && pick.labels.includes(o.label))?.preview;
        const name = `${item.id}:${qi}`;
        if (!pending)
          return (
            <div key={q.question} class="cq-q">
              {q.header && <span class="cq-header">{q.header}</span>}
              <div class="cq-text">{q.question}</div>
              {item.answers?.[q.question] && <div class="cq-answer">{item.answers[q.question]}</div>}
            </div>
          );
        return (
          <fieldset key={q.question} class="cq-q" disabled={sending}>
            <legend class="cq-legend">
              {q.header && <span class="cq-header">{q.header}</span>}
              <span class="cq-text">{q.question}</span>
              {q.multiSelect && <span class="muted cq-multi">Velg ett eller flere</span>}
            </legend>
            <div class={'cq-body' + (q.options.some(o => o.preview) ? ' with-preview' : '')}>
              <div class="cq-opts">
                {q.options.map(o => (
                  <label key={o.label} class="cq-opt">
                    <input
                      type={q.multiSelect ? 'checkbox' : 'radio'}
                      name={name}
                      checked={pick.labels.includes(o.label)}
                      onChange={e => choose(q, o.label, (e.currentTarget as HTMLInputElement).checked)}
                    />
                    <span>
                      <span class="cq-label">{o.label}</span>
                      {o.description && <span class="cq-desc muted">{o.description}</span>}
                    </span>
                  </label>
                ))}
                <label class="cq-opt">
                  <input
                    type={q.multiSelect ? 'checkbox' : 'radio'}
                    name={name}
                    checked={!!otherOn[q.question]}
                    onChange={e => chooseOther(q, (e.currentTarget as HTMLInputElement).checked)}
                  />
                  <span class="cq-label">Annet</span>
                </label>
                {otherOn[q.question] && (
                  <input
                    class="cq-other"
                    type="text"
                    placeholder="Skriv svaret ditt"
                    value={pick.other}
                    autoFocus
                    onInput={e => update(q, { other: (e.currentTarget as HTMLInputElement).value })}
                    onKeyDown={e => {
                      if (e.key === 'Enter' && answers) void send(answers);
                    }}
                  />
                )}
              </div>
              {preview && <pre class="cq-preview mono">{preview}</pre>}
            </div>
          </fieldset>
        );
      })}
      {pending ? (
        <div class="cperm-btns">
          <button class="primbtn" disabled={!answers || sending} onClick={() => answers && void send(answers)}>Send svar</button>
          <button class="smallbtn" disabled={sending} onClick={() => void send(null)}>Hopp over</button>
        </div>
      ) : (
        item.state !== 'answered' && item.state !== 'pending' && <div class="cperm-state muted">{STATE[item.state]}</div>
      )}
    </div>
  );
}
