import { select, text, confirm } from '@clack/prompts';
import setup from './utils/setup.mts';

function addDays(date: Date, days: number) {
  const DAY_MS = 1000 * 60 * 60 * 24;
  const newTime = date.getTime() + days * DAY_MS;
  return new Date(newTime);
}

async function main() {
  const { collections } = await setup();

  const noticeText = (await text({
    message: 'What is the notice text?',
    placeholder: 'Your attention please...',
  })) as string;

  const howLong = (await select({
    message: 'How long should this notice be active?',
    options: [
      { value: 1, label: 'One day' },
      { value: 7, label: 'One week' },
      { value: 30, label: 'One month' },
      { value: 365, label: 'One year' },
    ],
  })) as number;

  const shouldProceed = await confirm({
    message: `Create this notification?`,
  });

  if (shouldProceed) {
    console.log('Creating notice...');
    const untilDate = addDays(new Date(), howLong);

    const newNoticeRef = await collections.notices.add({
      text: noticeText,
      validFrom: new Date(),
      validTo: untilDate,
    });

    console.log(`New notice created: ${newNoticeRef.id}`);
  } else {
    console.log('Canceled. Notification not created.');
  }
}

await main();
