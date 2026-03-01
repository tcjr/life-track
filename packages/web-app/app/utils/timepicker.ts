// import 'timepicker-ui/main.css';
import { TimepickerUI } from 'timepicker-ui';
import { modifier } from 'ember-modifier';

function parseTimeToDate(timeString: string): Date {
  const match = timeString.match(/^(\d{2}):(\d{2})\s(AM|PM)$/);

  if (!match) {
    throw new Error(
      `Invalid time format: "${timeString}". Expected "hh:mm AM/PM".`
    );
  }

  let hours = parseInt(match[1] as string, 10);
  const minutes = parseInt(match[2] as string, 10);
  const period = match[3] as string;

  if (hours < 1 || hours > 12) {
    throw new Error(`Invalid hours: ${hours}. Must be between 01 and 12.`);
  }
  if (minutes < 0 || minutes > 59) {
    throw new Error(`Invalid minutes: ${minutes}. Must be between 00 and 59.`);
  }

  // Convert to 24-hour format
  if (period === 'AM') {
    if (hours === 12) hours = 0; // 12:xx AM -> 00:xx (midnight)
  } else {
    if (hours !== 12) hours += 12; // 01:xx PM -> 13:xx, but 12:xx PM stays as 12
  }

  const date = new Date();
  date.setHours(hours, minutes, 0, 0);

  return date;
}

const initTimePicker = modifier((element: HTMLInputElement) => {
  const picker = new TimepickerUI(element, {
    //labels: { time: 'Now', mobileTime: 'Now' },
  });
  picker.create();

  return () => {
    picker?.destroy();
  };
});

export { initTimePicker, parseTimeToDate };
