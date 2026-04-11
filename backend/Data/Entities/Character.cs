namespace DnD.Api.Data.Entities;

public class Character
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Race { get; set; } = string.Empty;
    public string Class { get; set; } = string.Empty;
    public int Level { get; set; }
    public int Strength { get; set; }
    public int Dexterity { get; set; }
    public int Constitution { get; set; }
    public int Intelligence { get; set; }
    public int Wisdom { get; set; }
    public int Charisma { get; set; }
    public string? Background { get; set; }
    public string? Alignment { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<CampaignCharacter> CampaignCharacters { get; set; } = new();
}
