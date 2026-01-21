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

export interface Capability {
  id?: number;
  subdomain_id: number;
  folder_name: string;
  name: string;
  sort_order: number;
}

export interface Feature {
  feature_id: string;
  domain_id: number;
  subdomain_id: number | null;
  capability_id: number | null;
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
  feature_id: string;
  name: string;
  status: string | null;
  priority: string | null;
  sort_order: number;
}

export interface Scenario {
  id?: number;
  feature_id: string;
  rule_id: number | null;
  name: string;
  steps: string;
  status: string | null;
  priority: string | null;
  tags: string[];
  sort_order: number;
}

export interface OpenQuestion {
  id?: number;
  feature_id: string;
  question: string;
}

export interface ParsedFeature {
  filePath: string;
  domain: { folder_name: string; name: string; sort_order: number };
  subdomain: { folder_name: string; name: string; sort_order: number } | null;
  capability: { folder_name: string; name: string; sort_order: number } | null;
  feature: {
    feature_id: string | null;
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
    scenarios: {
      name: string;
      status: string | null;
      priority: string | null;
      tags: string[];
      steps: { keyword: string; text: string }[];
    }[];
  }[];
  scenarios: {
    name: string;
    status: string | null;
    priority: string | null;
    tags: string[];
    steps: { keyword: string; text: string }[];
  }[];
  openQuestions: string[];
}
