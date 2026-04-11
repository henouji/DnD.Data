using DnD.Api.Data;
using DnD.Api.Data.Entities;
using DnD.Api.Models.Campaigns;
using Microsoft.EntityFrameworkCore;

namespace DnD.Api.Services;

public class CampaignService : ICampaignService
{
    private readonly AppDbContext _context;

    public CampaignService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<CampaignResponse>> GetAllAsync()
    {
        var campaigns = await _context.Campaigns
            .Include(c => c.CampaignCharacters)
            .ToListAsync();
        return campaigns.Select(MapToResponse);
    }

    public async Task<CampaignResponse?> GetByIdAsync(int id)
    {
        var campaign = await _context.Campaigns
            .Include(c => c.CampaignCharacters)
            .FirstOrDefaultAsync(c => c.Id == id);
        return campaign is null ? null : MapToResponse(campaign);
    }

    public async Task<CampaignResponse> CreateAsync(CreateCampaignRequest request)
    {
        var campaign = new Campaign
        {
            Name = request.Name,
            Description = request.Description,
            DungeonMaster = request.DungeonMaster,
            CreatedAt = DateTime.UtcNow
        };
        _context.Campaigns.Add(campaign);
        await _context.SaveChangesAsync();
        return MapToResponse(campaign);
    }

    public async Task<(CampaignResponse? Campaign, string? Error)> UpdateAsync(int id, UpdateCampaignRequest request)
    {
        var campaign = await _context.Campaigns
            .Include(c => c.CampaignCharacters)
            .FirstOrDefaultAsync(c => c.Id == id);
        if (campaign is null) return (null, "Campaign not found.");

        campaign.Name = request.Name;
        campaign.Description = request.Description;
        campaign.DungeonMaster = request.DungeonMaster;
        campaign.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();
        return (MapToResponse(campaign), null);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var campaign = await _context.Campaigns.FindAsync(id);
        if (campaign is null) return false;
        _context.Campaigns.Remove(campaign);
        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<(bool Success, string? Error)> AddCharacterAsync(int campaignId, AddCharacterToCampaignRequest request)
    {
        var campaign = await _context.Campaigns.FindAsync(campaignId);
        if (campaign is null) return (false, "Campaign not found.");

        var character = await _context.Characters.FindAsync(request.CharacterId);
        if (character is null) return (false, "Character not found.");

        var alreadyAdded = await _context.CampaignCharacters
            .AnyAsync(cc => cc.CampaignId == campaignId && cc.CharacterId == request.CharacterId);
        if (alreadyAdded) return (false, "Character is already in this campaign.");

        _context.CampaignCharacters.Add(new CampaignCharacter
        {
            CampaignId = campaignId,
            CharacterId = request.CharacterId,
            JoinedAt = DateTime.UtcNow
        });
        await _context.SaveChangesAsync();
        return (true, null);
    }

    public async Task<(bool Success, string? Error)> RemoveCharacterAsync(int campaignId, int characterId)
    {
        var entry = await _context.CampaignCharacters
            .FirstOrDefaultAsync(cc => cc.CampaignId == campaignId && cc.CharacterId == characterId);
        if (entry is null) return (false, "Character is not in this campaign.");
        _context.CampaignCharacters.Remove(entry);
        await _context.SaveChangesAsync();
        return (true, null);
    }

    private static CampaignResponse MapToResponse(Campaign c) => new()
    {
        Id = c.Id,
        Name = c.Name,
        Description = c.Description,
        DungeonMaster = c.DungeonMaster,
        CharacterIds = c.CampaignCharacters.Select(cc => cc.CharacterId).ToList(),
        CreatedAt = c.CreatedAt,
        UpdatedAt = c.UpdatedAt
    };
}
