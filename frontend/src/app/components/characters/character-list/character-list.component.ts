import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { CharacterService } from '../../../services/character.service';
import { CharacterResponse } from '../../../models/character.model';

@Component({
  selector: 'app-character-list',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './character-list.component.html'
})
export class CharacterListComponent implements OnInit {
  characters: CharacterResponse[] = [];
  errorMessage = '';

  constructor(private characterService: CharacterService) {}

  ngOnInit(): void {
    this.characterService.getAll().subscribe({
      next: (data) => { this.characters = data; },
      error: () => { this.errorMessage = 'Failed to load characters.'; }
    });
  }

  delete(id: number): void {
    this.characterService.delete(id).subscribe({
      next: () => { this.characters = this.characters.filter(c => c.id !== id); },
      error: () => { this.errorMessage = 'Failed to delete character.'; }
    });
  }
}
