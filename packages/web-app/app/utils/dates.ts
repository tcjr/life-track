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

const dowf = new Intl.DateTimeFormat('en-US', {
  weekday: 'long',
});

const mdf = new Intl.DateTimeFormat('en-US', {
  month: 'long',
  day: 'numeric',
});

const asLocal = (date: Date) => {
  return dtf.format(date);
};

const asLocalTime = (date: Date) => {
  return ttf.format(date);
};

const asLocalDate = (date: Date) => {
  return df.format(date);
};

const asDow = (date: Date) => {
  return dowf.format(date);
};

const asMonthDay = (date: Date) => {
  return mdf.format(date);
};

const asYYYYMMDD = (timestamp: Date) => {
  const date = new Date(timestamp);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

const asISO = (timestamp: Date) => {
  if (!timestamp) {
    return '';
  }
  return timestamp.toISOString();
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
  asISO,
  asDow,
  asMonthDay,
  toStartOfLocalDay,
  toEndOfLocalDay,
};
