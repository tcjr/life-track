import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import { FirestoreDocument } from '#resources/firestore-document';
import { use } from 'ember-resources';
import { asLocal, asLocalDate } from '#app/utils/dates.ts';
import {
  BP_STATUS_CLASSES,
  getBpQuality,
  getGlucoseQuality,
  GLUCOSE_STATUS_CLASSES,
} from '#app/utils/measurements.ts';
import type { BpMeasurement } from '#app/models/measurements/bp.ts';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import GlucoseChart from '#components/glucose-chart.gts';
import GlucoseStats from '#app/components/glucose-stats.gts';
import BpChart from '#components/bp-chart.gts';
import BpStats from '#app/components/bp-stats.gts';

const bpStatus = (bp: Pick<BpMeasurement, 'systolic' | 'diastolic'>) =>
  BP_STATUS_CLASSES[getBpQuality(bp)];
const glucoseStatus = (glucose: Pick<GlucoseMeasurement, 'value'>) =>
  GLUCOSE_STATUS_CLASSES[getGlucoseQuality(glucose)];

interface ReportsSignature {
  Args: {
    model: {
      id: string;
    };
  };
}

export default class PublicReport extends Component<ReportsSignature> {
  @use report = FirestoreDocument('reports', () => this.args.model.id, {
    verbose: true,
  });

  <template>
    {{!log "@model" @model}}
    {{#if this.report}}
      {{pageTitle this.report.title}}
      <div
        class="p-8 max-w-4xl mx-auto space-y-8 bg-base-100 shadow-lg min-h-screen"
      >
        <header class="border-b pb-4">
          <h1 class="text-3xl font-bold">{{this.report.title}}</h1>
          <p class="text-base-content">
            Report Period:
            {{asLocalDate this.report.startDate}}
            -
            {{asLocalDate this.report.endDate}}
          </p>
          {{!-- <p class="text-sm text-base-content/70">Created on:
            {{asLocal this.report.createdAt}}</p> --}}
        </header>

        {{#if this.report.bps.length}}
          <section>
            <h2 class="text-xl font-semibold mb-2">Blood Pressure / Heart Rate</h2>
            <BpStats @bps={{this.report.bps}} />
            <BpChart @bps={{this.report.bps}} />
            <table class="table table-zebra table-xs w-full">
              <thead>
                <tr>
                  <th> </th>
                  <th>Date/Time</th>
                  <th>Systolic</th>
                  <th>Diastolic</th>
                  <th>HR</th>
                </tr>
              </thead>
              <tbody>
                {{#each this.report.bps as |bp|}}
                  <tr>
                    <td><div
                        aria-label="status"
                        class="status {{bpStatus bp}}"
                      ></div></td>
                    <td>{{asLocal bp.timestamp}}</td>
                    <td>{{bp.systolic}}</td>
                    <td>{{bp.diastolic}}</td>
                    <td>{{bp.heartRate}}</td>
                  </tr>
                {{/each}}
              </tbody>
            </table>
          </section>
        {{/if}}

        {{#if this.report.glucoses.length}}
          <section>
            <h2 class="text-xl font-semibold mb-2">Glucose</h2>
            <GlucoseStats @glucoses={{this.report.glucoses}} />
            <GlucoseChart @glucoses={{this.report.glucoses}} />
            <table class="table table-zebra table-xs w-full">
              <thead>
                <tr>
                  <th> </th>
                  <th>Date/Time</th>
                  <th>Value</th>
                </tr>
              </thead>
              <tbody>
                {{#each this.report.glucoses as |glucose|}}
                  <tr>
                    <td><div
                        aria-label="status"
                        class="status {{glucoseStatus glucose}}"
                      ></div></td>
                    <td>{{asLocal glucose.timestamp}}</td>
                    <td>{{glucose.value}}</td>
                  </tr>
                {{/each}}
              </tbody>
            </table>
          </section>
        {{/if}}
      </div>
    {{else}}
      <div class="p-8 text-center">
        <p>Loading report or report not found...</p>
      </div>
    {{/if}}
  </template>
}
