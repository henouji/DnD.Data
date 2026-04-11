namespace DnD.Api.Models.Campaigns;

public class UpdateCampaignRequest
{
    public string Name { get; set; } = string.Empty;
    public string? Description { get; set; }
    public string? DungeonMaster { get; set; }
}
