const dtf = new Intl.DateTimeFormat('en-US', {
  weekday: 'short',
  year: 'numeric',
  month: 'numeric',
  day: 'numeric',
  hour: 'numeric',
  minute: 'numeric',
});

const ttf = new Intl.DateTimeFormat('en-US', {
  hour: 'numeric',
  minute: 'numeric',
});

const asLocal = (date: Date) => {
  return dtf.format(date);
};

const asLocalTime = (date: Date) => {
  return ttf.format(date);
};

const asYYYYMMDD = (timestamp: Date) => {
  const date = new Date(timestamp);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

const toStartOfLocalDay = (dateStr: string) => {
  const [year, month, day] = dateStr.split('-').map(Number) as [
    number,
    number,
    number,
  ];
  return new Date(year, month - 1, day, 0, 0, 0, 0);
};

const toEndOfLocalDay = (dateStr: string) => {
  const [year, month, day] = dateStr.split('-').map(Number) as [
    number,
    number,
    number,
  ];
  return new Date(year, month - 1, day, 23, 59, 59, 999);
};

export { asLocal, asLocalTime, asYYYYMMDD, toStartOfLocalDay, toEndOfLocalDay };
