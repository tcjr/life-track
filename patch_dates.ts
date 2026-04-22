import fs from 'fs';

let content = fs.readFileSync('packages/web-app/app/utils/dates.ts', 'utf-8');

const parseHelper = `
const parseDate = (d: Date | string) => {
  if (typeof d === 'string') {
    if (/^\\d{4}-\\d{2}-\\d{2}$/.test(d)) {
      return toStartOfLocalDay(d);
    }
    return new Date(d);
  }
  return d;
};
`;

content = content.replace('const asLocal = (date: Date) => {', parseHelper + '\nconst asLocal = (date: Date | string) => {\n  date = parseDate(date);');
content = content.replace('const asLocalTime = (date: Date) => {', 'const asLocalTime = (date: Date | string) => {\n  date = parseDate(date);');
content = content.replace('const asLocalDate = (date: Date) => {', 'const asLocalDate = (date: Date | string) => {\n  date = parseDate(date);');
content = content.replace('const asYYYYMMDD = (timestamp: Date) => {', 'const asYYYYMMDD = (timestamp: Date | string) => {\n  const date = parseDate(timestamp);');
content = content.replace('  const date = new Date(timestamp);\n', '');

fs.writeFileSync('packages/web-app/app/utils/dates.ts', content);
