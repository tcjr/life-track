import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { pageTitle } from 'ember-page-title';
import type { BpMeasurement } from '#app/models/measurements/bp';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose';
import type Owner from '@ember/owner';
import type FirebaseService from '#app/services/firebase.ts';
import { service } from '@ember/service';
import { collections } from '#app/models/collections.ts';
import { LinkTo } from '@ember/routing';

const dtf = new Intl.DateTimeFormat('en-US', {
  weekday: 'short',
  year: 'numeric',
  month: 'numeric',
  day: 'numeric',
  hour: 'numeric',
  minute: 'numeric',
});

const asLocal = (date: Date) => {
  return dtf.format(date);
};

const randomBetween = (min: number, max: number) => {
  const minCeiled = Math.ceil(min);
  const maxFloored = Math.floor(max);
  return Math.floor(Math.random() * (maxFloored - minCeiled + 1) + minCeiled);
};

export interface MeasurementsSignature {
  Args: { model: unknown };
  Element: HTMLDivElement;
}

export default class Measurements extends Component<MeasurementsSignature> {
  @service declare firebase: FirebaseService;
  @tracked allBps: BpMeasurement[] = [];
  @tracked allGlucoses: GlucoseMeasurement[] = [];

  constructor(owner: Owner, args: MeasurementsSignature['Args']) {
    super(owner, args);
    void this.loadBps();
    void this.loadGlucoses();
  }

  get uid() {
    return this.firebase.signedInUser!.uid || '';
  }

  loadBps = async () => {
    console.log('loading bps');
    const bps = await collections['app-users'](this.uid).bps.findMany({
      name: 'all-bps',
      limit: 100,
    });
    this.allBps = bps;
  };

  loadGlucoses = async () => {
    console.log('loading glucoses');
    const glucoses = await collections['app-users'](this.uid).glucoses.findMany(
      {
        name: 'all-glucoses',
        limit: 100,
      }
    );
    this.allGlucoses = glucoses;
  };

  addBpData = async () => {
    await collections['app-users'](this.uid).bps.add({
      diastolic: randomBetween(120, 150),
      systolic: randomBetween(80, 100),
      heartRate: randomBetween(70, 110),
      timestamp: new Date(),
    });
  };

  <template>
    {{pageTitle "Measurements"}}
    <div ...attributes>
      <h1>Measurements</h1>
      <LinkTo @route="authenticated.new-bp" class="link">New BP...</LinkTo>
      <table class="table">
        <thead>
          <tr>
            <th>BP</th>
            <th>HR</th>
            <th>Timestamp</th>
          </tr>
        </thead>
        <tbody>
          {{#each this.allBps as |bp|}}
            <tr>
              <td>
                {{bp.diastolic}}/{{bp.systolic}}
              </td>
              <td>
                {{bp.heartRate}}
              </td>
              <td>
                {{asLocal bp.timestamp}}
              </td>
            </tr>
          {{/each}}
        </tbody>
      </table>

      <LinkTo @route="authenticated.new-glucose" class="link">New Glucose...</LinkTo>

      <table class="table">
        <thead>
          <tr>
            <th>Glucose</th>
            <th>Timestamp</th>
          </tr>
        </thead>
        <tbody>
          {{#each this.allGlucoses as |glucose|}}
            <tr>
              <td>
                {{glucose.value}}
              </td>
              <td>
                {{asLocal glucose.timestamp}}
              </td>
            </tr>
          {{/each}}
        </tbody>
      </table>
    </div>
  </template>
}
