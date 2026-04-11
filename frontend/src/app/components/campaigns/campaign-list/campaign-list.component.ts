import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CampaignService } from '../../../services/campaign.service';
import { CampaignResponse } from '../../../models/campaign.model';

@Component({
  selector: 'app-campaign-list',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './campaign-list.component.html'
})
export class CampaignListComponent implements OnInit {
  campaigns: CampaignResponse[] = [];
  errorMessage = '';

  constructor(private campaignService: CampaignService) {}

  ngOnInit(): void {
    this.campaignService.getAll().subscribe({
      next: (data) => { this.campaigns = data; },
      error: () => { this.errorMessage = 'Failed to load campaigns.'; }
    });
  }

  delete(id: number): void {
    this.campaignService.delete(id).subscribe({
      next: () => { this.campaigns = this.campaigns.filter(c => c.id !== id); },
      error: () => { this.errorMessage = 'Failed to delete campaign.'; }
    });
  }
}
