import Component from '@glimmer/component';

interface DatePartsStrings {
  weekday: string;
  year: string;
  month: string;
  day: string;
  dayPeriod: string;
  hour: string;
  minute: string;
  second: string;
  timeZoneName: string;
}

export interface DatePartsSignature {
  Args: {
    date: Date | string;
  };
  Blocks: {
    default: [parts: DatePartsStrings];
  };
  Element: null;
}

export default class DateParts extends Component<DatePartsSignature> {
  get parts() {
    const df = new Intl.DateTimeFormat('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: 'numeric',
      minute: 'numeric',
      second: 'numeric',
      timeZoneName: 'short',
    });

    const parts: DatePartsStrings = {
      weekday: '',
      year: '',
      month: '',
      day: '',
      dayPeriod: '',
      hour: '',
      minute: '',
      second: '',
      timeZoneName: '',
    };

    const partsArray = df.formatToParts(new Date(this.args.date));
    partsArray.forEach((part) => {
      // Only use the parts we care about (no literals)
      if (part.type in parts) {
        parts[part.type as keyof DatePartsStrings] = part.value;
      }
    });

    return parts;
  }

  <template>{{yield this.parts}}</template>
}
