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
import DayTimeline from '#app/components/day-timeline.gts';
import type { Meal } from '#app/models/measurements/meal.ts';

/**
 * Return a string in the form YYYY-MM-DD that represents the given date in the
 * local timezone.
 */
function asLocalDate(date: Date) {
  const dtf = new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  });
  const [month, , day, , year] = dtf.formatToParts(date);
  return `${year?.value}-${month?.value}-${day?.value}`;
}

function localTime(date: Date) {
  const dtf = new Intl.DateTimeFormat('en-US', {
    hour: 'numeric',
    minute: 'numeric',
    hour12: true,
  });
  return dtf.format(date);
}

function eq<T>(a: T, b: T) {
  return a === b;
}

interface BpItemSignature {
  Args: { bp: BpMeasurement };
}
const BpItem = <template>
  <div class="badge badge-outline">
    {{localTime @bp.timestamp}}
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
  <div class="badge badge-outline">
    {{localTime @glucose.timestamp}}
    Glucose:
    {{@glucose.value}}
  </div>
</template> satisfies TOC<GlucoseItemSignature>;

interface MealItemSignature {
  Args: { meal: Meal };
}
const MealItem = <template>
  <div class="badge">
    {{localTime @meal.timestamp}}
    Meal
    {{#if @meal.notes}}
      ({{@meal.notes}})
    {{/if}}
  </div>
</template> satisfies TOC<MealItemSignature>;

export interface MeasurementsSignature {
  Args: { model: unknown };
  Element: HTMLDivElement;
}

type TypedTrackable =
  | { type: 'bp'; item: BpMeasurement }
  | { type: 'glucose'; item: GlucoseMeasurement }
  | { type: 'meal'; item: Meal };

export default class Measurements extends Component<MeasurementsSignature> {
  @service declare firebase: FirebaseService;
  @tracked allBps: BpMeasurement[] = [];
  @tracked allGlucoses: GlucoseMeasurement[] = [];
  @tracked allMeals: Meal[] = [];

  constructor(owner: Owner, args: MeasurementsSignature['Args']) {
    super(owner, args);
    void this.loadAllData();
  }

  get uid() {
    return this.firebase.uid;
  }

  loadAllData = async () => {
    const [bps, glucoses, meals] = await Promise.all([
      collections['app-users'](this.uid).bps.findMany({
        name: 'all-bps',
        limit: 1000,
        orderBy: [['timestamp', 'desc']],
      }),
      collections['app-users'](this.uid).glucoses.findMany({
        name: 'all-glucoses',
        limit: 1000,
        orderBy: [['timestamp', 'desc']],
      }),
      collections['app-users'](this.uid).meals.findMany({
        name: 'all-meals',
        limit: 1000,
        orderBy: [['timestamp', 'desc']],
      }),
    ]);
    this.allBps = bps;
    this.allGlucoses = glucoses;
    this.allMeals = meals;
  };

  /*
    Returns the data in allGlucoses and allBps grouped by day.  It should have
    this format:

    [
      {
        date: "2022-02-19", // This is a calendar date in the local timezone
        items: [
          // These are sorted by timestamp ascending
          {
            type: "bp", 
            item: {
              systolic: 120,
              diastolic: 80,
              heartRate: 70,
              timestamp: TS
            },
          },
          { type: "gluclose", item: { ... } },
          { type: "gluclose", item: { ... } },
          { type: "bp", item: { ... } }
        ],
      }
      ...
    ]
  */
  get measurementsByDay() {
    const combined: TypedTrackable[] = [
      ...this.allBps.map((bp) => ({ type: 'bp' as const, item: bp })),
      ...this.allGlucoses.map((glucose) => ({
        type: 'glucose' as const,
        item: glucose,
      })),
      ...this.allMeals.map((meal) => ({ type: 'meal' as const, item: meal })),
    ];

    const byDay: Record<string, TypedTrackable[]> = {};

    for (const measurement of combined) {
      const yyyymmdd = asLocalDate(measurement.item.timestamp);
      if (!byDay[yyyymmdd]) {
        byDay[yyyymmdd] = [];
      }
      byDay[yyyymmdd].push(measurement);
    }

    return Object.entries(byDay)
      .map(([date, items]) => ({
        date,
        items: items.sort(
          (a, b) => a.item.timestamp.getTime() - b.item.timestamp.getTime()
        ),
      }))
      .sort((a, b) => b.date.localeCompare(a.date));
  }

  <template>
    {{pageTitle "Measurements"}}
    {{log "EVERYTHING" this.measurementsByDay}}
    <div ...attributes>
      <h1 class="text-3xl font-bold">Recent Items</h1>
      <div class="text-right">
        <a href="/new-measurement" class="btn btn-primary">Add New...</a>

      </div>

      <ul class="list bg-base-100 rounded-box shadow-md">
        {{#each this.measurementsByDay as |day|}}
          <li class="list-row">
            <div>{{day.date}}</div>
            <div>
              <div>
                {{#each day.items as |dm|}}
                  {{!
                  I think we might be able to clean up the type errors here by
                  using a helpers?
                }}
                  {{#if (eq dm.type "bp")}}
                    {{! @glint-expect-error We know it's a bp, but glint doesn't }}
                    <BpItem @bp={{dm.item}} />
                  {{else if (eq dm.type "glucose")}}
                    {{! @glint-expect-error We know it's a glucose, but glint doesn't }}
                    <GlucoseItem @glucose={{dm.item}} />
                  {{else if (eq dm.type "meal")}}
                    <MealItem @meal={{dm.item}} />
                  {{/if}}

                {{/each}}
              </div>
              <DayTimeline @items={{day.items}} />
            </div>
          </li>
        {{/each}}
      </ul>

    </div>
  </template>
}
