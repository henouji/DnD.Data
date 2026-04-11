export interface AbilityScores {
  strength: number;
  dexterity: number;
  constitution: number;
  intelligence: number;
  wisdom: number;
  charisma: number;
}

export interface CreateCharacterRequest {
  name: string;
  race: string;
  class: string;
  level: number;
  abilityScores: AbilityScores;
  background?: string;
  alignment?: string;
}

export interface CharacterResponse {
  id: number;
  name: string;
  race: string;
  class: string;
  level: number;
  abilityScores: AbilityScores;
  background?: string;
  alignment?: string;
  createdAt: string;
}
