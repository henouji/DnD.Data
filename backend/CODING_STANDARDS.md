# Coding Standards

## Project Structure

```
backend/
  Controllers/       # HTTP entry points — thin, delegate to services
  Models/            # DTOs organized by domain (Characters/, Campaigns/, Spells/)
  Services/          # Business logic interfaces and implementations
  Services/Validation/ # DnD 5e rule validators
  Data/              # EF Core DbContext
  Data/Entities/     # EF Core entity classes
```

## Controller Pattern

Controllers are thin. They:
- Accept HTTP requests and deserialize input
- Call the appropriate service method
- Map the result to an HTTP response (200, 201, 400, 404, etc.)
- Do **not** contain business logic or data access code

```csharp
[HttpPost]
public async Task<IActionResult> Create([FromBody] CreateCharacterRequest request)
{
    var (character, error) = await _characterService.CreateAsync(request);
    if (error is not null) return BadRequest(error);
    return CreatedAtAction(nameof(GetById), new { id = character!.Id }, character);
}
```

## Service Pattern

Services contain all business logic. They:
- Validate input using `DnD5eValidator`
- Interact with `AppDbContext` for data access
- Return result tuples `(Response? result, string? error)` for operations that can fail
- Return `bool` for simple delete operations

```csharp
public async Task<(CharacterResponse? Character, string? Error)> CreateAsync(CreateCharacterRequest request)
{
    var raceResult = DnD5eValidator.ValidateRace(request.Race);
    if (!raceResult.IsValid) return (null, raceResult.Error);
    // ...
}
```

## DTO Pattern

Models are organized by domain under `Models/`:
- `Models/Characters/` — `CreateCharacterRequest`, `CharacterResponse`
- `Models/Campaigns/` — `CreateCampaignRequest`, `UpdateCampaignRequest`, `CampaignResponse`, `AddCharacterToCampaignRequest`
- `Models/Spells/` — `SpellRequest`, `SpellResponse`

DTOs are separate from entities. Never expose EF Core entities directly via the API.

## Validation

DnD 5e rules are enforced in `Services/Validation/DnD5eValidator.cs`:
- Valid races: Dragonborn, Dwarf, Elf, Gnome, Half-Elf, Halfling, Half-Orc, Human, Tiefling
- Valid classes: Barbarian, Bard, Cleric, Druid, Fighter, Monk, Paladin, Ranger, Rogue, Sorcerer, Warlock, Wizard
- Level: 1–20
- Ability scores: 1–30
- Spell level: 0 (cantrip)–9
- Magic schools: Abjuration, Conjuration, Divination, Enchantment, Evocation, Illusion, Necromancy, Transmutation
- Alignment: optional, but must be a valid 5e alignment if provided

## Async/Await

All service methods and controller actions are `async Task<T>`. No blocking calls (`.Result`, `.Wait()`).

## Naming

- Interfaces prefixed with `I`: `ICharacterService`, `ICampaignService`, `ISpellService`
- Request DTOs suffixed with `Request`: `CreateCharacterRequest`
- Response DTOs suffixed with `Response`: `CharacterResponse`
- Entity classes match the domain name without suffix: `Character`, `Campaign`, `Spell`
