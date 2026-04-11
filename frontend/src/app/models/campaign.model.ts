export interface CreateCampaignRequest {
  name: string;
  description?: string;
  dungeonMaster?: string;
}

export interface UpdateCampaignRequest {
  name: string;
  description?: string;
  dungeonMaster?: string;
}

export interface CampaignResponse {
  id: number;
  name: string;
  description?: string;
  dungeonMaster?: string;
  characterIds: number[];
  createdAt: string;
  updatedAt?: string;
}

export interface AddCharacterToCampaignRequest {
  characterId: number;
}
