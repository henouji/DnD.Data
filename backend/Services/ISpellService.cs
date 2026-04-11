using DnD.Api.Models.Spells;

namespace DnD.Api.Services;

public interface ISpellService
{
    Task<IEnumerable<SpellResponse>> GetAllAsync();
    Task<SpellResponse?> GetByIdAsync(int id);
    Task<IEnumerable<SpellResponse>> GetByLevelAsync(int level);
    Task<(SpellResponse? Spell, string? Error)> CreateAsync(SpellRequest request);
    Task<bool> DeleteAsync(int id);
}
