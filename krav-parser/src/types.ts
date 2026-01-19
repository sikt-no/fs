export interface Domain {
  id?: number;
  folder_name: string;
  name: string;
  sort_order: number;
}

export interface Subdomain {
  id?: number;
  domain_id: number;
  folder_name: string;
  name: string;
  sort_order: number;
}

export interface Requirement {
  id?: number;
  domain_id: number;
  subdomain_id: number | null;
  file_path: string;
  file_name: string;
  name: string;
  description: string | null;
  status: string | null;
  priority: string | null;
  tags: string[];
}

export interface Rule {
  id?: number;
  requirement_id: number;
  name: string;
  status: string | null;
  priority: string | null;
  sort_order: number;
}

export interface Example {
  id?: number;
  requirement_id: number;
  rule_id: number | null;
  name: string;
  steps: string;  // All steps as comma-separated text
  status: string | null;
  priority: string | null;
  tags: string[];
  sort_order: number;
}

export interface OpenQuestion {
  id?: number;
  requirement_id: number;
  question: string;
}

export interface ParsedFeature {
  filePath: string;
  domain: { folder_name: string; name: string; sort_order: number };
  subdomain: { folder_name: string; name: string; sort_order: number } | null;
  requirement: {
    name: string;
    description: string | null;
    status: string | null;
    priority: string | null;
    tags: string[];
  };
  rules: {
    name: string;
    status: string | null;
    priority: string | null;
    examples: {
      name: string;
      status: string | null;
      priority: string | null;
      tags: string[];
      steps: { keyword: string; text: string }[];
    }[];
  }[];
  // Examples not under any rule
  examples: {
    name: string;
    status: string | null;
    priority: string | null;
    tags: string[];
    steps: { keyword: string; text: string }[];
  }[];
  openQuestions: string[];
}
