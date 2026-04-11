namespace DnD.Api.Data.Entities;

public class CampaignCharacter
{
    public int CampaignId { get; set; }
    public Campaign Campaign { get; set; } = null!;
    public int CharacterId { get; set; }
    public Character Character { get; set; } = null!;
    public DateTime JoinedAt { get; set; }
}
