declare module 'virtual:krav' {
  import type { Snapshot } from '../shared/model';
  const snapshot: Snapshot;
  export default snapshot;
}

declare module 'virtual:krav-git' {
  import type { GitInfo } from '../shared/model';
  const git: GitInfo | null;
  export default git;
}

declare module 'virtual:krav-root' {
  /** Absolutt sti til repoet i dev-serveren, null i statisk bygg */
  const root: string | null;
  export default root;
}

declare module 'virtual:krav-tasks' {
  import type { TasksSnapshot } from '../shared/tasks';
  /** Scope-mappene i tasks/ (null i eldre bygg) */
  const tasks: TasksSnapshot | null;
  export default tasks;
}

declare module 'virtual:krav-verify' {
  import type { VerifySnapshot } from '../shared/verify';
  /** Verify-rapportene i krav/, tasks/ og akseptansetest/ (null i eldre bygg og i desktop-appen) */
  const verify: VerifySnapshot | null;
  export default verify;
}
