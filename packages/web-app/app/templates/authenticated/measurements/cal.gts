import MonthList from '#app/components/month-list.gts';
import Component from '@glimmer/component';
import '@event-calendar/core/index.css';
import type MeasurementDataService from '#app/services/measurement-data.ts';
import { service } from '@ember/service';

export interface CalendarSignature {
  Element: HTMLDivElement;
}

export default class MeasurementsCalendar extends Component<CalendarSignature> {
  @service declare measurementData: MeasurementDataService;

  <template>
    <div ...attributes>
      <h3 class="text-3xl font-bold text-center mb-5">(calendar)</h3>
      <MonthList @measurements={{this.measurementData.allMeasurements}} />
    </div>
  </template>
}
