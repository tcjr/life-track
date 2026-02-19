import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { pageTitle } from 'ember-page-title';
import type { BpMeasurement } from '#app/models/measurements/bp';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose';
import type Owner from '@ember/owner';
import type FirebaseService from '#app/services/firebase.ts';
import { service } from '@ember/service';
import { collections } from '#app/models/collections.ts';
import type { TOC } from '@ember/component/template-only';

const dtf = new Intl.DateTimeFormat('en-US', {
  weekday: 'short',
  year: 'numeric',
  month: 'numeric',
  day: 'numeric',
  hour: 'numeric',
  minute: 'numeric',
});

interface BpItemSignature {
  Args: { bp: BpMeasurement };
}
const BpItem = <template>
  <div class="badge badge-info">
    BP:
    {{@bp.systolic}}/{{@bp.diastolic}}
    HR:
    {{@bp.heartRate}}
  </div>
</template> satisfies TOC<BpItemSignature>;

interface GlucoseItemSignature {
  Args: { glucose: GlucoseMeasurement };
}
const GlucoseItem = <template>
  <div class="badge badge-success">
    Glucose:
    {{@glucose.value}}
  </div>
</template> satisfies TOC<GlucoseItemSignature>;

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
    return this.firebase.uid;
  }

  loadBps = async () => {
    const bps = await collections['app-users'](this.uid).bps.findMany({
      name: 'all-bps',
      limit: 100,
      orderBy: [['timestamp', 'desc']],
    });
    this.allBps = bps;
  };

  loadGlucoses = async () => {
    const glucoses = await collections['app-users'](this.uid).glucoses.findMany(
      {
        name: 'all-glucoses',
        limit: 100,
        orderBy: [['timestamp', 'desc']],
      }
    );
    this.allGlucoses = glucoses;
  };

  /*
    Returns the data in allGlucoses and allBps grouped by day.  It should have
    this format:

    [
      {
        date: "2022-02-19", // This is a calendar date
        bps: [
          {
            systolic: 120,
            diastolic: 80,
            heartRate: 70,
            timestamp: TS // This is the timestamp from the db
          }
          ...
        ],
        glucoses: [
          {
            value: 120,
            timestamp: TS // This is the timestamp from the db
          }
          ...
        ]
      }
      ...
    ]
  */
  get measurementsByDay() {
    const grouped: Record<
      string,
      { date: string; bps: BpMeasurement[]; glucoses: GlucoseMeasurement[] }
    > = {};

    for (const bp of this.allBps) {
      const date = bp.timestamp.toISOString().split('T')[0] || 'NO DATE';
      if (!grouped[date]) {
        grouped[date] = { date, bps: [], glucoses: [] };
      }
      grouped[date].bps.push(bp);
    }

    for (const glucose of this.allGlucoses) {
      const date = glucose.timestamp.toISOString().split('T')[0] || 'NO DATE';
      if (!grouped[date]) {
        grouped[date] = { date, bps: [], glucoses: [] };
      }
      grouped[date].glucoses.push(glucose);
    }

    const result = Object.values(grouped);
    result.sort((a, b) => b.date.localeCompare(a.date));

    return result;
  }

  <template>
    {{pageTitle "Measurements"}}
    {{log "EVERYTHING" this.measurementsByDay}}
    <div ...attributes>
      <h1>Measurements</h1>
      <a href="/new-measurement" class="link">New Measurement...</a>
      <hr />

      <ul class="list bg-base-100 rounded-box shadow-md">
        {{#each this.measurementsByDay as |day|}}
          <li class="list-row">
            <div>{{day.date}}</div>
            <div>
              {{#each day.bps as |bp|}}
                <BpItem @bp={{bp}} />
              {{/each}}
              {{#each day.glucoses as |glucose|}}
                <GlucoseItem @glucose={{glucose}} />
              {{/each}}
            </div>
          </li>
        {{/each}}
      </ul>

    </div>
  </template>
}
