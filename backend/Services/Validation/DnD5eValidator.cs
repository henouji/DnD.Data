namespace DnD.Api.Services.Validation;

public static class DnD5eValidator
{
    private static readonly HashSet<string> ValidRaces = new(StringComparer.OrdinalIgnoreCase)
    {
        "Dragonborn", "Dwarf", "Elf", "Gnome", "Half-Elf", "Halfling", "Half-Orc", "Human", "Tiefling"
    };

    private static readonly HashSet<string> ValidClasses = new(StringComparer.OrdinalIgnoreCase)
    {
        "Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk",
        "Paladin", "Ranger", "Rogue", "Sorcerer", "Warlock", "Wizard"
    };

    private static readonly HashSet<string> ValidAlignments = new(StringComparer.OrdinalIgnoreCase)
    {
        "Lawful Good", "Neutral Good", "Chaotic Good",
        "Lawful Neutral", "True Neutral", "Chaotic Neutral",
        "Lawful Evil", "Neutral Evil", "Chaotic Evil"
    };

    private static readonly HashSet<string> ValidMagicSchools = new(StringComparer.OrdinalIgnoreCase)
    {
        "Abjuration", "Conjuration", "Divination", "Enchantment",
        "Evocation", "Illusion", "Necromancy", "Transmutation"
    };

    public static ValidationResult ValidateRace(string race)
    {
        if (string.IsNullOrWhiteSpace(race))
            return ValidationResult.Failure("Race is required.");
        if (!ValidRaces.Contains(race))
            return ValidationResult.Failure($"'{race}' is not a valid DnD 5e race. Valid races: {string.Join(", ", ValidRaces)}.");
        return ValidationResult.Success();
    }

    public static ValidationResult ValidateClass(string characterClass)
    {
        if (string.IsNullOrWhiteSpace(characterClass))
            return ValidationResult.Failure("Class is required.");
        if (!ValidClasses.Contains(characterClass))
            return ValidationResult.Failure($"'{characterClass}' is not a valid DnD 5e class. Valid classes: {string.Join(", ", ValidClasses)}.");
        return ValidationResult.Success();
    }

    public static ValidationResult ValidateLevel(int level)
    {
        if (level < 1 || level > 20)
            return ValidationResult.Failure("Level must be between 1 and 20.");
        return ValidationResult.Success();
    }

    public static ValidationResult ValidateAbilityScore(int score, string scoreName)
    {
        if (score < 1 || score > 30)
            return ValidationResult.Failure($"{scoreName} must be between 1 and 30.");
        return ValidationResult.Success();
    }

    public static ValidationResult ValidateAlignment(string? alignment)
    {
        if (string.IsNullOrWhiteSpace(alignment))
            return ValidationResult.Success(); // alignment is optional
        if (!ValidAlignments.Contains(alignment))
            return ValidationResult.Failure($"'{alignment}' is not a valid DnD 5e alignment.");
        return ValidationResult.Success();
    }

    public static ValidationResult ValidateMagicSchool(string school)
    {
        if (string.IsNullOrWhiteSpace(school))
            return ValidationResult.Failure("Magic school is required.");
        if (!ValidMagicSchools.Contains(school))
            return ValidationResult.Failure($"'{school}' is not a valid DnD 5e magic school.");
        return ValidationResult.Success();
    }

    public static ValidationResult ValidateSpellLevel(int level)
    {
        if (level < 0 || level > 9)
            return ValidationResult.Failure("Spell level must be between 0 (cantrip) and 9.");
        return ValidationResult.Success();
    }
}

public class ValidationResult
{
    public bool IsValid { get; private set; }
    public string? Error { get; private set; }

    private ValidationResult(bool isValid, string? error = null)
    {
        IsValid = isValid;
        Error = error;
    }

    public static ValidationResult Success() => new(true);
    public static ValidationResult Failure(string error) => new(false, error);
}
