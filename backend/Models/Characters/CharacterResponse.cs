namespace DnD.Api.Models.Characters;

public class CharacterResponse
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Race { get; set; } = string.Empty;
    public string Class { get; set; } = string.Empty;
    public int Level { get; set; }
    public AbilityScores AbilityScores { get; set; } = new();
    public string? Background { get; set; }
    public string? Alignment { get; set; }
    public DateTime CreatedAt { get; set; }
}
