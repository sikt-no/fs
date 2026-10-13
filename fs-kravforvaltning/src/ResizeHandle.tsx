interface Props {
  width: number;
  onWidth: (w: number) => void;
  /** Kanten av panelet håndtaket står på: `left` for Claude-panelet (til høyre), `right` for treet (til venstre) */
  edge: 'left' | 'right';
  min: number;
  max: () => number;
  /** Standardbredden, som dobbeltklikk går tilbake til */
  fallback: number;
  label: string;
}

/**
 * Håndtaket på kanten av et panel: dra for å endre bredden, piltastene flytter 20 px (Shift: 80 px),
 * og dobbeltklikk går tilbake til standardbredden.
 */
export function ResizeHandle({ width, onWidth, edge, min, max, fallback, label }: Props) {
  const clamp = (w: number) => Math.min(max(), Math.max(min, Math.round(w)));
  const onPointerDown = (e: PointerEvent) => {
    if (e.button !== 0) return;
    e.preventDefault();
    const el = e.currentTarget as HTMLElement;
    // Claude-panelet ligger helt til høyre, så bredden er avstanden fra pekeren til høyre kant av arbeidsflaten.
    // Treet ligger til venstre, så bredden er avstanden fra venstre kant av panelet til pekeren.
    const right = el.closest('.workspace')?.getBoundingClientRect().right ?? innerWidth;
    const left = el.parentElement?.getBoundingClientRect().left ?? 0;
    el.setPointerCapture(e.pointerId);
    document.body.classList.add('resizing');
    el.classList.add('dragging');
    const move = (ev: PointerEvent) => onWidth(clamp(edge === 'left' ? right - ev.clientX : ev.clientX - left));
    const up = () => {
      el.removeEventListener('pointermove', move);
      el.removeEventListener('pointerup', up);
      el.removeEventListener('pointercancel', up);
      document.body.classList.remove('resizing');
      el.classList.remove('dragging');
    };
    el.addEventListener('pointermove', move);
    el.addEventListener('pointerup', up);
    el.addEventListener('pointercancel', up);
  };
  const onKeyDown = (e: KeyboardEvent) => {
    // Pil bort fra panelet gjør det bredere
    const step = (e.shiftKey ? 80 : 20) * (edge === 'left' ? 1 : -1);
    if (e.key === 'ArrowLeft') onWidth(clamp(width + step));
    else if (e.key === 'ArrowRight') onWidth(clamp(width - step));
    else if (e.key === 'Home') onWidth(max());
    else if (e.key === 'End') onWidth(min);
    else return;
    e.preventDefault();
  };
  return (
    <div
      class={'resize-handle ' + edge}
      role="separator"
      aria-orientation="vertical"
      aria-label={label}
      aria-valuenow={width}
      aria-valuemin={min}
      aria-valuemax={max()}
      tabIndex={0}
      title="Dra for å endre bredden · dobbeltklikk for standard"
      onPointerDown={onPointerDown}
      onKeyDown={onKeyDown}
      onDblClick={() => onWidth(fallback)}
    />
  );
}
