import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import {
  CampaignResponse,
  CreateCampaignRequest,
  UpdateCampaignRequest,
  AddCharacterToCampaignRequest
} from '../models/campaign.model';

@Injectable({
  providedIn: 'root'
})
export class CampaignService {
  private readonly baseUrl = `${environment.apiBaseUrl}/campaigns`;

  constructor(private http: HttpClient) {}

  getAll(): Observable<CampaignResponse[]> {
    return this.http.get<CampaignResponse[]>(this.baseUrl);
  }

  getById(id: number): Observable<CampaignResponse> {
    return this.http.get<CampaignResponse>(`${this.baseUrl}/${id}`);
  }

  create(request: CreateCampaignRequest): Observable<CampaignResponse> {
    return this.http.post<CampaignResponse>(this.baseUrl, request);
  }

  update(id: number, request: UpdateCampaignRequest): Observable<CampaignResponse> {
    return this.http.put<CampaignResponse>(`${this.baseUrl}/${id}`, request);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }

  addCharacter(campaignId: number, request: AddCharacterToCampaignRequest): Observable<void> {
    return this.http.post<void>(`${this.baseUrl}/${campaignId}/characters`, request);
  }

  removeCharacter(campaignId: number, characterId: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${campaignId}/characters/${characterId}`);
  }
}
