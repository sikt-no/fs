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
