import setup from './utils/setup.mts';

async function main() {
  const { collections } = await setup();

  const allNotices = await collections.notices.findMany({
    name: 'all notices',
  });

  console.table(allNotices);
}

await main();
