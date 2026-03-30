import Component from '@glimmer/component';
import { pageTitle } from 'ember-page-title';
import { FirestoreDocument } from '#resources/firestore-document';
import { use } from 'ember-resources';
import { asLocal } from '#app/utils/dates.ts';

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
            {{asLocal this.report.startDate}}
            -
            {{asLocal this.report.endDate}}
          </p>
          {{!-- <p class="text-sm text-base-content/70">Created on:
            {{asLocal this.report.createdAt}}</p> --}}
        </header>

        {{#if this.report.bps.length}}
          <section>
            <h2 class="text-xl font-semibold mb-2">Blood Pressure / Heart Rate</h2>
            <table class="table table-zebra w-full">
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
                    <td><div aria-label="status" class="status"></div></td>
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
            <table class="table table-zebra w-full">
              <thead>
                <tr>
                  <th>Date/Time</th>
                  <th>Value</th>
                </tr>
              </thead>
              <tbody>
                {{#each this.report.glucoses as |glucose|}}
                  <tr>
                    <td>{{asLocal glucose.timestamp}}</td>
                    <td>{{glucose.value}}</td>
                  </tr>
                {{/each}}
              </tbody>
            </table>
          </section>
        {{/if}}

        {{#if this.report.meals.length}}
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
                {{#each this.report.meals as |meal|}}
                  <tr>
                    <td>{{asLocal meal.timestamp}}</td>
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
