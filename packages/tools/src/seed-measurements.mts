import { type Collections } from 'zod-firebase-admin';
import { text, confirm, log, progress } from '@clack/prompts';
import setup, { schema } from './utils/setup.mts';
import { chooseUser } from './utils/choose-user.mts';

function sleep(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function randomInRange(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function addDays(date: Date, days: number) {
  const DAY_MS = 1000 * 60 * 60 * 24;
  const newTime = date.getTime() + days * DAY_MS;
  return new Date(newTime);
}

function createTimestampForDay(
  dayOffset: number,
  nearHour = 8,
  nearMinute = 30,
): Date {
  const today = new Date();
  const targetDate = addDays(today, -dayOffset);

  targetDate.setHours(nearHour, nearMinute, 0, 0);

  const jitter = randomInRange(-30, 30);
  targetDate.setMinutes(targetDate.getMinutes() + jitter);

  return targetDate;
}

async function addBpPair(
  userCollection: Collections<(typeof schema)['app-users']>,
  time: Date,
) {
  const systolic = randomInRange(110, 140);
  const diastolic = randomInRange(70, 90);
  const heartRate = randomInRange(60, 80);

  await userCollection.bps.add({
    systolic,
    diastolic,
    heartRate,
    timestamp: time,
  });

  // 2nd one is a minute or two later
  const time2 = new Date(time.getTime() + randomInRange(1, 2) * 60 * 1000);
  const systolic2 = randomInRange(110, 140);
  const diastolic2 = randomInRange(70, 90);
  const heartRate2 = randomInRange(60, 80);

  await userCollection.bps.add({
    systolic: systolic2,
    diastolic: diastolic2,
    heartRate: heartRate2,
    timestamp: time2,
  });
}

async function main() {
  const { collections } = await setup();

  const userId = await chooseUser();

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
    message: `Create glucose and BP measurements for the previous ${numDays} days for user ${userId}?`,
  });

  if (!shouldProceed) {
    console.log('Canceled. No data created.');
    return;
  }

  log.info(`Creating measurements for ${numDays} days...`);

  const userCollection = collections['app-users'](userId);

  const plog = progress({ max: numDays });
  plog.start('Creating measurements...');
  for (let i = 0; i < numDays; i++) {
    const morningTimestamp = createTimestampForDay(i, 8, 30);
    const eveningTimestamp = createTimestampForDay(i, 22, 15);

    const glucoseValue = randomInRange(80, 140);
    await userCollection.glucoses.add({
      value: glucoseValue,
      timestamp: morningTimestamp,
    });

    await addBpPair(userCollection, morningTimestamp);
    await addBpPair(userCollection, eveningTimestamp);

    await sleep(150);
    plog.advance(1, `Day ${i + 1}/${numDays} done`);
  }

  plog.stop(
    `Successfully created glucose / BP measurements for ${numDays} days.`,
  );
}

await main();
