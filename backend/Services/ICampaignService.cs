using DnD.Api.Models.Campaigns;

namespace DnD.Api.Services;

public interface ICampaignService
{
    Task<IEnumerable<CampaignResponse>> GetAllAsync();
    Task<CampaignResponse?> GetByIdAsync(int id);
    Task<CampaignResponse> CreateAsync(CreateCampaignRequest request);
    Task<(CampaignResponse? Campaign, string? Error)> UpdateAsync(int id, UpdateCampaignRequest request);
    Task<bool> DeleteAsync(int id);
    Task<(bool Success, string? Error)> AddCharacterAsync(int campaignId, AddCharacterToCampaignRequest request);
    Task<(bool Success, string? Error)> RemoveCharacterAsync(int campaignId, int characterId);
}
