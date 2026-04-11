import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { SpellRequest, SpellResponse } from '../models/spell.model';

@Injectable({
  providedIn: 'root'
})
export class SpellService {
  private readonly baseUrl = `${environment.apiBaseUrl}/spells`;

  constructor(private http: HttpClient) {}

  getAll(): Observable<SpellResponse[]> {
    return this.http.get<SpellResponse[]>(this.baseUrl);
  }

  getById(id: number): Observable<SpellResponse> {
    return this.http.get<SpellResponse>(`${this.baseUrl}/${id}`);
  }

  getByLevel(level: number): Observable<SpellResponse[]> {
    return this.http.get<SpellResponse[]>(`${this.baseUrl}/level/${level}`);
  }

  create(request: SpellRequest): Observable<SpellResponse> {
    return this.http.post<SpellResponse>(this.baseUrl, request);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.baseUrl}/${id}`);
  }
}
