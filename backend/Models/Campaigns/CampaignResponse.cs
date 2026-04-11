namespace DnD.Api.Models.Campaigns;

public class CampaignResponse
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string? DungeonMaster { get; set; }
    public List<int> CharacterIds { get; set; } = new();
    public DateTime CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}
