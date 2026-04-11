namespace DnD.Api.Data.Entities;

public class Campaign
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string? DungeonMaster { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
    public List<CampaignCharacter> CampaignCharacters { get; set; } = new();
}
