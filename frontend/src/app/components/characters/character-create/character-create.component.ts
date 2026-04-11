import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { CharacterService } from '../../../services/character.service';
import { CreateCharacterRequest } from '../../../models/character.model';

@Component({
  selector: 'app-character-create',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './character-create.component.html'
})
export class CharacterCreateComponent {
  form: FormGroup;
  errorMessage = '';

  readonly races = ['Dragonborn', 'Dwarf', 'Elf', 'Gnome', 'Half-Elf', 'Halfling', 'Half-Orc', 'Human', 'Tiefling'];
  readonly classes = ['Barbarian', 'Bard', 'Cleric', 'Druid', 'Fighter', 'Monk', 'Paladin', 'Ranger', 'Rogue', 'Sorcerer', 'Warlock', 'Wizard'];

  constructor(private fb: FormBuilder, private characterService: CharacterService, private router: Router) {
    this.form = this.fb.group({
      name: ['', [Validators.required, Validators.minLength(1)]],
      race: ['', Validators.required],
      class: ['', Validators.required],
      level: [1, [Validators.required, Validators.min(1), Validators.max(20)]],
      background: [''],
      alignment: [''],
      strength: [10, [Validators.required, Validators.min(1), Validators.max(30)]],
      dexterity: [10, [Validators.required, Validators.min(1), Validators.max(30)]],
      constitution: [10, [Validators.required, Validators.min(1), Validators.max(30)]],
      intelligence: [10, [Validators.required, Validators.min(1), Validators.max(30)]],
      wisdom: [10, [Validators.required, Validators.min(1), Validators.max(30)]],
      charisma: [10, [Validators.required, Validators.min(1), Validators.max(30)]]
    });
  }

  submit(): void {
    if (this.form.invalid) return;
    const v = this.form.value;
    const request: CreateCharacterRequest = {
      name: v.name,
      race: v.race,
      class: v.class,
      level: v.level,
      background: v.background || undefined,
      alignment: v.alignment || undefined,
      abilityScores: {
        strength: v.strength,
        dexterity: v.dexterity,
        constitution: v.constitution,
        intelligence: v.intelligence,
        wisdom: v.wisdom,
        charisma: v.charisma
      }
    };
    this.characterService.create(request).subscribe({
      next: () => this.router.navigate(['/characters']),
      error: (err) => {
        const body = err.error;
        this.errorMessage = typeof body === 'string' ? body : (body?.message ?? err.message ?? 'Failed to create character.');
      }
    });
  }
}
