import { text, confirm } from '@clack/prompts';
import setup from './utils/setup.mts';

//const USER_ID = 'dev-user';
const USER_ID = '83m720LJbS6zpq9NORydMqi8e8eg';

function randomInRange(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function addDays(date: Date, days: number) {
  const DAY_MS = 1000 * 60 * 60 * 24;
  const newTime = date.getTime() + days * DAY_MS;
  return new Date(newTime);
}

function createTimestampForDay(dayOffset: number): Date {
  const today = new Date();
  const targetDate = addDays(today, -dayOffset);

  targetDate.setHours(8, 30, 0, 0);

  const jitter = randomInRange(-30, 30);
  targetDate.setMinutes(targetDate.getMinutes() + jitter);

  return targetDate;
}

async function main() {
  const { collections } = await setup();

  const daysInput = (await text({
    message: 'How many days of data do you want to create?',
    placeholder: '10',
  })) as string;

  const numDays = parseInt(daysInput, 10);

  if (isNaN(numDays) || numDays <= 0) {
    console.log('Invalid number of days. Please enter a positive number.');
    return;
  }

  const shouldProceed = await confirm({
    message: `Create glucose and BP measurements for the previous ${numDays} days?`,
  });

  if (!shouldProceed) {
    console.log('Canceled. No data created.');
    return;
  }

  console.log(`Creating measurements for ${numDays} days...`);

  const userCollection = collections['app-users'](USER_ID);

  for (let i = 0; i < numDays; i++) {
    const timestamp = createTimestampForDay(i);

    const glucoseValue = randomInRange(80, 140);
    await userCollection.glucoses.add({
      value: glucoseValue,
      timestamp,
    });

    const systolic = randomInRange(110, 140);
    const diastolic = randomInRange(70, 90);
    const heartRate = randomInRange(60, 80);

    await userCollection.bps.add({
      systolic,
      diastolic,
      heartRate,
      timestamp,
    });

    const secondTimestamp = new Date(timestamp.getTime() + randomInRange(1, 2) * 60 * 1000);
    const systolic2 = randomInRange(110, 140);
    const diastolic2 = randomInRange(70, 90);
    const heartRate2 = randomInRange(60, 80);

    await userCollection.bps.add({
      systolic: systolic2,
      diastolic: diastolic2,
      heartRate: heartRate2,
      timestamp: secondTimestamp,
    });

    console.log(
      `Day ${i + 1}/${numDays}: ${timestamp.toISOString()} - Glucose: ${glucoseValue}, BP: ${systolic}/${diastolic} (HR: ${heartRate}), BP2: ${systolic2}/${diastolic2} (HR: ${heartRate2})`,
    );
  }

  console.log(
    `Successfully created ${numDays} glucose and ${numDays * 2} BP measurements.`,
  );
}

await main();
