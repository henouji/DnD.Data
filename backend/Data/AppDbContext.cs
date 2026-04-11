using DnD.Api.Data.Entities;
using Microsoft.EntityFrameworkCore;

namespace DnD.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Character> Characters => Set<Character>();
    public DbSet<Campaign> Campaigns => Set<Campaign>();
    public DbSet<CampaignCharacter> CampaignCharacters => Set<CampaignCharacter>();
    public DbSet<Spell> Spells => Set<Spell>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<CampaignCharacter>()
            .HasKey(cc => new { cc.CampaignId, cc.CharacterId });

        modelBuilder.Entity<CampaignCharacter>()
            .HasOne(cc => cc.Campaign)
            .WithMany(c => c.CampaignCharacters)
            .HasForeignKey(cc => cc.CampaignId);

        modelBuilder.Entity<CampaignCharacter>()
            .HasOne(cc => cc.Character)
            .WithMany(c => c.CampaignCharacters)
            .HasForeignKey(cc => cc.CharacterId);
    }
}
