using DnD.Api.Models.Spells;
using DnD.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace DnD.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class SpellsController : ControllerBase
{
    private readonly ISpellService _spellService;

    public SpellsController(ISpellService spellService)
    {
        _spellService = spellService;
    }

    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<SpellResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll()
    {
        var spells = await _spellService.GetAllAsync();
        return Ok(spells);
    }

    [HttpGet("{id:int}")]
    [ProducesResponseType(typeof(SpellResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id)
    {
        var spell = await _spellService.GetByIdAsync(id);
        return spell is null ? NotFound() : Ok(spell);
    }

    [HttpGet("level/{level:int}")]
    [ProducesResponseType(typeof(IEnumerable<SpellResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetByLevel(int level)
    {
        var spells = await _spellService.GetByLevelAsync(level);
        return Ok(spells);
    }

    [HttpPost]
    [ProducesResponseType(typeof(SpellResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Create([FromBody] SpellRequest request)
    {
        var (spell, error) = await _spellService.CreateAsync(request);
        if (error is not null) return BadRequest(error);
        return CreatedAtAction(nameof(GetById), new { id = spell!.Id }, spell);
    }

    [HttpDelete("{id:int}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await _spellService.DeleteAsync(id);
        return deleted ? NoContent() : NotFound();
    }
}
