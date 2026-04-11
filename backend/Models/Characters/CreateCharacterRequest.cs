namespace DnD.Api.Models.Characters;

public class CreateCharacterRequest
{
    public string Name { get; set; } = string.Empty;
    public string Race { get; set; } = string.Empty;
    public string Class { get; set; } = string.Empty;
    public int Level { get; set; } = 1;
    public AbilityScores AbilityScores { get; set; } = new();
    public string? Background { get; set; }
    public string? Alignment { get; set; }
}

public class AbilityScores
{
    public int Strength { get; set; }
    public int Dexterity { get; set; }
    public int Constitution { get; set; }
    public int Intelligence { get; set; }
    public int Wisdom { get; set; }
    public int Charisma { get; set; }
}
