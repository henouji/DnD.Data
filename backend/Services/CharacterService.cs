using DnD.Api.Data;
using DnD.Api.Data.Entities;
using DnD.Api.Models.Characters;
using DnD.Api.Services.Validation;
using Microsoft.EntityFrameworkCore;

namespace DnD.Api.Services;

public class CharacterService : ICharacterService
{
    private readonly AppDbContext _context;

    public CharacterService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<CharacterResponse>> GetAllAsync()
    {
        var characters = await _context.Characters.ToListAsync();
        return characters.Select(MapToResponse);
    }

    public async Task<CharacterResponse?> GetByIdAsync(int id)
    {
        var character = await _context.Characters.FindAsync(id);
        return character is null ? null : MapToResponse(character);
    }

    public async Task<(CharacterResponse? Character, string? Error)> CreateAsync(CreateCharacterRequest request)
    {
        var validationErrors = new List<string>();

        var raceResult = DnD5eValidator.ValidateRace(request.Race);
        if (!raceResult.IsValid) validationErrors.Add(raceResult.Error!);

        var classResult = DnD5eValidator.ValidateClass(request.Class);
        if (!classResult.IsValid) validationErrors.Add(classResult.Error!);

        var levelResult = DnD5eValidator.ValidateLevel(request.Level);
        if (!levelResult.IsValid) validationErrors.Add(levelResult.Error!);

        var alignmentResult = DnD5eValidator.ValidateAlignment(request.Alignment);
        if (!alignmentResult.IsValid) validationErrors.Add(alignmentResult.Error!);

        var scores = request.AbilityScores;
        foreach (var (score, name) in new[]
        {
            (scores.Strength, "Strength"), (scores.Dexterity, "Dexterity"),
            (scores.Constitution, "Constitution"), (scores.Intelligence, "Intelligence"),
            (scores.Wisdom, "Wisdom"), (scores.Charisma, "Charisma")
        })
        {
            var result = DnD5eValidator.ValidateAbilityScore(score, name);
            if (!result.IsValid) validationErrors.Add(result.Error!);
        }

        if (validationErrors.Count > 0)
            return (null, string.Join(" ", validationErrors));

        var character = new Character
        {
            Name = request.Name,
            Race = request.Race,
            Class = request.Class,
            Level = request.Level,
            Strength = scores.Strength,
            Dexterity = scores.Dexterity,
            Constitution = scores.Constitution,
            Intelligence = scores.Intelligence,
            Wisdom = scores.Wisdom,
            Charisma = scores.Charisma,
            Background = request.Background,
            Alignment = request.Alignment,
            CreatedAt = DateTime.UtcNow
        };

        _context.Characters.Add(character);
        await _context.SaveChangesAsync();
        return (MapToResponse(character), null);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var character = await _context.Characters.FindAsync(id);
        if (character is null) return false;
        _context.Characters.Remove(character);
        await _context.SaveChangesAsync();
        return true;
    }

    private static CharacterResponse MapToResponse(Character c) => new()
    {
        Id = c.Id,
        Name = c.Name,
        Race = c.Race,
        Class = c.Class,
        Level = c.Level,
        AbilityScores = new AbilityScores
        {
            Strength = c.Strength,
            Dexterity = c.Dexterity,
            Constitution = c.Constitution,
            Intelligence = c.Intelligence,
            Wisdom = c.Wisdom,
            Charisma = c.Charisma
        },
        Background = c.Background,
        Alignment = c.Alignment,
        CreatedAt = c.CreatedAt
    };
}
