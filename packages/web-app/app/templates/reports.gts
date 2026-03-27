import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import { FirestoreDocument } from '#resources/firestore-document';
import { use } from 'ember-resources';

interface ReportsSignature {
  Args: {
    model: {
      report_id: string;
    };
  };
}

export default class PublicReport extends Component<ReportsSignature> {
  @use report = FirestoreDocument('reports', () => this.args.model.report_id);

  <template>
    {{#if this.report}}
      {{pageTitle this.report.title}}
      <div
        class="p-8 max-w-4xl mx-auto space-y-8 bg-white shadow-lg min-h-screen"
      >
        <header class="border-b pb-4">
          <h1 class="text-3xl font-bold">{{this.report.title}}</h1>
          <p class="text-gray-600">
            Report Period:
            {{this.report.startDate.toLocaleDateString}}
            -
            {{this.report.endDate.toLocaleDateString}}
          </p>
          <p class="text-sm text-gray-400">Created on:
            {{this.report.createdAt.toLocaleDateString}}</p>
        </header>

        {{#if this.report.data.bps.length}}
          <section>
            <h2 class="text-xl font-semibold mb-2">Blood Pressure</h2>
            <table class="table table-zebra w-full">
              <thead>
                <tr>
                  <th>Date/Time</th>
                  <th>Systolic</th>
                  <th>Diastolic</th>
                  <th>HR</th>
                </tr>
              </thead>
              <tbody>
                {{#each this.report.data.bps as |bp|}}
                  <tr>
                    <td>{{bp.timestamp.toLocaleString}}</td>
                    <td>{{bp.systolic}}</td>
                    <td>{{bp.diastolic}}</td>
                    <td>{{bp.heartRate}}</td>
                  </tr>
                {{/each}}
              </tbody>
            </table>
          </section>
        {{/if}}

        {{#if this.report.data.glucoses.length}}
          <section>
            <h2 class="text-xl font-semibold mb-2">Glucose</h2>
            <table class="table table-zebra w-full">
              <thead>
                <tr>
                  <th>Date/Time</th>
                  <th>Value</th>
                </tr>
              </thead>
              <tbody>
                {{#each this.report.data.glucoses as |glucose|}}
                  <tr>
                    <td>{{glucose.timestamp.toLocaleString}}</td>
                    <td>{{glucose.value}}</td>
                  </tr>
                {{/each}}
              </tbody>
            </table>
          </section>
        {{/if}}

        {{#if this.report.data.meals.length}}
          <section>
            <h2 class="text-xl font-semibold mb-2">Meals</h2>
            <table class="table table-zebra w-full">
              <thead>
                <tr>
                  <th>Date/Time</th>
                  <th>Notes</th>
                </tr>
              </thead>
              <tbody>
                {{#each this.report.data.meals as |meal|}}
                  <tr>
                    <td>{{meal.timestamp.toLocaleString}}</td>
                    <td>{{meal.notes}}</td>
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
