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

declare module 'virtual:krav-tasks' {
  import type { TasksSnapshot } from '../shared/tasks';
  const tasks: TasksSnapshot;
  export default tasks;
}
