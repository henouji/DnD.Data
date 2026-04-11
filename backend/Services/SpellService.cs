using DnD.Api.Data;
using DnD.Api.Data.Entities;
using DnD.Api.Models.Spells;
using DnD.Api.Services.Validation;
using Microsoft.EntityFrameworkCore;

namespace DnD.Api.Services;

public class SpellService : ISpellService
{
    private readonly AppDbContext _context;

    public SpellService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<SpellResponse>> GetAllAsync()
    {
        var spells = await _context.Spells.ToListAsync();
        return spells.Select(MapToResponse);
    }

    public async Task<SpellResponse?> GetByIdAsync(int id)
    {
        var spell = await _context.Spells.FindAsync(id);
        return spell is null ? null : MapToResponse(spell);
    }

    public async Task<IEnumerable<SpellResponse>> GetByLevelAsync(int level)
    {
        var spells = await _context.Spells.Where(s => s.Level == level).ToListAsync();
        return spells.Select(MapToResponse);
    }

    public async Task<(SpellResponse? Spell, string? Error)> CreateAsync(SpellRequest request)
    {
        var levelResult = DnD5eValidator.ValidateSpellLevel(request.Level);
        if (!levelResult.IsValid) return (null, levelResult.Error);

        var schoolResult = DnD5eValidator.ValidateMagicSchool(request.School);
        if (!schoolResult.IsValid) return (null, schoolResult.Error);

        var spell = new Spell
        {
            Name = request.Name,
            Level = request.Level,
            School = request.School,
            Description = request.Description,
            CastingTime = request.CastingTime,
            Range = request.Range,
            Duration = request.Duration,
            Concentration = request.Concentration,
            Ritual = request.Ritual
        };

        _context.Spells.Add(spell);
        await _context.SaveChangesAsync();
        return (MapToResponse(spell), null);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var spell = await _context.Spells.FindAsync(id);
        if (spell is null) return false;
        _context.Spells.Remove(spell);
        await _context.SaveChangesAsync();
        return true;
    }

    private static SpellResponse MapToResponse(Spell s) => new()
    {
        Id = s.Id,
        Name = s.Name,
        Level = s.Level,
        School = s.School,
        Description = s.Description,
        CastingTime = s.CastingTime,
        Range = s.Range,
        Duration = s.Duration,
        Concentration = s.Concentration,
        Ritual = s.Ritual
    };
}
