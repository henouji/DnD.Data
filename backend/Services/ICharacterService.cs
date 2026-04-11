using DnD.Api.Models.Characters;

namespace DnD.Api.Services;

public interface ICharacterService
{
    Task<IEnumerable<CharacterResponse>> GetAllAsync();
    Task<CharacterResponse?> GetByIdAsync(int id);
    Task<(CharacterResponse? Character, string? Error)> CreateAsync(CreateCharacterRequest request);
    Task<bool> DeleteAsync(int id);
}
