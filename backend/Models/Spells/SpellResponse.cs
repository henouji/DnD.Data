namespace DnD.Api.Models.Spells;

public class SpellResponse
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public int Level { get; set; }
    public string School { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string? CastingTime { get; set; }
    public string? Range { get; set; }
    public string? Duration { get; set; }
    public bool Concentration { get; set; }
    public bool Ritual { get; set; }
}
