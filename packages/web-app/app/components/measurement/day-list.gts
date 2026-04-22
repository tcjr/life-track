import Component from '@glimmer/component';
import Glucose from '#app/components/measurement/glucose.gts';
import Bp from '#app/components/measurement/bp.gts';
import Weight from '#app/components/measurement/weight.gts';
import { eq } from 'ember-truth-helpers';
import DateParts from '#app/components/date-parts.gts';
import type { BpKind, GlucoseKind, WeightKind } from './types';

interface DayListSignature {
  Args: {
    days: Map<string, (BpKind | GlucoseKind | WeightKind)[]>;
  };
}

export default class DayList extends Component<DayListSignature> {
  <template>
    <div class="flex flex-col bg-base-100">
      {{#each-in @days as |day mwks|}}
        <div
          class="flex flex-row justify-between border border-base-300 rounded px-3 py-2 mt-2 bg-primary text-primary-content"
        >
          <DateParts @date={{day}} as |d|>
            <div>
              {{d.weekday}}
            </div>
            <div>
              {{d.month}}
              {{d.day}}
            </div>
          </DateParts>
        </div>

        <div class="flex flex-col gap-2">
          {{#each mwks as |measurementWithKind|}}
            {{#if (eq measurementWithKind.kind "glucose")}}
              {{! @glint-expect-error: narrowing should work here}}
              <Glucose @measurement={{measurementWithKind.measurement}} />
            {{/if}}
            {{#if (eq measurementWithKind.kind "bp")}}
              {{! @glint-expect-error: narrowing should work here}}
              <Bp @measurement={{measurementWithKind.measurement}} />
            {{/if}}
            {{#if (eq measurementWithKind.kind "weight")}}
              {{! @glint-expect-error: narrowing should work here}}
              <Weight @measurement={{measurementWithKind.measurement}} />
            {{/if}}
          {{/each}}
        </div>

      {{/each-in}}
    </div>
  </template>
}
