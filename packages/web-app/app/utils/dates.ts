const ISO_DATE_REGEX = /^\d{4}-\d{2}-\d{2}$/;

const dtf = new Intl.DateTimeFormat('en-US', {
  weekday: 'short',
  year: 'numeric',
  month: 'numeric',
  day: 'numeric',
  hour: 'numeric',
  minute: 'numeric',
});

const df = new Intl.DateTimeFormat('en-US', {
  weekday: 'short',
  year: 'numeric',
  month: 'numeric',
  day: 'numeric',
});

const ttf = new Intl.DateTimeFormat('en-US', {
  hour: 'numeric',
  minute: 'numeric',
});

const parseDate = (d: Date | string): Date => {
  const date =
    typeof d === 'string'
      ? ISO_DATE_REGEX.test(d)
        ? toStartOfLocalDay(d)
        : new Date(d)
      : d;

  if (isNaN(date.getTime())) {
    throw new Error('Invalid date: ' + d);
  }
  return date;
};

const asLocal = (input: Date | string) => {
  const date = parseDate(input);
  return dtf.format(date);
};

const asLocalTime = (input: Date | string) => {
  const date = parseDate(input);
  return ttf.format(date);
};

const asLocalDate = (input: Date | string) => {
  const date = parseDate(input);
  return df.format(date);
};

const asYYYYMMDD = (timestamp: Date | string) => {
  const date = parseDate(timestamp);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

const toStartOfLocalDay = (dateStr: string) => {
  const [year, month, day] = dateStr.split('-').map(Number);
  if (year === undefined || month === undefined || day === undefined) {
    throw new Error(`Invalid date string: ${dateStr}`);
  }
  return new Date(year, month - 1, day, 0, 0, 0, 0);
};

const toEndOfLocalDay = (dateStr: string) => {
  const [year, month, day] = dateStr.split('-').map(Number);
  if (year === undefined || month === undefined || day === undefined) {
    throw new Error(`Invalid date string: ${dateStr}`);
  }
  return new Date(year, month - 1, day, 23, 59, 59, 999);
};

export {
  asLocal,
  asLocalTime,
  asLocalDate,
  asYYYYMMDD,
  toStartOfLocalDay,
  toEndOfLocalDay,
};
