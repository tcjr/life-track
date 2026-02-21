import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { tracked } from '@glimmer/tracking';
import type { BpMeasurement } from '#app/models/measurements/bp.ts';
import type { GlucoseMeasurement } from '#app/models/measurements/glucose.ts';
import type { Meal } from '#app/models/measurements/meal.ts';
import { scaleTime } from 'd3-scale';

function localTime(date: Date) {
  const dtf = new Intl.DateTimeFormat('en-US', {
    hour: 'numeric',
    minute: 'numeric',
    hour12: true,
  });
  return dtf.format(date);
}

type DailyItem =
  | { type: 'bp'; item: BpMeasurement }
  | { type: 'meal'; item: Meal }
  | { type: 'glucose'; item: GlucoseMeasurement };

interface DayTimelineSignature {
  Args: {
    items: DailyItem[];
  };
  Element: HTMLDivElement;
}

export default class DayTimeline extends Component<DayTimelineSignature> {
  get scaleX() {
    // Use any of the items since they're all the same day
    // const start = new Date(this.args.items[0].item.timestamp);
    // start.setHours(0, 0, 0, 0);
    // const end = new Date(
    //   this.args.items[this.args.items.length - 1].item.timestamp
    // );
    // end.setHours(23, 59, 59, 999);

    // assume they are sorted by timestamp
    const start = this.args.items[0].item.timestamp;
    const end = this.args.items[this.args.items.length - 1].item.timestamp;

    return scaleTime([start, end], [0, 960]);
  }

  getX = (date: Date) => {
    return this.scaleX(date);
  };

  <template>
    <div class="" ...attributes>
      {{!-- <div class="border border-1">
        {{#each @items as |dailyItem|}}
          [{{dailyItem.type}}]
          {{localTime dailyItem.item.timestamp}}
          (x:
          {{this.getX dailyItem.item.timestamp}})
        {{/each}}
      </div> --}}
      <div class="border border-1 relative min-h-14">
        {{#each @items as |dailyItem|}}
          <div
            class="absolute"
            style="left:{{this.getX dailyItem.item.timestamp}}px"
          >
            [{{dailyItem.type}}]
            {{!localTime dailyItem.item.timestamp}}

          </div>

        {{/each}}
      </div>
    </div>
  </template>
}
