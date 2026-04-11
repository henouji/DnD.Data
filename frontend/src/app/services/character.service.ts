import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { CharacterResponse, CreateCharacterRequest } from '../models/character.model';

@Injectable({
  providedIn: 'root'
})
export class CharacterService {
  private readonly baseUrl = `${environment.apiBaseUrl}/characters`;

  constructor(private http: HttpClient) {}

  getAll(): Observable<CharacterResponse[]> {
    return this.http.get<CharacterResponse[]>(this.baseUrl);
  }

  getById(id: number): Observable<CharacterResponse> {
    return this.http.get<CharacterResponse>(`${this.baseUrl}/${id}`);
  }

  create(request: CreateCharacterRequest): Observable<CharacterResponse> {
    return this.http.post<CharacterResponse>(this.baseUrl, request);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
