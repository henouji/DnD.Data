using DnD.Api.Models.Campaigns;
using DnD.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace DnD.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CampaignsController : ControllerBase
{
    private readonly ICampaignService _campaignService;

    public CampaignsController(ICampaignService campaignService)
    {
        _campaignService = campaignService;
    }

    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<CampaignResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll()
    {
        var campaigns = await _campaignService.GetAllAsync();
        return Ok(campaigns);
    }

    [HttpGet("{id:int}")]
    [ProducesResponseType(typeof(CampaignResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id)
    {
        var campaign = await _campaignService.GetByIdAsync(id);
        return campaign is null ? NotFound() : Ok(campaign);
    }

    [HttpPost]
    [ProducesResponseType(typeof(CampaignResponse), StatusCodes.Status201Created)]
    public async Task<IActionResult> Create([FromBody] CreateCampaignRequest request)
    {
        var campaign = await _campaignService.CreateAsync(request);
        return CreatedAtAction(nameof(GetById), new { id = campaign.Id }, campaign);
    }

    [HttpPut("{id:int}")]
    [ProducesResponseType(typeof(CampaignResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(int id, [FromBody] UpdateCampaignRequest request)
    {
        var (campaign, error) = await _campaignService.UpdateAsync(id, request);
        if (campaign is null) return NotFound();
        if (error is not null) return BadRequest(error);
        return Ok(campaign);
    }

    [HttpDelete("{id:int}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await _campaignService.DeleteAsync(id);
        return deleted ? NoContent() : NotFound();
    }

    [HttpPost("{campaignId:int}/characters")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> AddCharacter(int campaignId, [FromBody] AddCharacterToCampaignRequest request)
    {
        var (success, error) = await _campaignService.AddCharacterAsync(campaignId, request);
        if (!success) return BadRequest(error);
        return Ok();
    }

    [HttpDelete("{campaignId:int}/characters/{characterId:int}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> RemoveCharacter(int campaignId, int characterId)
    {
        var (success, error) = await _campaignService.RemoveCharacterAsync(campaignId, characterId);
        if (!success) return BadRequest(error);
        return NoContent();
    }
}
