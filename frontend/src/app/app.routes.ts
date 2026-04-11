import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: 'characters',
    loadComponent: () =>
      import('./components/characters/character-list/character-list.component').then(
        m => m.CharacterListComponent
      )
  },
  {
    path: 'characters/create',
    loadComponent: () =>
      import('./components/characters/character-create/character-create.component').then(
        m => m.CharacterCreateComponent
      )
  },
  {
    path: 'campaigns',
    loadComponent: () =>
      import('./components/campaigns/campaign-list/campaign-list.component').then(
        m => m.CampaignListComponent
      )
  },
  { path: '', redirectTo: 'characters', pathMatch: 'full' }
];
