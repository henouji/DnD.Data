export interface SpellRequest {
  name: string;
  level: number;
  school: string;
  description?: string;
  castingTime?: string;
  range?: string;
  duration?: string;
  concentration: boolean;
  ritual: boolean;
}

export interface SpellResponse {
  id: number;
  name: string;
  level: number;
  school: string;
  description?: string;
  castingTime?: string;
  range?: string;
  duration?: string;
  concentration: boolean;
  ritual: boolean;
}
