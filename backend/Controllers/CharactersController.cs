using DnD.Api.Models.Characters;
using DnD.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace DnD.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class CharactersController : ControllerBase
{
    private readonly ICharacterService _characterService;

    public CharactersController(ICharacterService characterService)
    {
        _characterService = characterService;
    }

    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<CharacterResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll()
    {
        var characters = await _characterService.GetAllAsync();
        return Ok(characters);
    }

    [HttpGet("{id:int}")]
    [ProducesResponseType(typeof(CharacterResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetById(int id)
    {
        var character = await _characterService.GetByIdAsync(id);
        return character is null ? NotFound() : Ok(character);
    }

    [HttpPost]
    [ProducesResponseType(typeof(CharacterResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> Create([FromBody] CreateCharacterRequest request)
    {
        var (character, error) = await _characterService.CreateAsync(request);
        if (error is not null) return BadRequest(error);
        return CreatedAtAction(nameof(GetById), new { id = character!.Id }, character);
    }

    [HttpDelete("{id:int}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Delete(int id)
    {
        var deleted = await _characterService.DeleteAsync(id);
        return deleted ? NoContent() : NotFound();
    }
}
