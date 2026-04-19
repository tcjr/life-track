import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import { pageTitle } from 'ember-page-title';
import { use } from 'ember-resources';
import { FirestoreQuery } from '#resources/firestore-query';
import { httpsCallable } from 'firebase/functions';
import type FirebaseService from '#app/services/firebase';
import {
  toStartOfLocalDay,
  toEndOfLocalDay,
  asLocalDate,
} from '#app/utils/dates.ts';
import type { FlashMessagesService } from 'ember-cli-flash';
import ChartLine from '~icons/custom/chart-line.svg';

export default class Reports extends Component {
  @service declare firebase: FirebaseService;
  @service declare flashMessages: FlashMessagesService;

  @tracked title = '';
  @tracked startDate = '';
  @tracked endDate = '';
  @tracked showBps = true;
  @tracked showGlucoses = true;
  @tracked showWeights = true;
  @tracked isCreating = false;

  @use reports = FirestoreQuery('reports', () => ({
    name: 'user reports',
    limit: 20,
    orderBy: [['createdAt', 'desc']],
    where: [['userId', '==', this.firebase.uid]],
    verbose: true,
  }));

  updateForm = (event: Event) => {
    const form = event.currentTarget as HTMLFormElement;
    const formData = new FormData(form);

    this.title = (formData.get('title') as string) ?? '';
    this.startDate = (formData.get('startDate') as string) ?? '';
    this.endDate = (formData.get('endDate') as string) ?? '';
    this.showBps = formData.has('showBps');
    this.showGlucoses = formData.has('showGlucoses');
    this.showWeights = formData.has('showWeights');
  };

  createReport = async (event: Event) => {
    event.preventDefault();
    if (this.isCreating) return;

    this.isCreating = true;
    try {
      const createReportFn = httpsCallable<
        {
          title: string;
          startDate: string;
          endDate: string;
          measurements: string[];
        },
        { id: string }
      >(this.firebase.functions, 'createReport');

      const measurements = [];
      if (this.showBps) {
        measurements.push('bps');
      }
      if (this.showGlucoses) {
        measurements.push('glucoses');
      }
      if (this.showWeights) {
        measurements.push('weights');
      }

      const result = await createReportFn({
        title: this.title,
        startDate: toStartOfLocalDay(this.startDate).toISOString(),
        endDate: toEndOfLocalDay(this.endDate).toISOString(),
        measurements,
      });

      console.log('Report created:', result.data.id);
      this.flashMessages.success(`Report "${this.title}" created`);

      // Reset form state
      // this.title = '';
      // this.startDate = '';
      // this.endDate = '';
      // this.showBps = true;
      // this.showGlucoses = true;

      // (event.target as HTMLFormElement).reset();
    } catch (error) {
      console.error('Failed to create report:', error);
      alert('Failed to create report. See console for details.');
    } finally {
      this.isCreating = false;
    }
  };

  <template>
    {{pageTitle "Reports"}}
    <div class="p-4 space-y-8">
      <section class="bg-base-100 p-6 rounded-box shadow-md">
        <h2 class="text-2xl font-bold mb-4">Create New Report</h2>
        <form
          {{on "submit" this.createReport}}
          {{on "input" this.updateForm}}
          {{on "change" this.updateForm}}
          class="space-y-4"
        >
          <div class="form-control">
            <label class="label" for="report-title">
              <span class="label-text">Report Title</span>
            </label>
            <input
              id="report-title"
              name="title"
              type="text"
              class="input input-bordered w-full"
              placeholder="e.g., March 2026 Health Summary"
              value={{this.title}}
              required
            />
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div class="form-control">
              <label class="label" for="start-date">
                <span class="label-text">Start Date</span>
              </label>
              <input
                id="start-date"
                name="startDate"
                type="date"
                class="input input-bordered w-full"
                value={{this.startDate}}
                required
              />
            </div>
            <div class="form-control">
              <label class="label" for="end-date">
                <span class="label-text">End Date</span>
              </label>
              <input
                id="end-date"
                name="endDate"
                type="date"
                class="input input-bordered w-full"
                value={{this.endDate}}
                required
              />
            </div>
          </div>

          <div class="form-control">
            <span class="label-text mb-2">Include Measurements</span>
            <div class="flex flex-wrap gap-4">
              <label class="label cursor-pointer space-x-2">
                <input
                  type="checkbox"
                  name="showBps"
                  class="checkbox"
                  checked={{this.showBps}}
                />
                <span class="label-text">BP/HR</span>
              </label>
              <label class="label cursor-pointer space-x-2">
                <input
                  type="checkbox"
                  name="showGlucoses"
                  class="checkbox"
                  checked={{this.showGlucoses}}
                />
                <span class="label-text">Glucose</span>
              </label>
              <label class="label cursor-pointer space-x-2">
                <input
                  type="checkbox"
                  name="showWeights"
                  class="checkbox"
                  checked={{this.showWeights}}
                />
                <span class="label-text">Weight</span>
              </label>
            </div>
          </div>

          <button
            type="submit"
            class="btn btn-primary w-full"
            disabled={{this.isCreating}}
          >
            {{if this.isCreating "Creating..." "Create Report"}}
          </button>
        </form>
      </section>

      <section>
        <h2 class="text-2xl font-bold mb-4 px-2">Your Reports</h2>
        <ul class="list bg-base-100 rounded-box shadow-md">
          {{!log "this.reports" this.reports}}
          {{#each this.reports as |report|}}
            <li class="list-row">
              <div>
                <ChartLine class="h-8" />
              </div>
              <div class="">
                <div class="font-bold">{{report.title}}</div>
                <div class="text-xs opacity-60">
                  {{asLocalDate report.startDate}}
                  -
                  {{asLocalDate report.endDate}}
                </div>
              </div>
              <div class="">
                <a
                  href="/reports/{{report._id}}"
                  class="link"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Public Link
                </a>
              </div>
            </li>
          {{else}}
            <li class="list-row">
              <div class="text-xs opacity-60">No reports found.</div>
            </li>
          {{/each}}
        </ul>
      </section>
    </div>
  </template>
}
